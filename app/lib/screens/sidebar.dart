import 'dart:convert';
import 'package:complaint_app/screens/admin_tab_list.dart';
import 'package:complaint_app/screens/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../complaint.dart';
import '../services.dart';
import 'complaint_tab_list_screen.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Complaint> complaintPending = [];

  List<Complaint> complaintResolved = [];

  String name="", email="", utype="", subtype="";
  bool? hostelVisibility, collegeVisibility, attendanceVisibility;
  List<ProfileInfoItem> _items = [];
  @override
  void initState() {
    // TODO: implement initStates
    getDetails();
    getComplaints();
  }
  Future<void> getProfile() async{
    Map body={"email" : email};
    var body1 = jsonEncode(body);
    Session session = new Session();
    Response r = await session.post(body1, '/getprofileinfo');
    var response = r.body;
    var bodyjson = jsonDecode(response);
    _items =  [
      ProfileInfoItem("Registered", bodyjson['registered']),
      ProfileInfoItem("Resolved", bodyjson['resolved']),
      ProfileInfoItem("Verified", bodyjson['verified']),
    ];
  }
  Future<void> getComplaints() async {
    Session session = Session();
    Map body = {};
    var bodyJson = jsonEncode(body);
    Response r = await session.post(bodyJson, "/college_viewcomplaint");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    for (int i = 0; i < c.length; i++) {
      Complaint complaint1 = Complaint(
          block: c[i]["block"],
          complaint: c[i]["complaint"],
          complainType: c[i]["complainttype"],
          floor: c[i]["floor"].toString(),
          roomNo: c[i]["roomno"].toString(),
          status: c[i]["status"],
          complaintId: c[i]["complaintid"].toString(),
          timeStamp: c[i]["cts"].toString(),
          updateStamp: c[i]["uts"].toString());
      if (complaint1.status == "Registered") {
        complaintPending.add(complaint1);
      } else if (complaint1.status == "Resolved") {
        complaintResolved.add(complaint1);
      }
      setState(() {});
    }
  }

  Future<void> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name")!;
      email = (prefs.getString("email"))!;
      utype = (prefs.getString("utype"))!;
      subtype = (prefs.getString("subtype"))!;
      hostelVisibility = (subtype == 'Hosteller' ||
              ((utype == "Employee" && subtype != "Teacher") || utype=="admin"))
          ? true
          : false;
      collegeVisibility =
          (utype == "Student" || utype == "Employee" || utype=="admin") ? true : false;
      attendanceVisibility =
          (utype == "Student" || subtype == "Teacher") ? true : false;
      getProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff181D31),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name!),
            accountEmail: Text(email!),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.asset(
                "assests/profile.gif",
                fit: BoxFit.fill,
                width: 90,
                height: 90,
              )),
              backgroundColor: Colors.black12,
            ),
            decoration: const BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage("assests/sp.jpg")),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.white,
            ),
            title: Text(
              'Profile',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            onTap: () => {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ProfilePage1(name: name, email: email, utype: utype, subtype: subtype,items: _items,)),
            ),
            },
          ),
          Visibility(
            visible: attendanceVisibility ?? false,
            child: ListTile(
              leading: Icon(
                Icons.calendar_month,
                color: Colors.white,
              ),
              title: Text(
                'Attendance',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => selectedItem(context, 0),
            ),
          ),
          Visibility(
            visible: collegeVisibility!,
            child: ListTile(
              leading: Icon(
                Icons.backpack,
                color: Colors.white,
              ),
              title: Text(
                'Complaints - Institution',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => selectedItem(context, 1),
            ),
          ),
          Visibility(
            visible: hostelVisibility!,
            child: ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                'Complaints - Hostels',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => selectedItem(context, 2),
            ),
          ),
        ],
      ),
    );
  }

  selectedItem(BuildContext context, index) async {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        if(utype=="admin")
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => adminTablist(DomainType: "college")),
                  (Route<dynamic> route) => false);
        else
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ComplainTabList(
                      complaintPending: complaintPending,
                      complaintResolved: complaintResolved,
                      DomainType: "college",
                    )),
            (Route<dynamic> route) => false);
        break;
      case 1:
        if(utype=="admin")
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => adminTablist(DomainType: "college")),
                  (Route<dynamic> route) => false);
        else
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ComplainTabList(
                    complaintPending: complaintPending,
                    complaintResolved: complaintResolved,
                    DomainType: "college",
                  )),
                  (Route<dynamic> route) => false);
        break;
      case 2:
        if(utype=="admin")
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => adminTablist(DomainType: "hostel",)),
                  (Route<dynamic> route) => false);
        else
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ComplainTabList(
                      complaintPending: complaintPending,
                      DomainType: "hostel",
                      complaintResolved: complaintResolved,
                    )),
            (Route<dynamic> route) => false);
        break;
    }
  }
}
