import 'dart:async';
import 'dart:convert';

import 'package:complaint_app/screens/complaint_tab_list_screen.dart';
import 'package:complaint_app/screens/login_screen.dart';
import 'package:complaint_app/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'complaint.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.startService();
  await initializeService();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'));

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  });

  bool isLoggedIn = ((prefs.getBool('isSignedIn') == null)
      ? false
      : prefs.getBool('isSignedIn'))!;
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(isLoggedIn: isLoggedIn),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool isLoggedIn;
  const MyHomePage({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Complaint> complaintPending = [];
  List<Complaint> complaintResolved = [];
  @override
  Widget build(BuildContext context) {
    return widget.isLoggedIn
        ? ComplainTabList(
            complaintPending: complaintPending,
            complaintResolved: complaintResolved)
        : LoginScreen();
  }

  Future<void> getComplaints() async {
    Session session = Session();
    Map body = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var bodyJson = jsonEncode(body);
    Response r = await session.post(bodyJson, "/viewcomplaint");
    var responseBody = r.body;

    final bodyJson1 = json.decode(responseBody);
    var c = bodyJson1["complaint"];
    print(c);
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
      if (complaint1.status == "Registered") {
        complaintPending.add(complaint1);
      } else {
        complaintResolved.add(complaint1);
      }
    }

    print(responseBody);
  }
}

Future<void> _showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('1', 'test',
          channelDescription: 'Testing testing',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'New complaint',
      'Please check the complaint', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');

  return true;
}

void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
  Timer.periodic(const Duration(seconds: 30), (timer) async {
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Updated at ${DateTime.now()}",
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print("helo");

      String? utype = prefs.getString("utype");
      bool? isSignedIn = prefs.getBool("isSignedIn");
      print(utype);
      if (utype != null && isSignedIn == true) {
        await getComplaints();
      }
      // if(utype != null) {
      //   _showNotification();
      // }
    }

    /// you can see this log in logcat
    print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

    service.invoke(
      'update',
      {
        "current_date": DateTime.now().toIso8601String(),
      },
    );
  });
}

Future<void> getComplaints() async {
  // sqlite database
  var db = await openDatabase('mit_users.db');
  var c1 = await db.rawQuery("SELECT * FROM complaints_pending");
  print("c1c1c1");
  print(c1);
  await db.execute("""
    CREATE TABLE IF NOT EXISTS complaints_pending (
  complaintid int(11) NOT NULL,
  email varchar(50) NOT NULL,
  block varchar(45) NOT NULL,
  floor int(11) NOT NULL,
  roomno varchar(25) NOT NULL,
  complaint varchar(300) NOT NULL,
  complainttype varchar(25) NOT NULL,
  status varchar(20) NOT NULL,
  ts timestamp NOT NULL,
  PRIMARY KEY (complaintid)
);
    """);

  List<String> temp = [];

  Session session = Session();
  Map body = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var bodyJson = jsonEncode(body);
  Response r = await session.post(bodyJson, "/viewcomplaint");
  var responseBody = r.body;
  String? email = prefs.getString("email");
  String? utype = prefs.getString("utype");

  final bodyJson1 = json.decode(responseBody);
  var c = bodyJson1["complaint"];
  print(c);
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

    if (complaint1.status == "Registered") {
      int a = await db.rawInsert(
          "INSERT OR IGNORE INTO complaints_pending(complaintid, email, block, floor, roomno, complaint, complainttype, status, ts) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)",
          [
            c[i]["complaintid"],
            email,
            c[i]["block"],
            c[i]["floor"],
            c[i]["roomno"],
            c[i]["complaint"],
            c[i]["complainttype"],
            c[i]["status"],
            "asdf"
          ]);
      if (utype != null &&
          utype != "student" &&
          utype == complaint1.complainType &&
          a != 0) {
        _showNotification();
      }
      print(a);
    } else {
      print("else");
    }
  }

  print(responseBody);
}
