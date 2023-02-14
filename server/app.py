from flask import Flask, render_template, request, redirect, url_for, session
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import hashlib
from datetime import datetime
import json
from flask_cors import CORS
# from flask_ngrok import run_with_ngrok
from matplotlib.font_manager import json_dump
app = Flask(__name__)
CORS(app, supports_credentials=True, expose_headers="Set-Cookie")
# run_with_ngrok(app)
app.secret_key = 'Tahve bqltuyej tbrjereq qobfd MvIaTq cmanmvpcuxsz iesh tihkel CnTu dretpyauritompeanstd '
#data to change after login is created Web 221,432

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'mouly123'
app.config['MYSQL_DB'] = 'mitradb'
app.config['MYSQL_PORT'] = 3306
app.config["SESSION_COOKIE_SAMESITE"] = "None"
app.config["SESSION_COOKIE_SECURE"] = True

# app.config['MYSQL_HOST'] = 'brooklyn-db.mysql.database.azure.com'
# app.config['MYSQL_USER'] = 'brooklyn'
# app.config['MYSQL_PASSWORD'] = 'root@123'
# app.config['MYSQL_DB'] = 'mit_users'
# app.config['MYSQL_PORT'] = 3306

mysql = MySQL(app)

#for getting notifictaion
@app.route('/getNotification',methods=['POST'])
def getnotification():
    email = session['email']
    usertype=session['utype']
    returner={"status":"false"}
    if(usertype in ['student','RC','Teacher']):
        query = f'SELECT * FROM complaints WHERE email={email} AND check_flag=0 AND (status="Resolved" OR status="unable to resolved") '
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(query)
        complaints=cursor.fetchall()
        if(complaints):
            blocks=[]
            floors=[]
            rooms=[]
            complaint=[]
            status=[]
            for com in complaints:
                    blocks.append(com[2])
                    floors.append(com[3])
                    rooms.append(com[4])
                    complaint.append(com[5])
                    status.append(com[7])
            returner["status"]=True
            returner["complaint"]={
            "block":blocks,
            "floor":floors,
            "room":rooms,
            "complaint":complaint,
            "status":status
        }
    elif(usertype in ['electrician','civil and maintenance','educational aid']):
        query = 'SELECT * FROM complaints WHERE complainttype=%s  AND status="Registered" AND check_flag=0 '
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(query,usertype)
        complaints=cursor.fetchall()
        if(complaints):
            blocks=[]
            floors=[]
            rooms=[]
            complaint=[]
            for com in complaints:
                blocks.append(com[2])
                floors.append(com[3])
                rooms.append(com[4])
                complaint.append(com[5])
        returner["status"]=True
        returner["complaint"]={
            "block":blocks,
            "floor":floors,
            "room":rooms,
            "complaint":complaint
        }
    return returner
               
@app.route("/getcomplainttype",methods=['Post'])
def getcomplaint():
    domaintype = request.json['Domaintype']
    returner = {}
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if(domaintype == 'college'):
        cursor.execute("Select Distinct complainttype from complaintslist")
        complainttype = cursor.fetchall()
        returner["complainttype"] = complainttype
        cursor.execute("Select Distinct block from roomdata")
        complainttype = cursor.fetchall()
        returner["block"] = complainttype
    else:
        cursor.execute("Select Distinct complainttype from hcomplaintslist")
        complainttype = cursor.fetchall()
        returner["complainttype"] = complainttype
        cursor.execute("Select Distinct block from hroomdata")
        complainttype = cursor.fetchall()
        returner["block"] = complainttype
    return returner
@app.route("/admin_college_viewcomplaint",methods = ['POST'])
def viewComp():
    returner = {}
    complaintType = request.json["complaintType"]
    Time = request.json["Time"]
    Block = request.json["Block"]
    queryComplaint =  " "if(complaintType=="All")  else f"AND complainttype='{complaintType}' "
    queryTime = " "if (Time=="All") else  f" AND cts='{Time}'"
    queryBlock = " "if(Block == 'All')  else f" AND block='{Block}'"
    query ="SELECT * FROM complaints WHERE complaintid is not null "
    query = query + queryComplaint + queryTime + queryBlock
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(query)
    complaint = cursor.fetchall()
    returner["complaint"] = complaint
    return returner
    # if():
        
    # complaint = cursor.fetchall()
@app.route("/admin_hostel_viewcomplaint",methods = ['POST'])
def viewhComp():
    returner = {}
    complaintType = request.json["complaintType"]
    Time = request.json["Time"]
    Block = request.json["Block"]
    queryComplaint =  " "if(complaintType=="All")  else f"AND complainttype={complaintType} "
    queryTime = " "if (Time=="All") else  f" AND cts={Time}"
    queryBlock = " "if(Block == 'All')  else f" AND block={Block}"
    query ="SELECT * FROM hcomplaints WHERE complaintid is not null"
    query = query + queryComplaint  + queryTime + queryBlock
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute(query)
    complaint = cursor.fetchall()
    returner["complaint"] = complaint
    return returner

@app.route('/login', methods=['POST'])
def login():
    email = request.json.get('email')
    password = request.json.get('password')
    hash_object = hashlib.sha256(password.encode('ascii'))
    hash_password = hash_object.hexdigest()
    print(hash_password)
    returner = {}
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM accounts WHERE email = %s AND hash = %s', (email, hash_password,))
    account = cursor.fetchone()
    if account:
        session['loggedin'] = True
        session['id'] = account['id']
        session['email'] = account['email']
        session['username'] = account['username']
        session['utype']=account['utype']
        session['subtype']=account['subtype']
        returner['status']="login success"
        returner['username'] = account['username']
        returner['utype']=account['utype']
        redirect("/" + account['utype'].lower())
        returner['subtype'] = account['subtype']
    else:
        returner['status']="login failure"
        returner['utype']="None"
    return returner
        
@app.route('/logout', methods=['POST'])
def logout():
   returner = {}
   session.pop('loggedin', None)
   session.pop('email', None)
   session.pop('id', None)
   session.pop('username', None)
   session.pop('utype', None)
   session.pop('subtype', None)
   returner['status']="logout success"
   return returner
   
@app.route('/register', methods=['POST'])
def register():
    returner = {}
    username = request.json.get('username')
    password = request.json.get('password')
    email = request.json.get('email')
    utype = request.json.get('utype')
    subtype = request.json.get('subtype')
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM accounts WHERE email = %s', (email,))
    account = cursor.fetchone()
    hash_object = hashlib.sha256(password.encode('ascii'))
    hash_password = hash_object.hexdigest()   
    if account:
        returner['status']= 'Account already exists'
    elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
        returner['status']=  'Invalid email address'
    elif not re.match(r'[A-Za-z0-9]+', username):
        returner['status']=  'Username must contain only characters and numbers!'
    elif not username or not password or not email:
        returner['status']=  'Please fill out the form'
    else:
            cursor.execute('INSERT INTO accounts VALUES (NULL, %s, %s, %s, %s, %s)', (username, hash_password, email,utype,subtype))
            mysql.connection.commit()
            returner['status']=  'You have successfully registered!'
    return returner


#errorFetch
@app.route('/errorFetch',methods=['POST'])
def errorfetch():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("Select error from reporterror")
    returner = {}
    data1 = cursor.fetchall()
    data1 = list(data1)
    returner['data'] = data1
    return returner

@app.route('/college_registercomplaint', methods=['POST'])
def regcomplaint():
    # print('Hi')
    returner = {}
    data1 = {}
    # if ( session['loggedin'] == False ):
    #      returner['status']= 'Only Logged in candidates can issue a Complaint.'
    #      return returner
    # elif ( session['subtype'] == 'electrician' or session['subtype'] == 'civil and maintenance' or session['subtype'] == 'education aid' ):
    #     returner['status']= 'Only Student and Teachers can issue a Complaint.'
    #     return returner
    # else:
    if(1):
         email=session['email']
         utype=session['utype']
         Block = request.json.get('Block')
         Floor = request.json.get('Floor')
         RoomNo = request.json.get('RoomNo')
         complainttype = request.json.get('complainttype')
         complainttype=complainttype.lower()
         Complaint = request.json.get('Complaint')
         cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
         if (Block == "None"):
          cursor.execute('SELECT Block FROM roomdata group by Block',) 
          data1 = cursor.fetchall()
          data1 = list(data1)
          returner['status']= "get Block"
          returner['data'] = data1
          return returner
         elif (Floor == "None"):
             cursor.execute(f'SELECT Floor FROM roomdata WHERE Block = "{Block}" group by floor')
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['status']= "get Floor"
             returner['data'] = data1
             return returner
         elif (RoomNo == "None"):
             cursor.execute('SELECT RoomNo FROM roomdata WHERE Block = %s and Floor = %s', (Block,Floor,))
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['status']= "get RoomNo"
             returner['data'] = data1
             return returner
         elif (complainttype == "None"):
             cursor.execute('SELECT complainttype FROM complaintslist group by complainttype')
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['status']= "get complainttype"
             returner['data'] = data1
             return returner
         elif (Complaint == "None"):
             cursor.execute('SELECT complaints FROM complaintslist where complainttype = %s',(complainttype, ))
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['data'] = data1
             returner['status']= "get complaint"
             return returner
         cursor.execute('SELECT status FROM complaints where block = %s and roomno = %s and floor = %s and complaint = %s', (Block, RoomNo, Floor, Complaint,))
         sts = cursor.fetchall()
         if sts:
            sts = json.dumps(sts)
            if 'Registered' in sts:
                returner['status'] = 'Complaint already exists!'
                return returner
         timenow = datetime.now()
         cts = timenow.strftime("%d/%m/%y %H:%M:%S")
        #  cursor.execute('INSERT INTO complaints VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,%s)', (session['email'], Block, int(Floor), RoomNo, Complaint, complainttype, "Registered", cts, cts, session['utype'],0))
         cursor.execute('INSERT INTO complaints VALUES (NULL,%s, %s, %s, %s, %s, %s, %s, %s, %s, %s,%s)', (email, Block, int(Floor), RoomNo, Complaint, complainttype, "Registered", cts, cts, utype,0))
         
         mysql.connection.commit()
         returner['cts']=cts
         returner['status']=  'You have successfully registered a Complaint.'
         return returner

# /view_complaint
@app.route('/college_viewcomplaint', methods=['POST'])
def viewcomplaint():
    returner = {}
    if ( session['loggedin'] == False ):
         returner['status']= 'Only Logged in candidates can view a Complaint.'
    else:
        if (session['subtype'] == 'admin'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status, utype,cts,uts from complaints")
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner
        elif (session['utype'] == 'Student' or session['subtype'] == 'Teacher' or session['subtype']=='RC'):
            if (session['utype'] == 'Student'):
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status,cts, uts from complaints where email=%s", (session['email'],))
                cmpl = cursor.fetchall()
                cmpl = list(cmpl)
                returner['complaint'] = cmpl
                return returner
            elif (session['subtype'] == 'Teacher' or session['subtype']=='RC'):
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status,cts, uts from complaints where email=%s", (session['email'],))
                cmpl = cursor.fetchall()
                cmpl = list(cmpl)
                returner['complaint'] = cmpl
                
                return returner
        elif (session['subtype'] == 'electrician'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, complaints.block, floor, roomno, complaint, complainttype, status,cts, uts from complaints where complainttype = %s ",(session['subtype'],))
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner
        elif (session['subtype'] == 'civil and maintenance'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, complaints.block, floor, roomno, complaint, complainttype, status,cts, uts from complaints, users where complaints.complainttype = %s ",(session['utype'],))
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner
        elif (session['subtype'] == 'education aid'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, complaints.block, floor, roomno, complaint, complainttype, status, cts, uts from complaints, users where complaints.complainttype = %s ",(session['utype'],))
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner
        else:
               cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
               cursor.execute("select complaintid, complaints.block, floor, roomno, complaint, complainttype, status, cts, uts from complaints, users where complaints.block = users.block and users.utype= %s; ",(session['utype'],))
               cmpl = cursor.fetchall()
               cmpl = list(cmpl)
               returner['complaint'] = cmpl
               return returner

# /change_complaint_status [viewed/resolved/verified]
@app.route('/college_change_complaint_status', methods=['POST'])
def change_complaint_status():
    returner = {}
    if ( session['loggedin'] == False ):
         returner['status']= 'Only Logged in candidates can change complaint status.'
    else:
        num = request.json.get('complaintid')
        Status = request.json.get('Status')
        if (session['utype']=='Student' or session['subtype']=='Teacher' or session['subtype']=='RC') : 
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status, uts from complaints where complaintid=%s and email=%s",(int(num),session['email'],))
            data1 = cursor.fetchone()
            if data1:
                timenow = datetime.now()
                uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                cursor.execute("update complaints set status=%s, uts=%s ,check_flag=0 WHERE complaintid=%s ",(Status, uts, num,))
                mysql.connection.commit()
                returner['status']=  'You have successfully changed the status.'
                return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        elif (session['subtype']=='electrician'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, complaints.block, floor, roomno, complaint, complainttype, status, uts from complaints where complainttype= %s and complaintid=%s ",(session['subtype'], num,))
            data = cursor.fetchone()
            if data:
                    timenow = datetime.now()
                    uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                    cursor.execute("update complaints set status=%s, uts=%s,check_flag=0 WHERE complaintid=%s ",(Status, uts, num,))
                    mysql.connection.commit()
                    returner['status']=  'You have successfully changed the status.'
                    return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        elif (session['subtype']=='education aid'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid,complaints.block, floor, roomno, complaint, complainttype, status, uts from complaints where complainttype= %s and complaintid=%s ",(session['subtype'], num,))
            data = cursor.fetchone()
            if data:
                timenow = datetime.now()
                uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                cursor.execute("update complaints set status=%s, uts=%s,check_flag=0 WHERE complaintid=%s ",(Status, uts, num,))
                mysql.connection.commit()
                returner['status']=  'You have successfully changed the status.'
                return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        elif (session['subtype']=='civil and maintenance'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid,block, floor, roomno, complaint, complainttype, status, uts from complaints where complainttype= %s and complaintid=%s ",(session['subtype'], num,))
            data = cursor.fetchone()
            if data:
                timenow = datetime.now()
                uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                cursor.execute("update complaints set status=%s, uts=%s,check_flag=0 WHERE complaintid=%s ",(Status, uts, num,))
                mysql.connection.commit()
                returner['status']=  'You have successfully changed the status.'
                return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        elif(True):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, complaints.block, floor, roomno, complaint, complainttype, status, uts, utype from complaints where complaintid=%s and complaints.block = users.block and users.utype=%s ",(num,session['utype'],))
            data = cursor.fetchone()
            if data:
                if (Status =="Resolved"):
                    timenow = datetime.now()
                    uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                    cursor.execute("update complaints set status=%s, uts=%s,check_flag=0 WHERE complaintid=%s ",(Status, uts, num,))
                    mysql.connection.commit()
                    returner['status']=  'You have successfully changed the status.'
                    return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        returner['status']=  'The complainttype doesnt exist.'
        return returner

@app.route('/hostel_registercomplaint', methods=['POST'])
def hostel_regcomplaint():
    returner = {}
    data1 = {}
    print("Session: ", session)
    # if ( session['loggedin'] == False ):
    #      returner['status']= 'Only Logged in candidates can issue a Complaint.'
    # elif ( session['subtype'] == 'electrician' or session['utype'] == 'civil and maintenance' or session['utype']=='RC'):
    #     returner['status']= 'Only Student and RCs can issue a Complaint.'
    # elif (session['subtype']=='DayScholar'):
    #         returner['status']=='Only Hostellers can file Complaint'
    # elif (session['subtype']=='Teacher'):
    #         returner['status']=='Only RCs can file Complaint'
    # else:
    if(1):
         email=session['email']
         utype=session['utype']
         Block = request.json.get('Block')
         Floor = request.json.get('Floor')
         RoomNo = request.json.get('RoomNo')
         complainttype = request.json.get('complainttype')
         Complaint = request.json.get('Complaint')
         cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
         if (Block == "None"):
          cursor.execute('SELECT Block FROM hroomdata group by Block',) 
          data1 = cursor.fetchall()
          data1 = list(data1)
          returner['data'] = data1
          return returner
         elif (Floor == "None"):
             cursor.execute('SELECT Floor FROM hroomdata WHERE Block = %s group by floor' , (Block,))
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['data'] = data1
             return returner
         elif (RoomNo == "None"):
             cursor.execute('SELECT RoomNo FROM hroomdata WHERE Block = %s and Floor = %s', (Block,Floor,))
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['data'] = data1
             return returner
         elif (complainttype == "None"):
             cursor.execute('SELECT complainttype FROM hcomplaintslist group by complainttype')
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['data'] = data1
             return returner
         elif (Complaint == "None"):
             cursor.execute('SELECT complaints FROM hcomplaintslist where complainttype = %s',(complainttype, ))
             data1 = cursor.fetchall()
             data1 = list(data1)
             returner['data'] = data1
             return returner
         cursor.execute('SELECT status FROM hcomplaints where block = %s and roomno = %s and floor = %s and complaint = %s', (Block, RoomNo, Floor, Complaint,))
         sts = cursor.fetchall()
         if sts:
            sts = json.dumps(sts)
            if 'Registered' in sts:
                returner['status'] = 'Complaint already exists!'
                return returner
         timenow = datetime.now()
         cts = timenow.strftime("%d/%m/%y %H:%M:%S")
        #  cursor.execute('INSERT INTO hcomplaints VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (session['email'], Block, int(Floor), RoomNo, Complaint, complainttype, "Registered", cts, cts, session['utype'],))
         cursor.execute('INSERT INTO hcomplaints VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)', (email, Block, int(Floor), RoomNo, Complaint, complainttype, "Registered", cts, cts, utype,))
         mysql.connection.commit()
         returner['status']=  'You have successfully registered a Complaint.'
         returner['cts']=cts
         return returner

# /view_complaint
@app.route('/hostel_viewcomplaint', methods=['POST'])
def hviewcomplaint():
    returner = {}
    if ( session['loggedin'] == False ):
         returner['status']= 'Only Logged in candidates can view a Complaint.'
    else:
        if (session['subtype'] == 'admin'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status,cts,uts utype from hcomplaints")
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner
        elif (session['subtype'] == 'Hosteller' or session['subtype']=='RC'):
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status, cts,uts from hcomplaints where email=%s and status = 'Registered' or status = 'Resolved'", (session['email'],))
                cmpl = cursor.fetchall()
                cmpl = list(cmpl)
                returner['complaint'] = cmpl
                return returner
        elif (session['subtype'] == 'electrician'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, hcomplaints.block, floor, roomno, complaint, complainttype, status, cts,uts from hcomplaints where hcomplaints.complainttype = %s ",(session['subtype'],))
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner
        elif (session['subtype'] == 'civil and maintenance'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, hcomplaints.block, floor, roomno, complaint, complainttype, status,cts, uts from hcomplaints, where hcomplaints.complainttype = %s ",(session['subtype'],))
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner
        else:
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, hcomplaints.block, floor, roomno, complaint, complainttype, status,cts, uts from hcomplaints")
            cmpl = cursor.fetchall()
            cmpl = list(cmpl)
            returner['complaint'] = cmpl
            return returner

# /change_complaint_status [viewed/resolved/verified]
@app.route('/hostel_change_complaint_status', methods=['POST'])
def hchange_complaint_status():
    returner = {}
    if ( session['loggedin'] == False ):
         returner['status']= 'Only Logged in candidates can change complaint status.'
    else:
        num = request.json.get('complaintid')
        Status = request.json.get('Status')
        if (session['subtype']=='Hosteller' or session['subtype']=='RC'): 
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status, uts from hcomplaints where complaintid=%s and email=%s",(int(num),session['email'],))
            data1 = cursor.fetchone()
            if data1:
                timenow = datetime.now()
                uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                cursor.execute("update hcomplaints set status=%s, uts=%s WHERE complaintid=%s ",(Status, uts, num,))
                mysql.connection.commit()
                returner['status']=  'You have successfully changed the status.'
                return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        elif (session['subtype']=='electrician'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status, uts from hcomplaints where complainttype= %s and complaintid=%s ",(session['subtype'], num,))
            data = cursor.fetchone()
            if data:
                    timenow = datetime.now()
                    uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                    cursor.execute("update hcomplaints set status=%s, uts=%s WHERE complaintid=%s ",(Status, uts, num,))
                    mysql.connection.commit()
                    returner['status']=  'You have successfully changed the status.'
                    return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        elif (session['subtype']=='civil and maintenance'):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status, uts from complaints where complainttype= %s and complaintid=%s ",(session['subtype'], num,))
            data = cursor.fetchone()
            if data:
                timenow = datetime.now()
                uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                cursor.execute("update hcomplaints set status=%s, uts=%s WHERE complaintid=%s ",(Status, uts, num,))
                mysql.connection.commit()
                returner['status']=  'You have successfully changed the status.'
                return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        elif(True):
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("select complaintid, block, floor, roomno, complaint, complainttype, status, uts, utype from hcomplaints, where complaintid=%s and utype=%s ",(num,"Warden",))
            data = cursor.fetchone()
            if data:
                if (Status =="Resolved"):

                    timenow = datetime.now()
                    uts = timenow.strftime("%d/%m/%y %H:%M:%S")
                    cursor.execute("update hcomplaints set status=%s, uts=%s WHERE complaintid=%s ",(Status, uts, num,))
                    mysql.connection.commit()
                    returner['status']=  'You have successfully changed the status.'
                    return returner
            else:
                returner['status']=  'The complaintid doesnot exist.'
                return returner
        returner['status']=  'The complainttype doesnt exist.'
        return returner

#get number of resolved,registered,verified for profile info
@app.route('/getprofileinfo', methods=['POST'])
def getprofileinfo():
    # print('Hi')
    types=['verified','resolved','registered']
    email = request.json.get('email')
    returner = {}
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT count(status) as count FROM complaints WHERE email = %s group by status' , (email,))
    i=0
    for row in cursor:
        # print(type(row))
        returner[types[i]]=row.get('count')
        i+=1
    # op=cursor.fetchall()
    # print(op)
    return returner
@app.route('/getComplaints/admin', methods=['POST'])
def getCompAdmin():
    #arg=request.args
    category=request.json.get('category')
    print(session)
    if ( session['loggedin'] == False ):
         returner['status']= 'Only Logged in candidates can change complaint status.'
    #category=arg.get('category')
    returner = {}
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if(session['subtype']=='admin'):
        if(category=='institution'):
            cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM complaints')
        elif(category=='hostel'):
            cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM hcomplaints')
        else:
            return ""
    # elif(session['subtype']=='student'):
    #     if(category=='institution'):
    #         cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM complaints')
    #     elif(category=='hostel'):
    #         cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM hcomplaints')
    #     else:
    #         return ""        
    ret=cursor.fetchall()
    ret=list(ret)
    returner['complaint']=ret
    # print(ret)
    return returner

@app.route('/getComplaints/student', methods=['POST'])
def getCompStud():
    # arg=request.args
    request.cookies.get('access_token')
    print(session)
    category=request.json.get('category')
    if ( session['loggedin'] == False ):
         returner['status']= 'Only Logged in candidates can change complaint status.'
    # category=arg.get('category')
    email = session['email']
    # print(email)
    returner = {}
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    # if(session['subtype']=='student'):
    if(category=='institution'):
        cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM complaints where email=%s',(email,))
    elif(category=='hostel'):
        cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM hcomplaints where email=%s',(email,))
    else:
        return ""      
    ret=cursor.fetchall()
    ret=list(ret)
    returner['complaint']=ret
    # print(ret)
    return returner

@app.route('/getComplaints/workers', methods=['POST'])
def getCompWorkers():
    #arg=request.args
    # subtype=request.json.get('subtype')
    # email=request.json.get('email')
    subtype = session['subtype']
    email = session['email']
    category=request.json.get('category')
    print(session)
    # if ( session['loggedin'] == False ):
    #      returner['status']= 'Only Logged in candidates can change complaint status.'
    #category=arg.get('category')
    # email='vin@gmail.com'#session['emailid']
    returner = {}
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    # if(session['subtype']=='admin'):
    if(category=='institution'):
        cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM complaints where complainttype=%s',(subtype,))
    elif(category=='hostel'):
        cursor.execute('SELECT complaintid,block,floor,roomno,complainttype,complaint,cts,uts,status FROM hcomplaints where complainttype=%s',(subtype,))
    else:
        return ""      
    ret=cursor.fetchall()
    ret=list(ret)
    returner['complaint']=ret
    # print(ret)
    return returner

@app.route('/getBlocksData', methods=['POST'])
def getFilters():
    #arg=request.args
    # print('hi')
    # subtype=request.json.get('subtype')
    category=request.json.get('category')
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    if(category=='institution'):
        cursor.execute('SELECT DISTINCT block from roomdata')
    elif(category=='hostel'):
        cursor.execute('SELECT DISTINCT block from hroomdata')
    ret=cursor.fetchall()
    ret=list(ret) 
    temp={}
    for block in ret:
        blockName = block['block']
        temp[blockName] = {}
        temp[blockName]['floors'] = []
        temp[blockName]['rooms'] = []
        if(category=='institution'):
            cursor.execute('SELECT DISTINCT floor from roomdata where block=%s',(block['block'],))
            floors=cursor.fetchall()
            floors=list(floors)
            temp[blockName]['floors']=list(range(1, len(floors) + 1))
            temp[blockName]['rooms']=[]
            for f in floors:
                cursor.execute("SELECT DISTINCT roomno from roomdata where block=%s and floor=%s",(block['block'],f['floor'],))
                rooms=cursor.fetchall()
                rooms=list(rooms)
                r=[]
                for t in rooms:
                    r.append(t['roomno'])
                temp[blockName]['rooms'].append(r)
        else:
            cursor.execute('SELECT DISTINCT floor from hroomdata where block=%s',(block['block'],))
            floors=cursor.fetchall()
            floors=list(floors)
            temp[blockName]['floors']=list(range(1, len(floors) + 1))
            temp[blockName]['rooms']=[]
            for f in floors:
                cursor.execute("SELECT DISTINCT roomno from hroomdata where block=%s and floor=%s",(block['block'],f['floor'],))
                rooms=cursor.fetchall()
                rooms=list(rooms)
                r=[]
                for t in rooms:
                    r.append(t['roomno'])
                temp[blockName]['rooms'].append(r)
    return temp
  
@app.route("/getcomplaintTy",methods=['Post'])
def getcomplaintTy():
    category = request.json['category']
    print(category)
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    # temp
    if(category == 'institution'):
        temp={}
        cursor.execute("Select Distinct complainttype from complaintslist")
        complainttype = cursor.fetchall()
        complainttype=list(complainttype)
        for ct in complainttype:
            print(ct)
            temp[ct.get("complainttype")] = []
            cursor.execute("SELECT DISTINCT complaints from complaintslist where complainttype=%s",(ct.get("complainttype"),))
            complaints=cursor.fetchall()
            complaints=list(complaints)
            for c in complaints:
                temp[ct.get("complainttype")].append(c['complaints'])
            # print(ct)
    else:
        temp={}
        cursor.execute("Select Distinct complainttype from hcomplaintslist")
        complainttype = cursor.fetchall()
        complainttype=list(complainttype)
        # print(complainttype)
        for ct in complainttype:
            print(ct)
            temp[ct.get("complainttype")] = []
            cursor.execute("SELECT DISTINCT complaints from hcomplaintslist where complainttype=%s",(ct.get("complainttype"),))
            complaints=cursor.fetchall()
            complaints=list(complaints)
            # print(complaints)
            for c in complaints:
                temp[ct.get("complainttype")].append(c['complaints'])
            # print(ct)
    return temp

if __name__ == "__main__":
    #   app.run()
    app.run(host="0.0.0.0",port=(2002),debug=True,ssl_context=("cert.pem", "key.pem"))