import 'dart:convert';

import 'package:complaint_app/DataClass/complaint.dart';
import 'package:complaint_app/screens/Complaints/details_screen.dart';
import 'package:complaint_app/screens/Sign-Signup/login_screen.dart';
import 'package:complaint_app/component/sidebar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/services.dart';

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
  int? sortColumnIndex;
  bool isAscending = false;
  String init1 = "Select Block";
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    getcomplaintype();
    getAdminComplaints();
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

  Future<void> getAdminComplaints() async {
    Session session = Session();
      Map body = {"complaintType":selectedComplaintType,"Time":selectedTime,"Block":selectedBlock};
      complaint.clear();
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
  Widget build(BuildContext context) => Scaffold(
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
              await getAdminComplaints();
            },
            icon: const Icon(Icons.refresh))
      ],
    ),
    body: RefreshIndicator(
      onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () async {
            await getAdminComplaints();
          });
        },child:Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("asset/bg/admin-bg.jpg"),
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
                DropdownButton2(
                  hint: Text('Select Block',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme
                          .of(context)
                          .hintColor,),
            ),
                  dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  dropdownOverButton: true,
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
                      getAdminComplaints();
                    });
                  },
                ),
                DropdownButton2(
                  dropdownDecoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                  ),
                  dropdownOverButton: true,
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
                      getAdminComplaints();
                    });
                  },
                ),
              ],
            ),

            SingleChildScrollView( physics:AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,child: buildDataTable(),),

          ],
        ),
        ),


    ),
  );

  Widget buildDataTable() {
    final columns = ['BLOCK', 'FLOOR', 'STATUS'];


    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(complaint),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(

    label: Text(column),
    onSort: onSort,
  ))
      .toList();

  List<DataRow> getRows(List<Complaint> complaints) => complaints.map((Complaint complaint) {
    final cells = [complaint.block, complaint.floor, complaint.status];

    return DataRow(cells: getCells(cells),onLongPress: ()=>{Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(topic: complaint.block, description: complaint.complaint, complaint: complaint, DomainType: widget.DomainType)))});
  }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      complaint.sort((user1, user2) =>
          compareString(ascending, user1.block, user2.block));
    } else if (columnIndex == 1) {
      complaint.sort((user1, user2) =>
          compareString(ascending, '${user1.floor}', '${user2.floor}'));
    }
    else if (columnIndex == 2) {
      complaint.sort((user1, user2) =>
          compareString(ascending, user1.status, user2.status));
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //
  //       drawer: NavBar(),
  //     appBar: AppBar(
  //
  //       backgroundColor: Color(0xff181D31),
  //
  //     actions: [
  //       IconButton(
  //           onPressed: () async {
  //             Map body = {};
  //             var bodyJson = jsonEncode(body);
  //             Session session = Session();
  //             SharedPreferences prefs =
  //             await SharedPreferences.getInstance();
  //             if (prefs.getBool("isSignedIn") == true) {
  //               Response r = await session.post(bodyJson, "/logout");
  //               var responseBody = r.body;
  //               final bodyJson1 = json.decode(responseBody);
  //               print(bodyJson1);
  //               prefs.setBool("isSignedIn", false);
  //               prefs.setString("cookie", "");
  //               Navigator.of(context).pushAndRemoveUntil(
  //                   MaterialPageRoute(
  //                       builder: (context) => LoginScreen()),
  //                       (Route<dynamic> route) => false);
  //             }
  //             final snackBar = SnackBar(
  //               content: const Text('Logged out'),
  //               action: SnackBarAction(
  //                 label: 'Undo',
  //                 onPressed: () {
  //                   // Some code to undo the change.
  //                 },
  //               ),
  //             );
  //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //           },
  //           icon: const Icon(Icons.logout)),
  //       IconButton(
  //           onPressed: () async {
  //             await getComplaints();
  //           },
  //           icon: const Icon(Icons.refresh))
  //     ],
  //     ),
  //     body:  RefreshIndicator(
  //       onRefresh: () {
  //         return Future.delayed(Duration(seconds: 1), () async {
  //           await getComplaints();
  //         });
  //       },
  //       child: Container(
  //           decoration: BoxDecoration(
  //       image: DecorationImage(
  //       image: AssetImage("asset/bg/admin-bg.jpg"),
  //         fit: BoxFit.cover
  //   )
  //   ),
  //         child: Column(
  //
  //             children: [
  //               SizedBox(
  //                 height: 12,
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   DropdownButton(
  //                     // Initial Value
  //                     value: selectedBlock,
  //                     // Down Arrow Icon
  //
  //                     icon: const Icon(Icons.keyboard_arrow_down),
  //
  //                     // Array list of items
  //                     items: blocks.map((String items) {
  //                       return DropdownMenuItem(
  //                         value: items,
  //                         child: Text(items,style: TextStyle(fontSize: 14),),
  //                       );
  //                     }).toList(),
  //                     // After selecting the desired option,it will
  //                     // change button value to selected value
  //                     onChanged: (String? newValue) {
  //                       setState(()  {
  //                         selectedBlock = newValue!;
  //                         getComplaints();
  //                       });
  //                     },
  //                   ),
  //                   DropdownButton(
  //                     // Initial Value
  //                     value: selectedComplaintType,
  //                     // Down Arrow Icon
  //                     icon: const Icon(Icons.keyboard_arrow_down),
  //                     // Array list of items
  //                     items:complaintype.map((String items) {
  //                       return DropdownMenuItem(
  //                         value: items,
  //                         child: Text(items,style: TextStyle(fontSize: 14 ),),
  //                       );
  //                     }).toList(),
  //                     // After selecting the desired option,it will
  //                     // change button value to selected value
  //                     onChanged: (String? newValue) {
  //                       setState(() {
  //                         selectedComplaintType = newValue!;
  //                          getComplaints();
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //                 SizedBox(
  //                   height: 12,
  //                 ),
  //                 Expanded(
  //                   child: ListView(
  //                       shrinkWrap: true,
  //                       scrollDirection: Axis.vertical,
  //                       children: <Widget>[
  //
  //                     Center(
  //                         child: Text(
  //                           widget.DomainType.toUpperCase()+' COMPLAINTS',
  //                           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                         )),
  //                     DataTable(
  //                       columns: [
  //                         DataColumn(label: Text(
  //                             'BLOCK-FLOOR',
  //                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
  //                         )),
  //                         DataColumn(label: Text(
  //                             'STATUS',
  //                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
  //                         )),
  //                         DataColumn(label: Text(
  //                             'TYPE',
  //                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
  //                         )),
  //                       ],
  //                       rows: [
  //
  //                         for(var items in complaint)
  //
  //                           DataRow(onLongPress: ()=>{
  //                             Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(topic: items.block, description: items.complaint, complaint: items, DomainType: widget.DomainType)))
  //                           },cells: [
  //                             DataCell(Text(items.block+"-"+items.floor,style: TextStyle(fontSize: 12),)),
  //                             DataCell(Text(items.status,style: TextStyle(fontSize: 12),)),
  //                             DataCell(Text(items.complainType,style: TextStyle(fontSize: 12),)),
  //                           ]),
  //                       ],
  //                     ),
  //                   ]),
  //                 ),
  //
  //             ],
  //           ),
  //       ),
  //     )
  //     );
  // }
}


