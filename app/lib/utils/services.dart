import 'dart:async';
import 'package:complaint_app/utils/constant.dart' as constants;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Map<String, String> headers = {"Content-Type": "application/json"};

class Session {
  Future<http.Response> get(String url) async {
    var url = Uri.parse(constants.URL);
    http.Response response = await http.get(url, headers: headers);
    updateCookie(response);
    return response;
  }

  Future<http.Response> post(var data, String endPoint) async {
    var url = Uri.parse(constants.URL + endPoint);
    if (endPoint != "/getNotification")
      EasyLoading.show(
          status: 'Loading...', maskType: EasyLoadingMaskType.black);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString("cookie");
    if (cookie != null && cookie != "") {
      headers['Cookie'] = cookie;
    }
    http.Response response = await http.post(url, body: data, headers: headers);

    Timer(Duration(seconds: 3), (){
      EasyLoading.dismiss();

      if (response.statusCode != 200)
        EasyLoading.showError("Oops! Error ");
    });
    if (endPoint == "/logout") {
      headers = {"Content-Type": "application/json"};
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("cookie", "");
    } else {
      updateCookie(response);
    }
    return response;
  }

  void updateCookie(http.Response response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString("cookie");
    String? rawCookie = response.headers['set-cookie'];
    print("response.headers['set-cookie']");
    print(rawCookie);
    String session = "";
    if (cookie != null && cookie != "") {
      headers['Cookie'] = cookie;
    } else if (rawCookie != null) {
      List<String> cookies = rawCookie.split(';');

      session = cookies[0];
      prefs.setString("cookie", session);
      headers['Cookie'] = session;
    }
  }
}
