import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../complaint.dart';
import '../services.dart';

class DetailPage extends StatefulWidget {
  final String topic;
  final String description;
  final Complaint complaint;
  const DetailPage(
      {Key? key,
      required this.topic,
      required this.description,
      required this.complaint})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String utype = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUType();
  }

  Future<void> getUType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      utype = (prefs.getString("utype"))!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final levelIndicator = Container(
      child: Container(
        child: const LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: 2,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: const Text(
        // "\$20",
        "\$",
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: height * 0.06),
        Text(
          widget.topic,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "Floor: ",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.complaint.floor,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "Room: ",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.complaint.roomNo,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "Time: ",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.complaint.timeStamp,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            )
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.grey[800]),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      widget.description,
      style: const TextStyle(fontSize: 18.0, color: Colors.white),
    );
    final readButton = Container(
        padding: EdgeInsets.all(40),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.grey[800]),
            onPressed: widget.complaint.status == "verified" ||
                    (widget.complaint.status == "resolved" &&
                        utype != "student") ||
                    (widget.complaint.status == "Registered" &&
                        utype == "student")
                ? null
                : () async {
                    Session session = Session();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? email = prefs.getString("email");

                    if (widget.complaint.status == "Registered") {
                      Map body = {
                        "complaintid": widget.complaint.complaintId,
                        "Status": "resolved",
                        "email": email
                      };
                      var bodyJson = jsonEncode(body);
                      Response r = await session.post(
                          bodyJson, "/college_change_complaint_status");
                      var responseBody = r.body;
                      final bodyJson1 = json.decode(responseBody);
                      print(bodyJson1);
                      setState(() {
                        widget.complaint.status = "resolved";
                      });
                    } else if (widget.complaint.status == "resolved") {
                      Map body = {
                        "complaintid": widget.complaint.complaintId,
                        "Status": "verified",
                        "email": email
                      };
                      var bodyJson = jsonEncode(body);
                      Response r = await session.post(
                          bodyJson, "/college_change_complaint_status");
                      var responseBody = r.body;
                      final bodyJson1 = json.decode(responseBody);
                      print(bodyJson1);
                      setState(() {
                        widget.complaint.status = "verified";
                      });
                    }
                  },
            child: getText()));
    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomContentText],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[topContent, bottomContent, readButton],
      ),
    );
  }

  // Future<void> getComplaints() async {
  //   Session session = Session();
  //   Map body = {};
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var bodyJson = jsonEncode(body);
  //   Response r = await session.post(bodyJson, "/viewcomplaint");
  //   var responseBody = r.body;
  //
  //   final bodyJson1 = json.decode(responseBody);
  //   var c = bodyJson1["complaint"];
  //   print(c);
  //   for(int i = 0; i < c.length; i++) {
  //     Complaint complaint1 = Complaint(
  //         block: c[i]["block"],
  //         complaint: c[i]["complaint"],
  //         complainType: c[i]["complainttype"],
  //         floor: c[i]["floor"].toString(),
  //         roomNo: c[i]["roomno"].toString(),
  //         status: c[i]["status"],
  //         complaintId: c[i]["complaintid"].toString(),
  //         timeStamp: c[i]["ts"].toString()
  //     );
  //     if(complaint1.status == "Registered") {
  //       complaintPending.add(complaint1);
  //     }
  //     else {
  //       complaintResolved.add(complaint1);
  //     }
  //   }
  //
  //   print(responseBody);
  // }

  Widget getText() {
    print(widget.complaint.status);
    print(utype);
    if (widget.complaint.status == "Registered" && utype == "student") {
      return const Text("Registered", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "resolved" && utype == "student") {
      return const Text("Verify", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "Registered") {
      return const Text("Resolve", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "resolved") {
      return const Text("Resolved", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "verified") {
      return const Text("Verified", style: TextStyle(color: Colors.white));
    } else {
      return Container();
    }
  }
}
