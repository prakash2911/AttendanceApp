import 'dart:convert';

import 'package:complaint_app/screens/complaint_tab_list_screen.dart';
import 'package:complaint_app/screens/sidebar.dart';
import 'package:complaint_app/services.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:complaint_app/constant.dart' as constants;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../complaint.dart';

class Complaints extends StatefulWidget {
  final List<String> blocks;
  const Complaints({Key? key, required this.blocks}) : super(key: key);

  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  String dropdownvalue = 'Item 1';
  String? selectedValue;
  String? selectBlock;
  String? selectedFloor;
  String? selectedRoomNo;
  String? selectedComplaintType;
  List<Complaint> complaintPending = [];
  List<Complaint> complaintResolved = [];
  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  var blocks = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      blocks = widget.blocks;
    });
  }

  var floors = [];
  var roomNos = [];
  var complaintTypes = [
    'electrician',
    'civil and maintenance',
    'education aid'
  ];
  var complaint = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Complaints"),
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
                      'Select block',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: blocks
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
                    value: selectBlock,
                    onChanged: (value) async {
                      selectBlock = value as String;
                      Map body = {
                        "Block": selectBlock,
                        "Floor": "None",
                        "RoomNo": "None",
                        "Complaint": complaint,
                        "complainttype": complaintTypes
                      };
                      floors = await postComplaints(body);

                      roomNos = [];
                      selectedFloor = null;
                      selectedRoomNo = null;

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
                      'Select Floor',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    items: floors
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
                    value: selectedFloor,
                    onChanged: (value) async {
                      selectedFloor = value as String;
                      Map body = {
                        "Block": selectBlock,
                        "Floor": selectedFloor,
                        "RoomNo": "None",
                        "Complaint": complaint,
                        "complainttype": complaintTypes
                      };
                      roomNos = await postComplaints(body);
                      selectedRoomNo = null;

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
                    items: roomNos
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
                    value: selectedRoomNo,
                    onChanged: (value) {
                      setState(() {
                        selectedRoomNo = value as String;
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
                const SizedBox(
                  height: 40.0,
                ),
                Container(
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Complaint',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        complaint = val;
                      });
                    },
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: const Text(
                    "Select Category",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Column(
                  children: <Widget>[
                    RadioListTile(
                      title: const Text(
                        'Electrician',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: "electrician",
                      groupValue: selectedComplaintType,
                      onChanged: (value) {
                        setState(() {
                          selectedComplaintType = value as String;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                    RadioListTile(
                      title: const Text(
                        'Civil and maintenance',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: "civil and maintenance",
                      groupValue: selectedComplaintType,
                      onChanged: (value) {
                        setState(() {
                          selectedComplaintType = value as String;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                    RadioListTile(
                      title: const Text(
                        'Education aid',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: "education aid",
                      groupValue: selectedComplaintType,
                      onChanged: (value) {
                        setState(() {
                          selectedComplaintType = value as String;
                        });
                      },
                      activeColor: Colors.white,
                    ),
                  ],
                )
              ]),
              Container(
                  padding: EdgeInsets.all(40),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.grey[800]),
                    onPressed: () async {
                      print(selectedComplaintType);
                      print(selectedRoomNo);
                      print(selectedFloor);
                      print(selectBlock);
                      // print(selectedValue);

                      Map body = {
                        "Block": selectBlock,
                        "Floor": selectedFloor,
                        "RoomNo": selectedRoomNo,
                        "Complaint": complaint,
                        "complainttype": selectedComplaintType
                      };
                      var v = await postComplaints(body);
                      await getComplaints();
                      if (v[0] == "Success") {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ComplainTabList(
                                      complaintPending: complaintPending,
                                      complaintResolved: complaintResolved,
                                    )),
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

  static Future<List<String>> postComplaints(Map body) async {
    var url = Uri.parse(constants.URL);
    int f = 0;
    if (body["Floor"] == "None") {
      f = 1;
    } else if (body["RoomNo"] == "None") {
      f = 2;
    } else if (body["block"] == "None") {
      f = 3;
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
        arr.add(body1["data"][i]["block"].toString());
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

  Future<void> getComplaints() async {
    Session session = Session();
    Map body = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Response r = await session.post(bodyJson, "/college_viewcomplaint");
    var responseBody = r.body;

    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    print(c);
    for (int i = 0; i < c.length; i++) {
      Complaint complaint1 = Complaint(
          block: c[i]["block"],
          complaint: c[i]["complaint"],
          complainType: c[i]["complainttype"],
          floor: c[i]["floor"].toString(),
          roomNo: c[i]["roomno"].toString(),
          status: c[i]["status"],
          complaintId: c[i]["complaintid"].toString(),
          timeStamp: c[i]["cts"].toString()
          // timeStamp: "timeStamp"
          );
      if (complaint1.status == "Registered") {
        complaintPending.add(complaint1);
      } else {
        complaintResolved.add(complaint1);
      }
    }

    print(responseBody);
  }
}
