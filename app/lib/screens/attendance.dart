import 'dart:convert';

import 'package:complaint_app/screens/addclass.dart';
import 'package:complaint_app/screens/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../attendanceDetail.dart';
import '../services.dart';
import 'login_screen.dart';

class attendace extends StatefulWidget {
  final List<Attendance> classList;
  const attendace({Key? key, required this.classList}) : super(key: key);

  @override
  State<attendace> createState() => _attendaceState();
}

class _attendaceState extends State<attendace> {
  bool _addButtonVisibility = false;
  String? utype, subtype;
  List<Attendance> classList1 = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getutype();
    classList1 = widget.classList;
    _addButtonVisibility = (subtype == "teacher") ? true : false;
  }

  void getutype() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    utype = pref.getString("utype") ?? null;
    subtype = pref.getString("subtype") ?? null;
    setState(() {});
  }

  Future<void> getClassDetails() async {
    Map body = {};
    var bodyJson = jsonEncode(body);
    Session session = Session();
    Response r = await session.post(bodyJson, "/getclass");
    final bodyJson1 = json.decode(r.body);
    classList1.removeRange(0, classList1.length);
    for (int i = 0; i < bodyJson1["data"].length; i++) {
      Attendance att = new Attendance(
          className: bodyJson1['data'][i]['className'].toString(),
          strength: bodyJson1['data'][i]["strength"].toString());
      classList1.add(att);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
              onPressed: () async {
                Map body = {};
                var bodyJson = jsonEncode(body);
                Session session = Session();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.getBool("isSignedIn") == true) {
                  Response r = await session.post(bodyJson, "/logout");
                  var responseBody = r.body;
                  final bodyJson1 = json.decode(responseBody);
                  print(bodyJson1);
                  prefs.setBool("isSignedIn", false);
                  prefs.setString("cookie", "");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
                }
              },
              icon: const Icon(Icons.logout)),
          IconButton(onPressed: () async {}, icon: const Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: Visibility(
        visible: _addButtonVisibility,
        child: FloatingActionButton(
          onPressed: () async {
            Map body = {
              "department": "None",
              "year": "None",
              "batch": "None",
              "subjcode": "None",
              "subtype": "None"
            };
            List<String> department = await postdetails(body);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => addclass(department: department)));
          },
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

Future<List<String>> postdetails(Map body) async {
  var bodyJson = jsonEncode(body);
  Session session = Session();
  Response r = await session.post(bodyJson, "/addclass");
  var responseBody = r.body;
  final body1 = json.decode(responseBody);
  List<String> arr = [];
  for (int i = 0; i < body1["data"].length; i++)
    arr.add(body1["data"][i]["department"].toString());
  return arr;
}
