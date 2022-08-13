import 'package:complaint_app/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../complaint.dart';
import 'complaint_tab_list_screen.dart';

class NavBar extends StatelessWidget {
  List<Complaint> complaintPending = [];
  List<Complaint> complaintResolved = [];
  // var name = getUsername();
  // var email = getEmail();
  var name = "Prakash";
  var email = "Prakash29112002@gamil.com";
  // const NavBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            // accountName: Text("prakash"),
            // accountEmail: Text("prakash"),
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image.network(
                "",
                fit: BoxFit.fill,
                width: 90,
                height: 90,
              )),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Attendence'),
            onTap: () => selectedItem(context, 0),
          ),
          ListTile(
            leading: Icon(Icons.backpack),
            title: Text('Complaints - college'),
            onTap: () => selectedItem(context, 1),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Complaints - hostel'),
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

// getUsername() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString("name");
// }
//
// getEmail() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString("email");
// }
