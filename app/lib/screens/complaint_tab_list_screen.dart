import 'dart:convert';

import 'package:complaint_app/complaint.dart';
import 'package:complaint_app/screens/complaint_list_screen.dart';
import 'package:complaint_app/screens/input_complaint.dart';
import 'package:complaint_app/screens/login_screen.dart';
import 'package:complaint_app/screens/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../person.dart';
import '../services.dart';

class ComplainTabList extends StatefulWidget {
  final List<Complaint> complaintPending;
  final List<Complaint> complaintResolved;
  const ComplainTabList(
      {Key? key,
      required this.complaintPending,
      required this.complaintResolved})
      : super(key: key);

  @override
  _ComplainTabListState createState() => _ComplainTabListState();
}

class _ComplainTabListState extends State<ComplainTabList> {
  List<Complaint> complaintPending1 = [];
  List<Complaint> complaintResolved1 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComplaints();
  }

  Future<void> getComplaints() async {
    setState(() {
      complaintPending1 = widget.complaintPending;
      complaintResolved1 = widget.complaintResolved;
    });
    Session session = Session();
    Map body = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    var db = await openDatabase('mit_users.db');

    Response r = await session.post(bodyJson, "/college_viewcomplaint");
    var responseBody = r.body;

    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    // var c = await db.rawQuery("SELECT * FROM complaints_pending");
    print("cccccc");
    // print(c);
    // print(c[0].runtimeType);
    // List<Map> result = await db.rawQuery("SELECT * FROM complaints_pending");
    // print(result[0].runtimeType);
    // print(c1);
    for (int i = 0; i < c.length; i++) {
      Complaint complaint1 = Complaint(
          block: c[i]["block"].toString(),
          complaint: c[i]["complaint"].toString(),
          complainType: c[i]["complainttype"].toString(),
          floor: c[i]["floor"].toString(),
          roomNo: c[i]["roomno"].toString(),
          status: c[i]["status"].toString(),
          complaintId: c[i]["complaintid"].toString(),
          timeStamp: c[i]["cts"].toString());
      final List<Complaint> complaintUpdated = [];
      if (complaint1.status == "Registered") {
        complaintUpdated.add(complaint1);
      } else {
        complaintUpdated.add(complaint1);
      }
      if (complaint1.status == "Registered") {
        setState(() {
          complaintPending1 = complaintUpdated;
        });
      } else {
        setState(() {
          complaintResolved1 = complaintUpdated;
        });
      }
    }

    print(responseBody);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: NavBar(),
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              bottom: const TabBar(
                tabs: [
                  Tab(
                    text: "Pending",
                  ),
                  Tab(
                    text: "Resolved",
                  )
                ],
              ),
              actions: [
                IconButton(
                    onPressed: () async {
                      print("dei logout");
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
                    },
                    icon: const Icon(Icons.logout)),
                IconButton(
                    onPressed: () async {
                      await getComplaints();
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: TabBarView(
              children: [
                ComplaintList(
                  complaint: widget.complaintPending,
                ),
                ComplaintList(complaint: widget.complaintResolved)
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                Map body = {
                  "Block": "None",
                  "Floor": "None",
                  "RoomNo": "None",
                  "Complaint": "None",
                  "complainttype": "None"
                };
                List<String> s = await postComplaints(body);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Complaints(
                              blocks: s,
                            )));
              },
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.add),
            )));
  }

  static Future<List<String>> postComplaints(Map body) async {
    int f = 0;

    if (body["Block"] == "None") {
      f = 3;
    } else if (body["Floor"] == "None") {
      f = 1;
    } else if (body["RoomNo"] == "None") {
      f = 2;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Session session = Session();
    Response r = await session.post(bodyJson, "/college_registercomplaint");
    var responseBody = r.body;
    final body1 = json.decode(responseBody);

    List<String> arr = [];

    if (f == 1) {
      for (int i = 0; i < body1["data"].length; i++) {
        print("aaaaaaaa");
        // print(body1["data"][i]["Floor"]);
        arr.add(body1["data"][i]["Floor"].toString());
      }
    } else if (f == 2) {
      for (int i = 0; i < body1["data"].length; i++) {
        arr.add(body1["data"][i]["RoomNo"].toString());
      }
    } else if (f == 3) {
      for (int i = 0; i < body1["data"].length; i++) {
        arr.add(body1["data"][i]["Block"].toString());
      }
    }

    if (body1["status"] == "You have successfully registered a Complaint.") {
      List<String> ls = [];
      ls.add("Success");
      return ls;
    }
    // print(body1);
    if (r.statusCode == 200) {
      return arr;
    }

    return [body1["status"]];
  }
}
