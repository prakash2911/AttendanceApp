import 'dart:convert';

import 'package:complaint_app/complaint.dart';
import 'package:complaint_app/screens/complaint_list_screen.dart';
import 'package:complaint_app/screens/input_complaint.dart';
import 'package:complaint_app/screens/login_screen.dart';
import 'package:complaint_app/screens/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../person.dart';
import '../services.dart';

class ComplainTabList extends StatefulWidget {
  final List<Complaint> complaintPending;
  final List<Complaint> complaintResolved;
  final String DomainType;
  const ComplainTabList({
    Key? key,
    required this.complaintPending,
    required this.complaintResolved,
    required this.DomainType,
  }) : super(key: key);

  @override
  _ComplainTabListState createState() => _ComplainTabListState();
}

class _ComplainTabListState extends State<ComplainTabList> {
  List<Complaint> complaintPending1 = [];
  List<Complaint> complaintResolved1 = [];
  String? utype;
  String? subtype;
  bool _addButtonVisibility = true;
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getUType();
    setState(() {});
    getComplaints(widget.DomainType);
  }

  Future<void> getUType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      utype = (prefs.getString("utype"))!;
      subtype = (prefs.getString("subtype"))!;
      _addButtonVisibility =
          (utype == "Student" || subtype == "Teacher" || subtype == "RC")
              ? true
              : false;
    });
  }

  Future<void> getComplaints(String DomainType) async {
    Session session = Session();
    Map body = {};
    complaintResolved1.removeRange(0, complaintResolved1.length);
    complaintPending1.removeRange(0, complaintResolved1.length);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Response r =
        await session.post(bodyJson, "/" + DomainType + "_viewcomplaint");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    print(c);
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
      if (complaint1.status == "Registered") {
        complaintPending1.add(complaint1);
      } else if (complaint1.status == "Resolved" ||
          complaint1.status == "verify") {
        complaintResolved1.add(complaint1);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            drawer: NavBar(),
            appBar: AppBar(
              // backgroundColor: Colors.grey[900],
              backgroundColor: Color(0xff30475E),
              bottom: TabBar(
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
                      await getComplaints(widget.DomainType);
                    },
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: TabBarView(
              children: [
                ComplaintList(
                  Status: "Registered",
                  DomainType: widget.DomainType,
                ),
                ComplaintList(
                  Status: "Resolved",
                  DomainType: widget.DomainType,
                )
              ],
            ),
            floatingActionButton: Visibility(
              visible: _addButtonVisibility,
              child: FloatingActionButton(
                onPressed: () async {
                  Map body = {
                    "Block": "None",
                    "Floor": "None",
                    "RoomNo": "None",
                    "Complaint": "None",
                    "complainttype": "None"
                  };
                  List<String> s =
                      await postComplaints(body, widget.DomainType);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Complaints(
                                blocks: s,
                                DomainType: widget.DomainType,
                              )));
                },
                backgroundColor: Colors.grey[800],
                child: Icon(Icons.add),
              ),
            )));
  }

  static Future<List<String>> postComplaints(
      Map body, String DomainType) async {
    int f = 0;

    if (body["Block"] == "None") {
      f = 3;
    } else if (body["Floor"] == "None") {
      f = 1;
    } else if (body["RoomNo"] == "None") {
      f = 2;
    }

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Session session = Session();
    Response r =
        await session.post(bodyJson, "/" + DomainType + "_registercomplaint");
    var responseBody = r.body;
    final body1 = json.decode(responseBody);

    List<String> arr = [];

    if (f == 1) {
      for (int i = 0; i < body1["data"].length; i++) {
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
