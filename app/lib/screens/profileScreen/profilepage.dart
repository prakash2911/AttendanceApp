import 'dart:convert';

import 'package:complaint_app/utils/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:complaint_app/screens/Sign-Signup/login_screen.dart';


class ProfilePage1 extends StatefulWidget {
  ProfilePage1({Key? key}) : super(key: key);

  @override
  State<ProfilePage1> createState() => _ProfilePage1State();
}

class _ProfilePage1State extends State<ProfilePage1> {
  String name = "", email = "", utype = "", subtype = "";
  List<ProfileInfoItem> items= [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey[900],
        backgroundColor: Color(0xff006df1).withOpacity(0.2),
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

              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
           Expanded(flex: 2, child: _TopPortion()),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                    Padding(
                      padding :EdgeInsets.all(13) ,
                      child: Center(
                        child: Text(
                          name.toUpperCase(),
                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                  ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: "usertype",
                        elevation: 0,
                        label: Text(utype),
                        icon: const Icon(Icons.person),
                      ),
                      const SizedBox(width: 16.0),
                      FloatingActionButton.extended(
                        onPressed: () {},
                        heroTag: "Email",
                        elevation: 0,
                        backgroundColor: Colors.red,
                        label: Text(email),
                        icon: const Icon(Icons.mail),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                   _ProfileInfoRow(items: items,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDetails()  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name")!;
    email = (prefs.getString("email"))!;
    utype = (prefs.getString("utype"))!;
    subtype = (prefs.getString("subtype"))!;
    Session session = new Session();
    Map mp = {"email":email};
    var bodyJson = jsonEncode(mp);
    Response r = await session.post(bodyJson, "/getprofileinfo");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    // for(int i=0;i<bodyJson1.length;i++)
    //   ProfileInfoItem t = new ProfileInfoItem(bodyJson1[i]., bodyJson1[i])
    // items.add(new ProfileInfoItem(, value))
    print(bodyJson1);
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final List<ProfileInfoItem> items;

  _ProfileInfoRow({Key? key,required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items
            .map((item) => Expanded(
            child: Row(
              children: [
                if (items.indexOf(item) != 0) const VerticalDivider(),
                Expanded(child: _singleItem(context,item)),
              ],
            )))
            .toList(),
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          item.value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      Text(
        item.title,
        style: Theme.of(context).textTheme.bodySmall,
      )
    ],
  );
}

class ProfileInfoItem {
  String title;
  int value;
  ProfileInfoItem(this.title, this.value);
}

class _TopPortion extends StatelessWidget {
   _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xff0043ba), Color(0xff006df1)]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("asset/profile.png"),fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}