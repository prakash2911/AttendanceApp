// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math';

import 'package:complaint_app/screens/complaint_tab_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:complaint_app/animation/animations.dart';
import 'package:complaint_app/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../complaint.dart';
import '../constant.dart';
import '../services.dart';

class SignUPScreen extends StatefulWidget {
  SignUPScreen({Key? key}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;
  bool _checkemptype = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
    _passwordVisible1 = false;
  }

  final feature = ["Login", "Sign Up"];
  String email = "";
  String password = "";
  String name = "";
  String passwordCheck = "";
  String usertype = "Student";
  // String displayText = "Select the option";
  String? employeeType = null;
  String? studentType = null;
  int i = 1;
  List<Complaint> complaintPending = [];
  List<Complaint> complaintResolved = [];
  var uType = ["Student", "Employee"];
  var eType = ["Teacher", "RC"];
  var sType = ["DayScholar", "Hosteler"];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            backgroundColor: Color(0xfffdfdfdf),
            body: i == 1
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(25),
                          child: Column(
                            children: [
                              // TabBar Code
                              Row(children: [
                                Container(
                                  height: height / 19,
                                  width: width / 2,
                                  child: TopAnime(
                                    2,
                                    5,
                                    child: ListView.builder(
                                      itemCount: feature.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              i = index;
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Text(
                                                  feature[index],
                                                  style: TextStyle(
                                                    color: i == index
                                                        ? Colors.black
                                                        : Colors.grey,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
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
                                height: 25,
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
                                          text: "Hello ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 40,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "There",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 40,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: height / 20,
                              ),

                              // TextFiled
                              Container(
                                width: width / 1.2,
                                height: height / 2.1,
                                child: TopAnime(
                                  1,
                                  16,
                                  curve: Curves.easeInExpo,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextFormField(
                                        // readOnly: true, // * Just for Debug
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        showCursor: true,
                                        //cursorColor: mainColor,
                                        decoration: kTextFiledInputDecoration,
                                        onChanged: (value) {
                                          setState(() {
                                            email = value;
                                          });
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        // readOnly: true, // * Just for Debug
                                        cursorColor: Colors.black,
                                        style: TextStyle(color: Colors.black),
                                        showCursor: true,
                                        //cursorColor: mainColor,
                                        decoration: kTextFiledInputDecoration
                                            .copyWith(labelText: "Name"),
                                        onChanged: (value) {
                                          setState(() {
                                            name = value;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        // readOnly: true, // * Just for Debug
                                        cursorColor: Colors.black,
                                        obscureText: !_passwordVisible,
                                        style: TextStyle(color: Colors.black),
                                        showCursor: true,
                                        //cursorColor: mainColor,
                                        decoration:
                                            kTextFiledInputDecoration.copyWith(
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
                                        height: 15,
                                      ),
                                      // TextFormField(
                                      //   // autovalidateMode: AutovalidateMode.always,
                                      //   // key: formKey,
                                      //   // readOnly: true, // * Just for Debug
                                      //   cursorColor: Colors.black,
                                      //   style: TextStyle(color: Colors.black),
                                      //   showCursor: true,
                                      //   //cursorColor: mainColor,
                                      //   decoration:
                                      //       kTextFiledInputDecoration.copyWith(
                                      //           labelText: "Password again"),
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       passwordCheck = value;
                                      //     });
                                      //   },
                                      //   validator: (value) {
                                      //     if (password != passwordCheck) {
                                      //       return "Passwords do not match";
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      // ),

                                      // TextFormField(
                                      //   // readOnly: true, // * Just for Debug
                                      //   cursorColor: Colors.black,
                                      //   obscureText: !_passwordVisible1,
                                      //   style: TextStyle(color: Colors.black),
                                      //   showCursor: true,
                                      //   //cursorColor: mainColor,
                                      //   decoration:
                                      //       kTextFiledInputDecoration.copyWith(
                                      //     labelText: "Re-enter Password",
                                      //     suffixIcon: IconButton(
                                      //       icon: Icon(
                                      //         // Based on passwordVisible state choose the icon
                                      //         _passwordVisible1
                                      //             ? Icons.visibility
                                      //             : Icons.visibility_off,
                                      //         color: Theme.of(context)
                                      //             .primaryColorDark,
                                      //       ),
                                      //       onPressed: () {
                                      //         // Update the state i.e. toogle the state of passwordVisible variable
                                      //         setState(() {
                                      //           _passwordVisible1 =
                                      //               !_passwordVisible1;
                                      //         });
                                      //       },
                                      //     ),
                                      //   ),
                                      //   onChanged: (value) {
                                      //     setState(() {
                                      //       passwordCheck = value;
                                      //     });
                                      //   },
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      DropdownButtonFormField(
                                        hint: Text('Select the Usertype'),
                                        value: usertype,
                                        isExpanded: true,
                                        items: uType.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(items),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            usertype = newValue!;
                                            _checkemptype =
                                                (usertype == "Employee")
                                                    ? true
                                                    : false;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: _checkemptype,
                                        replacement: DropdownButtonFormField(
                                          hint: Text('Select the Student Type'),
                                          value: studentType,
                                          isExpanded: true,
                                          decoration: InputDecoration(),
                                          items: sType.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              studentType = newValue!;
                                              employeeType = null;
                                            });
                                          },
                                        ),
                                        child: DropdownButtonFormField(
                                          hint:
                                              Text('Select the Employee type'),
                                          value: employeeType,
                                          isExpanded: true,
                                          decoration: InputDecoration(),
                                          items: eType.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              studentType = null;
                                              employeeType = newValue!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom
                        i == 1
                            ? TopAnime(
                                2,
                                29,
                                curve: Curves.fastOutSlowIn,
                                child: Container(
                                  height: height / 6,
                                  // color: Colors.red,
                                  child: Stack(
                                    children: [
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
                                        child: GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xffEB5757),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              width: width / 4,
                                              height: height / 12,
                                              child: IconButton(
                                                  icon: Icon(
                                                    Icons.arrow_forward,
                                                    size: 35,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    if (false) {
                                                      print("not validated");
                                                    } else {
                                                      final prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      var url = Uri.parse(URL);
                                                      print(email);
                                                      print(name);
                                                      print(password);
                                                      var selectOption =
                                                          (studentType != null)
                                                              ? studentType
                                                              : employeeType;
                                                      var body = {
                                                        'email': email,
                                                        'username': name,
                                                        'password': password,
                                                        'utype': usertype,
                                                        'subtype': selectOption,
                                                      };
                                                      Session session =
                                                          Session();
                                                      var bodyJson =
                                                          jsonEncode(body);
                                                      prefs.setString(
                                                          "login", bodyJson);
                                                      Response r =
                                                          await session.post(
                                                              bodyJson,
                                                              "/register");
                                                      r = await session.post(
                                                          bodyJson, "/login");
                                                      var responseBody = r.body;
                                                      final bodyJson1 = json
                                                          .decode(responseBody);
                                                      var c =
                                                          bodyJson1["utype"];
                                                      prefs.setString(
                                                          "utype", c);
                                                      print(responseBody);
                                                      await prefs.setBool(
                                                          'isSignedIn', true);
                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ComplainTabList(
                                                                            complaintPending:
                                                                                complaintPending,
                                                                            complaintResolved:
                                                                                complaintResolved,
                                                                          )),
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    }
                                                  })),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : LoginScreen()
                      ],
                    ),
                  )
                : LoginScreen()),
      ),
    );
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
      } else {
        complaintResolved.add(complaint1);
      }
    }

    print(responseBody);
  }
}
