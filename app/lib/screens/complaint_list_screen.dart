import 'dart:convert';

import 'package:complaint_app/complaint.dart';
import 'package:complaint_app/main.dart';
import 'package:complaint_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../person.dart';
import '../services.dart';

class ComplaintList extends StatefulWidget {
  final List<Complaint> complaint;
  const ComplaintList({Key? key, required this.complaint}) : super(key: key);

  @override
  _ComplaintListState createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  List<Person> persons = [
    Person(
        name: 'Bill Will',
        bio:
            "Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed."),
    Person(name: 'Andy Smith', bio: "UI Designer"),
    Person(name: 'Creepy Story', bio: "Software Tester")
  ];

  List<Complaint> complaints = [];

  Widget personDetailCard(Person) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          String topic = Person.block ?? "";
          String description = Person.complaint ?? "";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPage(
                        topic: topic,
                        description: description,
                        complaint: Person,
                      )));
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Person.block,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      Text(
                        Person.complaint,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    complaints = widget.complaint;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () async {
            Session session = Session();
            Map body = {};
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var bodyJson = jsonEncode(body);
            Response r = await session.post(bodyJson, "/college_viewcomplaint");
            var responseBody = r.body;
            String? email = prefs.getString("email");
            String? utype = prefs.getString("utype");

            final bodyJson1 = json.decode(responseBody);
            var c = bodyJson1["complaint"];
            List<Complaint> arr = [];
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
              arr.add(complaint1);
            }
            complaints = arr;
            setState(() {});
          });
        },
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  String topic = complaints[index].block ?? "";
                  String description = complaints[index].complaint ?? "";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                                topic: topic,
                                description: description,
                                complaint: complaints[index],
                              )));
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
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                complaints[index].block,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                complaints[index].complaint,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis),
                              )
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
          itemCount: complaints.length,
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
