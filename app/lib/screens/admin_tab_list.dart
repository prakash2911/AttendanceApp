import 'dart:convert';

import 'package:complaint_app/complaint.dart';
import 'package:complaint_app/screens/complaint_list_screen.dart';
import 'package:complaint_app/screens/details_screen.dart';
import 'package:complaint_app/screens/input_complaint.dart';
import 'package:complaint_app/screens/login_screen.dart';
import 'package:complaint_app/screens/sidebar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../person.dart';
import '../services.dart';

class adminTablist extends StatefulWidget {
  final String DomainType;
  const adminTablist(
      {Key? key , required this.DomainType})
      : super(key: key);
  @override
  State<adminTablist> createState() => _adminTablistState();
}
class _adminTablistState extends State<adminTablist> {
  List<Complaint> complaint = [];
  final List<String> Time = ["All","Recent","Last Week","Last Month","Last Year"];
  var complaintype = ["All"];
  var blocks = ["All"];
  String? utype;
  String? subtype;
  String selectedTime = "All";
  String selectedComplaintType = "All";
  String selectedBlock = "All";
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    getcomplaintype();
    getComplaints();
  }
  Future<void> getcomplaintype() async {
    Session session = new Session();
    Map body ={"Domaintype" : widget.DomainType};
    var t = jsonEncode(body);
    Response r =  await session.post(t,"/getcomplainttype");
    var  m = r.body;
    final bodyJson1 = json.decode(m);
    var c = bodyJson1["complainttype"];
    var d = bodyJson1["block"];
    for(int i=0;i<c.length;i++){
      complaintype.add(c[i]['complainttype']);
      blocks.add(d[i]['block']);
    }
    setState(() {
    });
  }

  Future<void> getComplaints() async {
    Session session = Session();
      Map body = {"complaintType":selectedComplaintType,"Time":selectedTime,"Block":selectedBlock};
      complaint.clear();
    // complaint.removeRange(0, complaint.length);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Response r =
    await session.post(bodyJson, "/admin_"+widget.DomainType+"_viewcomplaint");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    for (int i = 0; i < c.length; i++) {
      Complaint complaint1 = Complaint(
          block: c[i]["block"].toString(),
          complaint: c[i]["complaint"].toString(),
          complainType: c[i]["complainttype"].toString(),
          floor: c[i]["floor"].toString(),
          roomNo: c[i]["roomno"].toString(),
          status: c[i]["status"].toString(),
          complaintId: c[i]["complaintid"].toString(),
          timeStamp: c[i]["cts"].toString(),
          updateStamp: c[i]["uts"].toString());
       complaint.add(complaint1);
      }
      setState(() {});
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        drawer: NavBar(),
      appBar: AppBar(

        backgroundColor: Color(0xff181D31),

      actions: [
        IconButton(
            onPressed: () async {
              Map body = {};
              var bodyJson = jsonEncode(body);
              Session session = Session();
              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              if (prefs.getBool("isSignedIn") == true) {
                Response r = await session.post(bodyJson, "/logout");
                var responseBody = r.body;
                final bodyJson1 = json.decode(responseBody);
                print(bodyJson1);
                prefs.setBool("isSignedIn", false);
                prefs.setString("cookie", "");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false);
              }
              final snackBar = SnackBar(
                content: const Text('Logged out'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(Icons.logout)),
        IconButton(
            onPressed: () async {
              await getComplaints();
            },
            icon: const Icon(Icons.refresh))
      ],
      ),
      body:  RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () async {
            await getComplaints();
          });
        },
        child: Container(
            decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assests/bg/admin-bg.jpg"),
          fit: BoxFit.cover
    )
    ),
          child: Column(

              children: [
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                      // Initial Value
                      value: selectedBlock,
                      // Down Arrow Icon

                      icon: const Icon(Icons.keyboard_arrow_down),

                      // Array list of items
                      items: blocks.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items,style: TextStyle(fontSize: 14),),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(()  {
                          selectedBlock = newValue!;
                          getComplaints();
                        });
                      },
                    ),
                    DropdownButton(
                      // Initial Value
                      value: selectedComplaintType,
                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      // Array list of items
                      items:complaintype.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items,style: TextStyle(fontSize: 14 ),),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedComplaintType = newValue!;
                           getComplaints();
                        });
                      },
                    ),
                  ],
                ),
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: <Widget>[

                      Center(
                          child: Text(
                            widget.DomainType.toUpperCase()+' COMPLAINTS',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      DataTable(
                        columns: [
                          DataColumn(label: Text(
                              'BLOCK-FLOOR',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          )),
                          DataColumn(label: Text(
                              'STATUS',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          )),
                          DataColumn(label: Text(
                              'TYPE',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                          )),
                        ],
                        rows: [

                          for(var items in complaint)

                            DataRow(onLongPress: ()=>{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(topic: items.block, description: items.complaint, complaint: items, DomainType: widget.DomainType)))
                            },cells: [
                              DataCell(Text(items.block+"-"+items.floor,style: TextStyle(fontSize: 12),)),
                              DataCell(Text(items.status,style: TextStyle(fontSize: 12),)),
                              DataCell(Text(items.complainType,style: TextStyle(fontSize: 12),)),
                            ]),
                        ],
                      ),
                    ]),
                  ),

              ],
            ),
        ),
      )
      );
  }
}


