import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unihub/CustomWidgets/TextWid.dart';
import 'package:unihub/DartFiles/AuthExceptionHandler.dart';
import 'package:unihub/MainFeed/HomeScreen.dart';
import 'AuthService.dart';
import 'Register/WelcomeP1.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoggingIn = false;
  bool _obscureText = true;
  String email, password;
  final TextEditingController controller = new TextEditingController();
  final TextEditingController controller2 = new TextEditingController();
  final GlobalKey<FormState> form = new GlobalKey<FormState>();

  Future<void> clearControllers() async {
    User u = FirebaseAuth.instance.currentUser;
    if (form.currentState.validate()) {
      form.currentState.save();
      setState(() {
        isLoggingIn = true;
      });
      final status = await AuthService().login(email: email, pass: password);


      print(status);
      if(status == AuthResultStatus.successful || status == AuthResultStatus.emailAlreadyExists) {
        setState(() {
          isLoggingIn = false;
        });
        controller.text = "";
        controller2.text = "";
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      } else {
        setState(() {
          isLoggingIn = false;
        });
        final errorMsg = AuthExceptionHandler.generateExceptionMessage(status);
        _showDialog(errorMsg, "Error!");
      }
    }
  }

  Future<void> _showDialog(String text, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontFamily: "Sen"),
            ),
            content: Text(text, style: TextStyle(fontFamily: "Sen")),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok", style: TextStyle(fontFamily: "Sen")))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWid(
                "pu--m--so--k",
                fontFamily: "Baybayin",
                fontSize: 50,
                color: Colors.black,
              ),
              TextWid(
                "PUMASOK",
                fontFamily: "Sen",
                fontSize: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Text("Welcome to Unihub!",
                        style: TextStyle(
                            fontFamily: "Sen",
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Text(
                        "Join the Social Media Community of Filipinos over the internet right now!",
                        style: TextStyle(
                            fontFamily: "Sen",
                            fontSize: 13,
                            color: Colors.black)),
                  ],
                ),
              ),
              Form(
                key: form,
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 5),
                        alignment: Alignment.centerLeft,
                        child: Text("Email Address",
                            style: TextStyle(
                                fontFamily: "Sen",
                                fontSize: 13,
                                color: Colors.black)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                new EdgeInsets.symmetric(vertical: 13.0),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(34, 167, 240, 1)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            ),
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Email is Required.";
                            }
                            if (!RegExp(
                                    r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*)@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])")
                                .hasMatch(value)) {
                              return "Please enter a valid email address.";
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            email = controller.text;
                          },
                          controller: controller,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 5),
                        alignment: Alignment.centerLeft,
                        child: Text("Password",
                            style: TextStyle(
                                fontFamily: "Sen",
                                fontSize: 13,
                                color: Colors.black)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: TextFormField(
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              contentPadding:
                                  new EdgeInsets.symmetric(vertical: 13.0),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.redAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(34, 167, 240, 1)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                  child: Icon(
                                    !_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.black,
                                  ))),
                          onSaved: (String value) {
                            password = controller2.text;
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "Password is Required.";
                            }
                            return null;
                          },
                          controller: controller2,
                        ),
                      ),
                      (isLoggingIn)
                          ? Container(
                              margin: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  CircularProgressIndicator(),
                                  Text(
                                    "Logging in your account",
                                    style: TextStyle(
                                        fontFamily: "Sen",
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))
                          : Container(),
                      /*
                            Container(
                        width: 300,
                        height: 60,
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: FlatButton(
                              onPressed: clearControllers,
                              textColor: Colors.white,
                              hoverColor: Color.fromRGBO(30, 141, 202, 1),
                              color: Color.fromRGBO(34, 167, 240, 1),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontFamily: "DefaultFont", fontSize: 20),
                              ),
                            )),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: FlatButton(
                          onPressed: () {
                            controller.text = "";
                            controller2.text = "";
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WelcomeP1()));
                          },
                          child:
                      )
                       */
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Don't have an account? ",
                                style: TextStyle(
                                    fontFamily: "DefaultFont",
                                    fontSize: 11,
                                    color: Colors.grey)),
                            GestureDetector(
                              onTap: () {
                                controller.text = "";
                                controller2.text = "";
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomeP1()));
                              },
                              child: Text("Click me ",
                                  style: TextStyle(
                                      fontFamily: "DefaultFont",
                                      fontSize: 11,
                                      color: Color.fromRGBO(34, 167, 240, 1))),
                            ),
                            Text("to register! ",
                                style: TextStyle(
                                    fontFamily: "DefaultFont",
                                    fontSize: 11,
                                    color: Colors.grey)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.bottomLeft,
                              child: RaisedButton(
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "./images/googlelogo.png",
                                      width: 25,
                                      height: 25,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                      child: Text(
                                        "Google",
                                        style: TextStyle(
                                            fontSize: 11.0, fontFamily: "Sen"),
                                      ),
                                    )
                                  ],
                                ),
                                textColor: Colors.black,
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                        color: Colors.white),
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              alignment: Alignment.bottomRight,
                              child: RaisedButton(
                                color: Color.fromRGBO(34, 167, 240, 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Proceed",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          fontFamily: "Sen",
                                          color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 40.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                textColor: Colors.black,
                                shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        width: 1.0,
                                        color: Color.fromRGBO(34, 167, 240, 1)),
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                                onPressed: clearControllers,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
