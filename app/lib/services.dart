import 'dart:convert';
import 'package:complaint_app/constant.dart' as constants;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString("cookie");
    if (cookie != null && cookie != "") {
      headers['Cookie'] = cookie;
      print(cookie);
      print("session session");
    }
    http.Response response = await http.post(url, body: data, headers: headers);
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
    String remember = "";
    String session = "";
    if (cookie != null && cookie != "") {
      headers['Cookie'] = cookie;
      print(cookie);
      print("session session");
    } else if (rawCookie != null) {
      // if(session == ""){
      List<String> cookies = rawCookie.split(';');
      print(cookies);
      // remember = cookies[0];
      session = cookies[0];
      // String temp = remember + "; " + cookies[cookies.length - 3].split(',')[1];
      prefs.setString("cookie", session);
      headers['Cookie'] = session;
    }
    print("headers     .....");
    print(headers);
  }
}
