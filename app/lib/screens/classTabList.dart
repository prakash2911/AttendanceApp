import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../attendanceDetail.dart';
import '../services.dart';

class ClassListTab extends StatefulWidget {
  final List<Attendance> classList;
  const ClassListTab({Key? key, required this.classList}) : super(key: key);
  @override
  State<ClassListTab> createState() => _ClassListTabState();
}

class _ClassListTabState extends State<ClassListTab> {
  Future<void> getClassDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map body = {};
    var bodyJson = jsonEncode(body);
    Session session = Session();
    Response r = await session.post(bodyJson, "/getclass");
    final bodyJson1 = json.decode(r.body);
    for (int i = 0; i < bodyJson1["data"].length; i++) {}
  }

  List<Attendance> classList1 = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classList1 = widget.classList;
    getClassDetails();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () async {
            await getClassDetails();
          });
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  String topic = classList1[index].className ?? "error";
                  String description = classList1[index].strength ?? "error";
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ));
                },
                child: Card(
                  color: Colors.grey[800],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          // padding: const EdgeInsets.all(8.0),
                          padding: EdgeInsets.fromLTRB(8, 8, 10, 8),
                          child: Image.asset(
                            "assests/class.gif",
                            height: 50,
                            fit: BoxFit.contain,
                            width: 50,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                classList1[index].className,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      classList1[index].strength,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(40),
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          child: Text(
                                            "Take Attendance",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(40),
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: Text(
                                            "Remove Class",
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          )),
                                    )
                                  ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: classList1.length,
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
