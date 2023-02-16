import 'dart:convert';
import 'package:complaint_app/screens/Complaints/admin_tab_list.dart';
import 'package:complaint_app/screens/Complaints/complaint_tab_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:complaint_app/animation/animations.dart';
import 'package:complaint_app/screens/Sign-Signup//signup_screen.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complaint_app/DataClass/complaint.dart';
import 'package:complaint_app/utils/constant.dart';
import 'package:complaint_app/utils/services.dart';

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
  String? email = "";
  String? password = "";
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

            // backgroundColor: Color(0xff7895B2),
            body: Container(
              height: double.infinity,
              decoration: BoxDecoration(

                image: DecorationImage(
                    image: AssetImage("asset/bg-1.jpg"),
                  fit: BoxFit.cover
                )
              ),
              child: i == 0
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
                                                              : Color(0xff30475E),
                                                          fontSize: 19,
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
                                                  TextStyle(color: Color(0xff3A3845)),
                                              showCursor: true,
                                              //cursorColor: mainColor,
                                              onChanged: (value) {
                                                setState(() {
                                                  email = value;
                                                });
                                              },
                                              decoration:
                                                  kTextFiledInputDecoration.copyWith(labelText: "Email",labelStyle:TextStyle(color: Color(0xff3A3845))),


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
                                                labelText: "Password",labelStyle: TextStyle(color: Color(0xff3A3845)),
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
                                                  Color(0xff30475E)),
                                        ),
                                        Positioned(
                                          left: 280,
                                          top: 10,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xff0078AA),
                                                  borderRadius:
                                                      BorderRadius.circular(50)),
                                              width: width / 4,
                                              height: height / 12,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.arrow_forward,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () async {
                                                  print(email);
                                                  print(password);
                                                  if (await postSignIn(
                                                      email!, password!)) {
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
                                                    if(prefs.getString("utype")=="admin")
                                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>adminTablist(DomainType: "college")), (route) => false);
                                                    else
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ComplainTabList(
                                                                      complaintPending:
                                                                          complaintPending,
                                                                      DomainType:
                                                                          "college",
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
                                                  final snackBar = SnackBar(
                                                    content: const Text(
                                                        'Login Successful!'),
                                                    action: SnackBarAction(
                                                      label: 'Undo',
                                                      onPressed: () {
                                                        // Some code to undo the change.
                                                      },
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
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
                  : SignUPScreen(),
            )),
      ),
    );
  }

  static Future<bool> postSignIn(String email, String password) async {
    Map body = {"email": email, "password": password};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    prefs.setString("login", bodyJson);
    Session session = Session();
    Response r = await session.post(bodyJson, "/login");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    prefs.setString("utype", bodyJson1['utype']!);
    prefs.setString("subtype", bodyJson1['subtype']!);
    prefs.setString("email", email);
    prefs.setString("name", bodyJson1['username']!);
    print(responseBody);
    if (r.statusCode == 200) {
      return true;
    }
    return false;
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
}
