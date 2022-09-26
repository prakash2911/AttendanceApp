import 'package:complaint_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../complaint.dart';
import 'complaint_tab_list_screen.dart';

// class NavBar extends StatefulWidget {
//   const NavBar({Key? key}) : super(key: key);
//
//   @override
//   State<NavBar> createState() => _NavBarState();
// }
//
// class _NavBarState extends State<NavBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }


class NavBar extends StatefulWidget {
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Complaint> complaintPending = [];

  List<Complaint> complaintResolved = [];

  String name = "",email = "";

  @override
  void initState() {
    // TODO: implement initState
    getUType();
  }

  Future<void> getUType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = (prefs.getString("name"))!;
      email = (prefs.getString("email"))!;
      print(name+email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.asset(
                "assests/images.png",
                fit: BoxFit.fill,
                width: 90,
                height: 90,
              )),
              backgroundColor:Colors.black12,
            ),
            decoration: const BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assests/sp.jpg")
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month,
            color: Colors.white,
            ),
            title: Text('Attendence',
            style: const TextStyle(
              color: Colors.white,
            ),
            ),
            onTap: () => selectedItem(context, 0),
          ),
          ListTile(
            leading: Icon(Icons.backpack,
            color: Colors.white,),
            title: Text('Complaints - college',
            style: const TextStyle(
              color: Colors.white,
            ),),
            onTap: () => selectedItem(context, 1),
          ),
          ListTile(
            leading: Icon(Icons.home,
            color: Colors.white,),
            title: Text('Complaints - hostel',
            style: const TextStyle(
              color: Colors.white,
            ),),
            onTap: () => selectedItem(context, 2),
          ),
        ],
      ),
    );
  }

  selectedItem(BuildContext context, index) async {
    Navigator.of(context).pop();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final isLoggedIn = ((prefs.getBool('isSignedIn') == null)
    //     ? false
    //     : prefs.getBool('isSignedIn'))!;
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ComplainTabList(
                      complaintPending: complaintPending,
                      complaintResolved: complaintResolved,
                    )),
            (Route<dynamic> route) => false);
        break;
      case 1:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ComplainTabList(
                      complaintPending: complaintPending,
                      complaintResolved: complaintResolved,
                    )),
            (Route<dynamic> route) => false);
        break;
      case 2:
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ComplainTabList(
                      complaintPending: complaintPending,
                      complaintResolved: complaintResolved,
                    )),
            (Route<dynamic> route) => false);
        break;
    }
  }
}



