import 'dart:convert';

import 'package:complaint_app/DataClass/complaint.dart';
import 'package:complaint_app/utils/services.dart';
import 'package:http/http.dart';

class ComplaintsList{
  ComplaintsList._() {}
  static List<Complaint> complaintPending = [];
  static List<Complaint> complaintResolved = [];
  static List<Complaint> complaintVerify = [];
  static final ComplaintsList instance = ComplaintsList._();
   Future<void> GetComplaintList(String ComplaintDomain) async {
    Session session = Session();
    Map body = {};
    var bodyJson = jsonEncode(body);
    Response r = await session.post(bodyJson, "/"+ComplaintDomain.trim()+"_viewcomplaint");
    var responseBody = r.body;
    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    complaintResolved.clear();
    complaintPending.clear();
    complaintVerify.clear();
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
      else if(complaint1.status == "verify")
        complaintVerify.add(complaint1);
    }
  }


}

