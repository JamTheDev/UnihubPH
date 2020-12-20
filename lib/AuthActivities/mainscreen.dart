import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/CustomWidgets/TextWid.dart';
import 'package:unihub/CustomWidgets/images.dart';
import 'package:unihub/MainFeed/HomeScreen.dart';
import 'LoginScreen.dart';

enum AuthState{
  notLoggedIn,
  loggedIn
}
class MainAppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainAppScreenState();
  }
}



class _MainAppScreenState extends State<MainAppScreen> {
  AuthState _aState = AuthState.notLoggedIn;
  _signOut() async {
    await FirebaseAuth.instance.signOut().whenComplete(
            () => Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false));
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();

   /*
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if(event == null){
        _aState = AuthState.loggedIn;
      }else{
        _aState = AuthState.notLoggedIn;
      }
    });
    */
   FirebaseAuth a = FirebaseAuth.instance;
   if(a.currentUser != null){
     _aState = AuthState.loggedIn;
   }else{
     _aState = AuthState.notLoggedIn;
   }

  }
  @override
  Widget build(BuildContext context) {
    switch(_aState){
      case AuthState.notLoggedIn:
        Timer(Duration(seconds: 3), (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
        });
        break;
      case AuthState.loggedIn:
        Timer(Duration(seconds: 3), (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        });
        break;

    }
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(7, 105, 178, 1),
        body: SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  images("./images/app_icon.png"),
                  TextWid("UNIHUB", fontSize: 25, fontFamily: "DefaultFont", color: Colors.white,),
                  TextWid("yu-ni-h-b+", fontSize: 30, fontFamily: "Baybayin", color: Colors.white)
                ],
              ),
            )
        ),
      ),
    );
  }
}
