import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unihub/AuthActivities/Register/Biography.dart';
import 'package:unihub/AuthActivities/Register/Birthday.dart';
import 'package:unihub/AuthActivities/Register/Credentials.dart';
import 'package:unihub/AuthActivities/Register/EmailVerification.dart';
import 'package:unihub/AuthActivities/Register/Location.dart';
import 'package:unihub/AuthActivities/Register/RegPart1.dart';
import 'package:unihub/AuthActivities/Register/WelcomeP1.dart';
import 'package:unihub/MainFeed/Home.dart';
import 'package:unihub/MainFeed/HomeScreen.dart';
import 'AuthActivities/Register/Profile.dart';
import 'AuthActivities/mainscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => MyApp(),
        "/login": (context) => MainAppScreen(),
        "/welc": (context) => WelcomeP1(),
        "/regp1": (context) => UserInfo1(),
        "/credentials": (context) => Credentials(),
        "/location": (context) => Location(),
        "/biography": (context) => Biography(),
        "/birthday": (context) => Birthday(),
        "/profile": (context) => Profile(),
        "/verification": (context) => Verification(),
        "/home": (context) => HomeScreen(),
      },
    )
  );
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MainAppScreen()
    );
  }
}