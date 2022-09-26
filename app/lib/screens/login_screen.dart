// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:complaint_app/screens/complaint_list_screen.dart';
import 'package:complaint_app/screens/complaint_tab_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:complaint_app/animation/animations.dart';
import 'package:complaint_app/screens/signup_screen.dart';
import 'package:complaint_app/constant.dart' as constants;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../complaint.dart';
import '../constant.dart';
import '../services.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  final feature = ["Login", "Sign Up"];
  int i = 0;
  String email = "";
  String password = "";
  bool validation = true;
  List<Complaint> complaintPending = [];
  List<Complaint> complaintResolved = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Color(0xfffdfdfdf),
            body: i == 0
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Row(
                                  // TabBar Code
                                  children: [
                                    Container(
                                      height: height / 19,
                                      width: width / 2,
                                      child: TopAnime(
                                        2,
                                        5,
                                        child: ListView.builder(
                                          itemCount: feature.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  i = index;
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Text(
                                                      feature[index],
                                                      style: TextStyle(
                                                        color: i == index
                                                            ? Colors.black
                                                            : Colors.grey,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  i == index
                                                      ? Container(
                                                          height: 3,
                                                          width: width / 9,
                                                          color: Colors.black,
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),

                                    // Profile
                                    // RightAnime(
                                    //   1,
                                    //   15,
                                    //   curve: Curves.easeInOutQuad,
                                    //   child: ClipRRect(
                                    //     borderRadius: BorderRadius.circular(20),
                                    //     child: Container(
                                    //       width: 60,
                                    //       height: 60,
                                    //       color: Colors.red[400],
                                    //       child: i == 0
                                    //           ? Image(
                                    //               image: NetworkImage(
                                    //                   "https://i.pinimg.com/564x/5d/a3/d2/5da3d22d08e353184ca357db7800e9f5.jpg"),
                                    //             )
                                    //           : Icon(
                                    //               Icons.account_circle_outlined,
                                    //               color: Colors.white,
                                    //               size: 40,
                                    //             ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ]),

                              SizedBox(
                                height: 50,
                              ),

                              // Top Text
                              Container(
                                padding: EdgeInsets.only(left: 15),
                                width: width,
                                child: TopAnime(
                                  1,
                                  20,
                                  curve: Curves.fastOutSlowIn,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: "Welcome ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 40,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Back",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),

                              SizedBox(
                                height: height / 14,
                              ),

                              // TextFiled
                              Column(
                                children: [
                                  Container(
                                    width: width / 1.2,
                                    height: height / 3.10,
                                    //  color: Colors.red,
                                    child: TopAnime(
                                      1,
                                      15,
                                      curve: Curves.easeInExpo,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextField(
                                            // readOnly: true, // * Just for Debug
                                            cursorColor: Colors.black,
                                            style:
                                                TextStyle(color: Colors.black),
                                            showCursor: true,
                                            //cursorColor: mainColor,
                                            onChanged: (value) {
                                              setState(() {
                                                email = value;
                                              });
                                            },
                                            decoration:
                                                kTextFiledInputDecoration
                                                    .copyWith(
                                                        labelText: "Email"),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                          TextFormField(
                                            // readOnly: true, // * Just for Debug
                                            cursorColor: Colors.black,
                                            obscureText: !_passwordVisible,
                                            style:
                                                TextStyle(color: Colors.black),
                                            showCursor: true,
                                            //cursorColor: mainColor,
                                            decoration:
                                                kTextFiledInputDecoration
                                                    .copyWith(
                                              labelText: "Password",
                                              suffixIcon: IconButton(
                                                icon: Icon(
                                                  // Based on passwordVisible state choose the icon
                                                  _passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off,
                                                  color: Theme.of(context)
                                                      .primaryColorDark,
                                                ),
                                                onPressed: () {
                                                  // Update the state i.e. toogle the state of passwordVisible variable
                                                  setState(() {
                                                    _passwordVisible =
                                                        !_passwordVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                password = value;
                                              });
                                            },
                                          ),

                                          SizedBox(
                                            height: 5,
                                          ),

                                          // FaceBook and Google ICon
                                          // TopAnime(
                                          //   1,
                                          //   10,
                                          //   child: Row(
                                          //     children: [
                                          //       IconButton(
                                          //         icon: FaIcon(
                                          //           FontAwesomeIcons.facebookF,
                                          //           size: 30,
                                          //         ),
                                          //         onPressed: () {},
                                          //       ),
                                          //       SizedBox(
                                          //         width: 15,
                                          //       ),
                                          //       IconButton(
                                          //         icon: FaIcon(
                                          //             FontAwesomeIcons
                                          //                 .googlePlusG,
                                          //             size: 35),
                                          //         onPressed: () {},
                                          //       ),
                                          //     ],
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        // Bottom
                        i == 0
                            ? TopAnime(
                                2,
                                42,
                                curve: Curves.fastOutSlowIn,
                                child: Container(
                                  height: height / 6,
                                  // color: Colors.red,
                                  child: Stack(
                                    children: [
                                      // Positioned(
                                      //   left: 30,
                                      //   top: 15,
                                      //   child: Text(
                                      //     "Fogot Password?",
                                      //     style: TextStyle(
                                      //         fontSize: 16,
                                      //         fontWeight: FontWeight.w700),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 43),
                                        child: Container(
                                            height: height / 9,
                                            color:
                                                Colors.grey.withOpacity(0.4)),
                                      ),
                                      Positioned(
                                        left: 280,
                                        top: 10,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffF2C94C),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            width: width / 4,
                                            height: height / 12,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                              onPressed: () async {
                                                print(email);
                                                print(password);
                                                if (await postSignIn(
                                                    email, password)) {
                                                  setState(() {
                                                    validation = true;
                                                  });
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setBool(
                                                      "isSignedIn", true);
                                                  await getComplaints();

                                                  // Navigator.of(context).pushAndRemoveUntil(
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //         const ComplainTabList()),
                                                  //         (Route<dynamic> route) => false);
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ComplainTabList(
                                                                    complaintPending:
                                                                        complaintPending,
                                                                    complaintResolved:
                                                                        complaintResolved,
                                                                  )),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                } else {
                                                  validation = false;
                                                }
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             ComplainTabList()));
                                              },
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SignUPScreen()
                      ],
                    ),
                  )
                : SignUPScreen()),
      ),
    );
  }

  static Future<bool> postSignIn(String email, String password) async {
    var url = Uri.parse(constants.URL);
    Map body = {"email": email, "password": password};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    prefs.setString("login", bodyJson);
    Session session = Session();
    Response r = await session.post(bodyJson, "/login");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["utype"];
    // var name = bodyJson1["name"];
    prefs.setString("utype", c);
    prefs.setString("email", email);
    // prefs.setString("name", name);
    print(responseBody);
    if (r.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<void> getComplaints() async {
    // sqlite database
    var db = await openDatabase('mit_users.db');
    await db.execute("""
    CREATE TABLE IF NOT EXISTS complaints_pending (
  complaintid int(11) NOT NULL,
  email varchar(50) NOT NULL,
  block varchar(45) NOT NULL,
  floor int(11) NOT NULL,
  roomno varchar(25) NOT NULL,
  complaint varchar(300) NOT NULL,
  complainttype varchar(25) NOT NULL,
  status varchar(20) NOT NULL,
  ts timestamp NOT NULL,
  PRIMARY KEY (complaintid)
);
    """);

    List<String> temp = [];

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
          timeStamp: c[i]["cts"].toString());
      if (complaint1.status == "Registered") {
        complaintPending.add(complaint1);
        int a = await db.rawInsert(
            "INSERT OR IGNORE INTO complaints_pending(complaintid, email, block, floor, roomno, complaint, complainttype, status, ts) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)",
            [
              c[i]["complaintid"],
              email,
              c[i]["block"],
              c[i]["floor"],
              c[i]["roomno"],
              c[i]["complaint"],
              c[i]["complainttype"],
              c[i]["status"],
              c[i]["ts"]
            ]);
        print(a);
      } else {
        complaintResolved.add(complaint1);
      }
    }

    print(responseBody);
  }
}
