import 'dart:convert';

import 'package:complaint_app/DataClass/attendanceDetail.dart';
import 'package:complaint_app/screens/Attendance/attendance.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/services.dart';

class addclass extends StatefulWidget {
  final List<String> department;
  const addclass({Key? key, required this.department}) : super(key: key);
  @override
  State<addclass> createState() => _addclassState();
}

class _addclassState extends State<addclass> {
  String? selecteddepartment,
      selectedyear,
      selectedbatch,
      selectedsubcode,
      selectedsubtype;
  var department = [];
  var year = [];
  var batch = [];
  var subtype = [];
  var subcode = [];
  List<Attendance> classList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    department = widget.department;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Add class"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 8.0,
              ),
              Column(children: <Widget>[
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: const Text(
                      'Select department',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: department
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selecteddepartment,
                    onChanged: (value) async {
                      selecteddepartment = value as String;
                      Map body = {
                        "department": selecteddepartment,
                        "year": "None",
                        "batch": "None",
                        "subcode": "None",
                        "subtype": "None"
                      };
                      year = await postDetails(body);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.white,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 20),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.grey[800],
                    ),
                    buttonElevation: 2,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey[800],
                    ),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: const Text(
                      'Select year',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: year
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedyear,
                    onChanged: (value) async {
                      selectedyear = value as String;
                      Map body = {
                        "department": selecteddepartment,
                        "year": selectedyear,
                        "batch": "None",
                        "subcode": "None",
                        "subtype": "None"
                      };
                      batch = await postDetails(body);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.white,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 20),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.grey[800],
                    ),
                    buttonElevation: 2,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey[800],
                    ),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: const Text(
                      'Select class room',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: batch
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedbatch,
                    onChanged: (value) async {
                      selectedbatch = value as String;
                      Map body = {
                        "department": selecteddepartment,
                        "year": selectedyear,
                        "batch": selectedbatch,
                        "subcode": "None",
                        "subtype": "None"
                      };
                      subcode = await postDetails(body);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.white,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 20),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.grey[800],
                    ),
                    buttonElevation: 2,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey[800],
                    ),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: const Text(
                      'Select subject code',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: subcode
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedsubcode,
                    onChanged: (value) async {
                      selectedsubcode = value as String;
                      Map body = {
                        "department": selecteddepartment,
                        "year": selectedyear,
                        "batch": selectedbatch,
                        "subcode": selectedsubcode,
                        "subtype": "None"
                      };
                      subtype = await postDetails(body);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.white,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 20),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.grey[800],
                    ),
                    buttonElevation: 2,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey[800],
                    ),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: const Text(
                      'Select subject type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: subtype
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedsubtype,
                    onChanged: (value) {
                      setState(() {
                        selectedsubtype = value as String;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                    ),
                    iconSize: 14,
                    iconEnabledColor: Colors.white,
                    buttonPadding: const EdgeInsets.only(left: 20, right: 20),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      color: Colors.grey[800],
                    ),
                    buttonElevation: 2,
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey[800],
                    ),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 6,
                    scrollbarAlwaysShow: true,
                  ),
                ),
              ]),
              Container(
                  padding: EdgeInsets.all(40),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800]),
                    onPressed: () async {
                      Map body = {
                        "department": selecteddepartment,
                        "year": selectedyear,
                        "batch": selectedbatch,
                        "subcode": selectedsubcode,
                        "subtype": selectedsubtype
                      };
                      List<String> v = await postDetails(body);
                      // await getClassList();
                      if (v[0] == "Success" && selectedsubtype == "core") {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    attendace(classList: classList)),
                            (Route<dynamic> route) => false);
                      }
                    },
                    child:
                        Text("Submit", style: TextStyle(color: Colors.white)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  static Future<List<String>> postDetails(Map body) async {
    int f = 0;
    if (body["year"] == "None") {
      f = 1;
    } else if (body["batch"] == "None") {
      f = 2;
    } else if (body["department"] == "None") {
      f = 3;
    } else if (body["subtype"] == "None") {
      f = 4;
    } else if (body["subcode"] == "None") {
      f = 5;
    }
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Session session = Session();
    Response r = await session.post(bodyJson, "/addclass");
    var responseBody = r.body;
    final body1 = json.decode(responseBody);

    List<String> arr = [];

    if (f == 1) {
      for (int i = 0; i < body1["data"].length; i++) {
        arr.add(body1["data"][i]["year"].toString());
      }
    } else if (f == 2) {
      for (int i = 0; i < body1["data"].length; i++) {
        arr.add(body1["data"][i]["batch"].toString());
      }
    } else if (f == 3) {
      for (int i = 0; i < body1["data"].length; i++) {
        arr.add(body1["data"][i]["department"].toString());
      }
    } else if (f == 4) {
      for (int i = 0; i < body1["data"].length; i++) {
        arr.add(body1["data"][i]["subtype"].toString());
      }
    } else if (f == 5) {
      for (int i = 0; i < body1["data"].length; i++) {
        arr.add(body1["data"][i]["subcode"].toString());
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

  //
  // static Future<List<String>> getClassList(Map body){
  //
  //
  //
  // }
  Future<void> getClassDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map body = {};
    var bodyJson = jsonEncode(body);
    Session session = Session();
    Response r = await session.post(bodyJson, "/getclass");
    final bodyJson1 = json.decode(r.body);
    for (int i = 0; i < bodyJson1["data"].length; i++) {}
  }
}
