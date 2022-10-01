from flask import *
from flask_mysqldb import MySQL
import MySQLdb.cursors
import re
import hashlib
from datetime import datetime
import json

from matplotlib.font_manager import json_dump

app = Flask(__name__)


app.secret_key = 'Tahve bqltuyej tbrjereq qobfd MvIaTq cmanmvpcuxsz iesh tihkel CnTu dretpyauritompeanstd '


app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'admin'
app.config['MYSQL_DB'] = 'mit_users'
app.config['MYSQL_PORT'] = 3306


mysql = MySQL(app)
@app.route('/login', methods=['POST'])
def login():
    email = request.json.get('email')
    password = request.json.get('password')
    hash_object = hashlib.sha256(password.encode('ascii'))
    hash_password = hash_object.hexdigest()
    returner = {}
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute('SELECT * FROM accounts WHERE email = %s AND hash = %s', (email, hash_password,))
    account = cursor.fetchone()

    if account:
        session['loggedin'] = True
        session['id'] = account['id']
        session['email'] = account['email']
        session['utype']=account['utype']
        returner['status']="login success"
        returner['utype']=session['utype']
    else:
        returner['status']="login failure"
        returner['utype']="None"
    return returner
if __name__ == "__main__":
    app.run(host="0.0.0.0")