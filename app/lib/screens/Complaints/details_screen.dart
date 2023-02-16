import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:complaint_app/DataClass/complaint.dart';
import 'package:complaint_app/utils/services.dart';

class DetailPage extends StatefulWidget {
  final String topic;
  final String description;
  final Complaint complaint;
  final String DomainType;
  const DetailPage(
      {Key? key,
      required this.topic,
      required this.description,
      required this.complaint,
      required this.DomainType})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String utype = "";
  bool reportVisibility = false;
  String subtype = "";
  List<String> errors = ["unable solve", "Require time", "others"];
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
      subtype = (prefs.getString("subtype"))!;
      if ((widget.complaint.status == "Registered" &&
              subtype == widget.complaint.complainType) ||
          (utype == "Student" && widget.complaint.status == "Resolved"))
        reportVisibility = true;
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
            // backgroundColor: Color(),
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
          style: TextStyle(color: Colors.white, fontSize: 20.0),
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
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.complaint.roomNo,
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Registered Time: ",
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
        SizedBox(height: height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Updated Time: ",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  widget.complaint.updateStamp,
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
          decoration: BoxDecoration(color: Color(0xff30475E)),
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
    final reportButton = Visibility(
      visible: reportVisibility,
      child: Container(
          padding: EdgeInsets.all(100),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: widget.complaint.status == "verified" ||
                    (widget.complaint.status == "Resolved" &&
                        utype != "Student") ||
                    (widget.complaint.status == "Registered" &&
                        subtype != widget.complaint.complainType)
                ? null
                : () async {
                    Session session = Session();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? email = prefs.getString("email");

                    if (widget.complaint.status == "Registered" &&
                        subtype == widget.complaint.complainType) {
                      Map body = {
                        "complaintid": widget.complaint.complaintId,
                        "Status": "Unable To Resolve",
                        "email": email,
                      };

                      var bodyJson = jsonEncode(body);
                      print(bodyJson);
                      Response r = await session.post(bodyJson,
                          "/" + widget.DomainType + "_change_complaint_status");
                      var responseBody = r.body;
                      final bodyJson1 = json.decode(responseBody);
                      setState(() {
                        widget.complaint.status = "Not Resolved";
                      });
                    } else if (widget.complaint.status == "Resolved" &&
                        utype == "Student") {
                      Map body = {
                        "complaintid": widget.complaint.complaintId,
                        "Status": "Not Resolved",
                        "email": email
                      };
                      var bodyJson = jsonEncode(body);
                      Response r = await session.post(bodyJson,
                          "/" + widget.DomainType + "_change_complaint_status");
                      print(bodyJson + "\n\n");
                      var responseBody = r.body;
                      final bodyJson1 = json.decode(responseBody);
                      print(bodyJson1);
                      setState(() {
                        widget.complaint.status = "Not Resolved";
                      });
                    }
                    // final snackBar = SnackBar(
                    //   content: const Text('Resolved!'),
                    //   action: SnackBarAction(
                    //     label: 'Undo',
                    //     onPressed: () {
                    //       // Some code to undo the change.
                    //     },
                    //   ),
                    // );
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  },
            child: Text(
              "REPORT",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          )),
    );

    final readButton = Container(
        padding: EdgeInsets.all(40),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xff30475E)),
            onPressed: widget.complaint.status == "verified" ||
                    (widget.complaint.status == "Resolved" &&
                        utype != "Student") ||
                    (widget.complaint.status == "Registered" &&
                        subtype != widget.complaint.complainType)
                ? null
                : () async {
                    Session session = Session();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? email = prefs.getString("email");

                    if (widget.complaint.status == "Registered" &&
                        subtype == widget.complaint.complainType) {
                      Map body = {
                        "complaintid": widget.complaint.complaintId,
                        "Status": "Resolved",
                        "email": email,
                      };

                      var bodyJson = jsonEncode(body);
                      print(bodyJson);
                      Response r = await session.post(bodyJson,
                          "/" + widget.DomainType + "_change_complaint_status");
                      var responseBody = r.body;
                      final bodyJson1 = json.decode(responseBody);
                      setState(() {
                        widget.complaint.status = "Resolved";
                      });
                    } else if (widget.complaint.status == "Resolved" &&
                        utype == "Student") {
                      Map body = {
                        "complaintid": widget.complaint.complaintId,
                        "Status": "verified",
                        "email": email
                      };
                      var bodyJson = jsonEncode(body);
                      Response r = await session.post(bodyJson,
                          "/" + widget.DomainType + "_change_complaint_status");
                      print(bodyJson + "\n\n");
                      var responseBody = r.body;
                      final bodyJson1 = json.decode(responseBody);
                      print(bodyJson1);
                      setState(() {
                        widget.complaint.status = "verified";
                      });
                      Navigator.pop(context);
                    }
                    final snackBar = SnackBar(
                      content: const Text('Resolved!'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      backgroundColor:Colors.grey[850],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[topContent, bottomContent, reportButton, readButton],
      ),
    );
  }

  Widget getText() {
    if (widget.complaint.status == "Registered" && utype == "Student") {
      return const Text("Registered", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "Resolved" && utype == "Student") {
      return const Text("Verify", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "Registered" &&
        subtype == widget.complaint.complainType) {
      return const Text("Resolve", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "Resolved") {
      return const Text("Resolved", style: TextStyle(color: Colors.white));
    } else if (widget.complaint.status == "verified") {
      return const Text("Verified", style: TextStyle(color: Colors.white));
    } else {
      return Text(widget.complaint.status,style:TextStyle(color: Colors.white) ,);
    }
  }
}
