import 'dart:convert';
import 'package:complaint_app/screens/Complaints/admin_tab_list.dart';
import 'package:complaint_app/screens/profileScreen/profilepage.dart';
import 'package:complaint_app/utils/GettingComplaints.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../DataClass/complaint.dart';
import '../utils/services.dart';
import '../screens/Complaints/complaint_tab_list_screen.dart';

class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String name = "", email = "", utype = "", subtype = "";
  bool hostelVisibility = false,
      collegeVisibility = false,
      attendanceVisibility = false;

  @override
  void initState() {
    getDetails();
  }

  Future<void> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name")!;
    email = (prefs.getString("email"))!;
    utype = (prefs.getString("utype"))!;
    subtype = (prefs.getString("subtype"))!;
    hostelVisibility = (subtype == 'Hosteller' ||
            ((utype == "Employee" && subtype != "Teacher") || utype == "admin"))
        ? true
        : false;
    collegeVisibility =
        (utype == "Student" || utype == "Employee" || utype == "admin")
            ? true
            : false;
    attendanceVisibility =
        (utype == "Student" || subtype == "Teacher") ? true : false;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xff0A2647),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.asset(
                "asset/profile.gif",
                fit: BoxFit.fill,
                width: 90,
                height: 90,
              )),
              backgroundColor: Colors.black12,
            ),
            decoration: const BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage("asset/sp.jpg")),
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
            onTap: ()=>  Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ProfilePage1()),),
          ),
          Visibility(
            visible: attendanceVisibility,
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
          ExpansionTile(title: RichText(
            text: TextSpan(
              children: [
               WidgetSpan(child: Icon(
                 Icons.comment,
                     color: Colors.white
               ),),
                TextSpan( text : "         Complaints")
               ]
            ),
          ),
            children: [
            Visibility(
              visible: collegeVisibility,
              child: ListTile(
                  leading: Icon(
                    Icons.backpack,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Institution',

                    style: const TextStyle(
                      color: Colors.white,

                    ),
                  ),
                  onTap: () => selectedItem(context, 1),
                ),
              ),

            Visibility(
              visible: hostelVisibility,
              child: ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Hostels',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () => selectedItem(context, 2),
                ),
              ),


          ],
          iconColor: Colors.white,
          initiallyExpanded: true,
            childrenPadding: EdgeInsets.only(left: 20),
            collapsedIconColor: Colors.white,
          )

        ],
      ),
    );
  }

  selectedItem(BuildContext context, index) async {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        if (utype == "admin")
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => adminTablist(DomainType: "college")),
              (Route<dynamic> route) => false);
        else
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ComplainTabList(
                        complaintPending: ComplaintsList.complaintPending,
                        complaintResolved: ComplaintsList.complaintResolved,
                        DomainType: "college",
                      )),
              (Route<dynamic> route) => false);
        break;
      case 1:
        if (utype == "admin")
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => adminTablist(DomainType: "college")),
              (Route<dynamic> route) => false);
        else {
          await ComplaintsList.instance.GetComplaintList("college");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ComplainTabList(
                        complaintPending: ComplaintsList.complaintPending,
                        complaintResolved: ComplaintsList.complaintResolved,
                        DomainType: "college",
                      )),
              (Route<dynamic> route) => false);
        }
        break;
      case 2:
        if (utype == "admin")
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => adminTablist(
                        DomainType: "hostel",
                      )),
              (Route<dynamic> route) => false);
        else {
          await ComplaintsList.instance.GetComplaintList("hostel");
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ComplainTabList(
                        complaintPending: ComplaintsList.complaintPending,
                        complaintResolved: ComplaintsList.complaintResolved,
                        DomainType: "hostel",
                      )),
              (Route<dynamic> route) => false);
        }
        break;
    }
  }
}
