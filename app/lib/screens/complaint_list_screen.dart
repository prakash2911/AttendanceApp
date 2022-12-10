import 'dart:convert';
import 'package:complaint_app/complaint.dart';
import 'package:complaint_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../person.dart';
import '../services.dart';

class ComplaintList extends StatefulWidget {
  final String Status;
  final String DomainType;
  const ComplaintList(
      {Key? key, required this.Status, required this.DomainType})
      : super(key: key);
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
                      DomainType: widget.DomainType)));
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
    getComplaints();
  }

  Future<void> getComplaints() async {
    Session session = Session();
    Map body = {};
    complaints.removeRange(0, complaints.length);
    print(complaints.length);
    var bodyJson = jsonEncode(body);
    Response r = await session.post(
        bodyJson, "/" + widget.DomainType + "_viewcomplaint");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    print(c.length);
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
      if (complaint1.status == widget.Status) complaints.add(complaint1);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff181D31),

      body: RefreshIndicator(

        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () async {
            await getComplaints();
          });
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assests/bg/admin-bg.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    String topic = complaints[index].block ?? "error";
                    String description = complaints[index].complaint ?? "error";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(
                                  topic: topic,
                                  description: description,
                                  complaint: complaints[index],
                                  DomainType: widget.DomainType,
                                )));
                  },
                  child: Card(
                    color: Color(0xff30475E),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Padding(
                            // padding: const EdgeInsets.all(8.0),
                            padding: EdgeInsets.fromLTRB(8, 8, 15, 8),
                            child: Icon(Icons.assignment_turned_in_rounded,color: Colors.white,size: 30,)
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
      ),
    );
  }
}
