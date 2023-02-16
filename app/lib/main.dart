import 'dart:async';
import 'dart:convert';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:complaint_app/screens/Complaints/admin_tab_list.dart';
import 'package:complaint_app/screens/Complaints/complaint_tab_list_screen.dart';
import 'package:complaint_app/screens/Sign-Signup//login_screen.dart';
import 'package:complaint_app/utils/GettingComplaints.dart';
import 'package:complaint_app/utils/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';


import 'DataClass/complaint.dart';

const simplePeriodicTask = "simplePeriodicTask";

void showNotification( v, flp) async {
  var android = AndroidNotificationDetails(
      'channel id', 'channel NAME',channelDescription : 'CHANNEL DESCRIPTION' ,
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android,iOS: iOS);
  var block = v["block"];
  var floor = v["floor"];
  var room = v["rooms"];
  var complaint = v["complaint"];
  var status = v["status"];
  String? notificationString="";
  for(int i=0;i<block.length;i++){
    notificationString = block[i]+ " - " +floor[i]+" - "+"-"+room[i]+complaint[i]+" : "+status[i]+"\n";
  }
  await flp.show(0, "Complaints" ,notificationString, platform,
      payload: 'VIS \n $v');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = ((prefs.getBool('isSignedIn') == null)
      ? false
      : prefs.getBool('isSignedIn'))!;
  String utype = "";

  if(isLoggedIn){
    await Workmanager().initialize(callbackDispatcher); //to true if still in testing lev turn it to false whenever you are launching the app
    await Workmanager().registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15),//when should it check the link
      initialDelay: Duration(seconds: 5),//duration before showing the notification
    );
    utype = prefs.getString("utype")!;
  }
  runApp(MyApp(
    isLoggedIn: isLoggedIn,utype: utype
  ));
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("");
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android,iOS: iOS);
    flp.initialize(initSettings);
    Session session = new Session();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String utype = (prefs.getString("utype")=="Student") ? "Student" : prefs.getString("subtype")! ;
    Map body = {"email":prefs.getString("email"),"utype":utype};
    var sendData = jsonEncode(body);
    Response post = await session.post(sendData,"/getNotification");
    print(post.body);
    var body1 = jsonDecode(post.body);
    if(body1["status"]){
      showNotification(body1["complaint"], flp);
    }
  
    print(post);
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String utype;
  const MyApp({Key? key, required this.isLoggedIn,required this.utype}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MITRA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: SplashScreen(isLoggedIn: isLoggedIn),
      home: AnimatedSplashScreen(
        splash: Column(
          children: [
            ClipOval(
              child: Image(
                image: AssetImage("asset/icon/icon.png"),
                fit: BoxFit.fill,
                height: 150,
                width: 150,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            const Text(
              "MITRA",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffF5EFE6)),
            )
          ],
        ),
        // duration: 1500,
        backgroundColor: Color(0xff7895B2),
        splashIconSize: 250,
        centered: true,
        curve: Curves.fastOutSlowIn,
        nextScreen: MyHomePage(isLoggedIn: isLoggedIn,utype:utype ),
        splashTransition: SplashTransition.sizeTransition,
        animationDuration: Duration(milliseconds: 2000),
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool isLoggedIn;
  final String utype;
  const MyHomePage({Key? key, required this.isLoggedIn,required this.utype}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Complaint> complaintPending = [];
  List<Complaint> complaintResolved = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isLoggedIn)
      ComplaintsList.instance.GetComplaintList("college");
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isLoggedIn){
        if(widget.utype=="admin") return adminTablist(DomainType: "college",);
        return ComplainTabList(
            complaintPending: ComplaintsList.complaintPending,
            complaintResolved: ComplaintsList.complaintResolved,
            DomainType: "college",
          );
    }
    else return LoginScreen();
  }
  }

