import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unihub/AuthActivities/AuthService.dart';
import 'file:///C:/Users/Admin/AndroidStudioProjects/flutter/unihub/lib/AuthActivities/Register/BiographyScreen.dart';
import 'package:unihub/CustomWidgets/TextWid.dart';
import 'package:unihub/DartFiles/UserUID.dart';

import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController email = new TextEditingController();
  final TextEditingController pass = new TextEditingController();
  final TextEditingController fn = new TextEditingController();
  final TextEditingController ln = new TextEditingController();
  String inputEmail, inputPass, inputFn, inputLn;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _forms = new GlobalKey<FormState>();
    // TODO: implement build
    // https://stackoverflow.com/questions/44297839/how-to-transform-futurelistmap-to-listmap-in-dart-language

    Future<void> _showDialog() async {
      return showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                  "1 or more text fields hasn't been filled up, try again!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Ok."))
              ],
            );
          });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Color.fromRGBO(34, 167, 240, 1),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(34, 167, 240, 1),
                      ),
                    )),
                Expanded(
                    flex: 9,
                    child: Container(
                      child: Form(
                        key: _forms,
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0))),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  child: Text(
                                    "gu-------m-------w",
                                    style: TextStyle(
                                        fontFamily: "Baybayin",
                                        fontSize: 40,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                TextWid(
                                  "GUMAWA",
                                  fontFamily: "DefaultFont",
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      hintText: "First name",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  34, 167, 240, 1)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(Icons.perm_identity),
                                    ),
                                    validator: (String value) {
                                      return value.isEmpty
                                          ? "This field is required"
                                          : null;
                                    },
                                    controller: fn,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      hintText: "Last name",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  34, 167, 240, 1)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(Icons.perm_identity),
                                    ),
                                    validator: (String value) {
                                      return value.isEmpty
                                          ? "This field is required"
                                          : null;
                                    },
                                    controller: ln,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: "Email Address",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  34, 167, 240, 1)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return "This field is required.";
                                      }
                                      if (!RegExp(
                                              r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*)@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])")
                                          .hasMatch(value)) {
                                        return "Please enter a valid email address.";
                                      }
                                      return null;
                                    },
                                    controller: email,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: true,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.redAccent),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  34, 167, 240, 1)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: Icon(Icons.lock),
                                    ),
                                    validator: (String value) {
                                      return value.isEmpty
                                          ? "This field is required"
                                          : null;
                                    },

                                    onSaved: (String value) => inputFn = fn.text,
                                    controller: pass,
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  height: 60,
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 20, 0),
                                      child: FlatButton(
                                        onPressed: () {
                                          /*
                                          if (_forms.currentState.validate()) {
                                            _forms.currentState.save();

                                            inputEmail = email.text;
                                            inputPass = pass.text;
                                            inputFn = fn.text;
                                            inputLn = ln.text;
                                            AuthService()
                                                .registerAccount(email, pass);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BiographyScreen()));
                                            email.clear();
                                            pass.clear();
                                            fn.clear();
                                            ln.clear();
                                          } else {
                                            if (inputEmail.isEmpty ||
                                                inputPass.isEmpty ||
                                                inputFn.isEmpty ||
                                                inputLn.isEmpty) {
                                              _showDialog();
                                            }
                                          }
                                           */
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => BiographyScreen()));
                                        },
                                        textColor: Colors.white,
                                        hoverColor:
                                            Color.fromRGBO(30, 141, 202, 1),
                                        color: Color.fromRGBO(34, 167, 240, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Text(
                                          "Register!",
                                          style: TextStyle(
                                              fontFamily: "DefaultFont",
                                              fontSize: 20),
                                        ),
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                  child: Column(
                                    children: [
                                      Text(
                                          "By creating an account, you accept our",
                                          style: TextStyle(
                                              fontFamily: "DefaultFont",
                                              color: Colors.grey)),
                                      GestureDetector(
                                          onTap: () {},
                                          child: Text("Terms & Conditions",
                                              style: TextStyle(
                                                  fontFamily: "DefaultFont",
                                                  color: Color.fromRGBO(
                                                      34, 167, 240, 1),
                                                  decoration: TextDecoration
                                                      .underline))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
