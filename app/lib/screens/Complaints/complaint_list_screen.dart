import 'dart:convert';
import 'package:complaint_app/DataClass/complaint.dart';
import 'package:complaint_app/screens/Complaints/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:complaint_app/utils/services.dart';

import '../../utils/GettingComplaints.dart';

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

  List<Complaint> complaints = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComplaints();
  }

  Future<void> getComplaints() async {
      ComplaintsList.instance.GetComplaintList(widget.DomainType);
      complaints.clear();
      complaints = (widget.Status == "Registered")  ? ComplaintsList.complaintPending : ComplaintsList.complaintResolved;
      setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(

        onRefresh: () {
          return Future.delayed(Duration(seconds: 1), () async {
            await getComplaints();
          });
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("asset/background/admin-bg.jpg"),
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

