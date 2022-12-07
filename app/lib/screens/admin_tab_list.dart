import 'dart:convert';

import 'package:complaint_app/complaint.dart';
import 'package:complaint_app/screens/complaint_list_screen.dart';
import 'package:complaint_app/screens/input_complaint.dart';
import 'package:complaint_app/screens/login_screen.dart';
import 'package:complaint_app/screens/sidebar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../person.dart';
import '../services.dart';

class adminTablist extends StatefulWidget {
  const adminTablist(
      {Key? key})
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
  }
  Future<void> getcomplaintype() async {
    Session session = new Session();
    Map body ={};
    var t = jsonEncode(body);
    Response r =  await session.post(t,"/getcomplainttype");
    var  m = r.body;
    final bodyJson1 = json.decode(m);
    var c = bodyJson1["complainttype"];
    var d = bodyJson1["block"];
    setState(() {
      for(int i=0;i<c.length;i++){
        complaintype.add(c[i]);
        blocks.add(d[i]);
      }
    });
  }


  Future<void> getComplaints() async {
    Session session = Session();
      Map body = {"complaintType":selectedComplaintType,"Time":selectedTime,"Block":selectedBlock};
    complaint.removeRange(0, complaint.length);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Response r =
    await session.post(bodyJson, "/admin_viewcomplaint");
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
      appBar: AppBar(
        backgroundColor: Color(0xff30475E),
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

      body: Container(

          child : Table(
            border: TableBorder.all(color: Color(0xff30475E),width: 1.5,style: BorderStyle.solid,borderRadius: BorderRadius.circular(20)),
            columnWidths: const {
              0: FlexColumnWidth(4),
          1: FlexColumnWidth(3),
        2: FlexColumnWidth(4),
      3: FlexColumnWidth(4)
            },
            children: [
              TableRow(
                children: [
                  Text(
                    "Block&Floor",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    "Status",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    "Complaint Type",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  Text(
                    "Date",
                      style: TextStyle(fontSize: 15.0)
                  )
                ]
              ),
        for(var item in complaint)
          TableRow(
            children: [
              Text(item.block+" - "+item.floor),
              Text(item.status),
              Text(item.complainType),
              Text(item.timeStamp),
            ]
          )
            ],
          )
      )
    );
  }
}


