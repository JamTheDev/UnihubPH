import 'package:flutter/material.dart';
import 'package:unihub/DartFiles/RegisterInformation.dart';

import 'Biography.dart';
import 'Credentials.dart';
import 'Location.dart';
import 'RegPart1.dart';

class Birthday extends StatefulWidget {
  @override
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  String firstName, lastName, third;
  DateTime picker;
  bool pressAttention = false;
  DateTime current;
  final GlobalKey<FormState> forms = new GlobalKey();
  final TextEditingController cont1 = new TextEditingController(),
      cont2 = new TextEditingController(),
      cont3 = new TextEditingController();

  Future _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: picker,
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime(DateTime.now().year + 1));
    if (date != null) {
      setState(() {
        picker = date;
      });
    }
  }
  Future<void> _showDialog(String title, String text) async {
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
  void _validateTextViews() {
    print(DateTime(DateTime.now().year).toString() + " " + picker.year.toString());
    if (DateTime(DateTime.now().year).toString() != picker.year.toString()) {
      RegisterInformation.day = picker.day.toString();
      RegisterInformation.month = picker.month.toString();
      RegisterInformation.year = picker.year.toString();
      Navigator.pushNamedAndRemoveUntil(context, "/biography", (r) => false);
    } else {
      _showDialog("Err...", "The year is the same! please change your birthdate before proceeding.");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    picker = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(34, 167, 240, 1),
          child: Form(
            key: forms,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(34, 167, 240, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "When is your birthday?",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            "Tell others when your special day comes!",
                            style: TextStyle(
                                fontFamily: "Sen",
                                fontSize: 20,
                                color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 4,
                ),
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text("Pick your birthdate! ",
                                style: TextStyle(
                                  fontFamily: "Sen",
                                  fontSize: 15,
                                  color: Colors.black,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Text("${picker.year}",
                                      style: TextStyle(
                                        fontFamily: "Sen",
                                        fontSize: 25,
                                        color: Colors.black,
                                      )),
                                ),
                                Container(
                                  child: Text("/",
                                      style: TextStyle(
                                        fontFamily: "Sen",
                                        fontSize: 25,
                                        color: Colors.black,
                                      )),
                                ),
                                Container(
                                  child: Text("${picker.day}",
                                      style: TextStyle(
                                        fontFamily: "Sen",
                                        fontSize: 25,
                                        color: Colors.black,
                                      )),
                                ),
                                Container(
                                  child: Text("/",
                                      style: TextStyle(
                                        fontFamily: "Sen",
                                        fontSize: 25,
                                        color: Colors.black,
                                      )),
                                ),
                                Container(
                                  child: Text("${picker.month}",
                                      style: TextStyle(
                                        fontFamily: "Sen",
                                        fontSize: 25,
                                        color: Colors.black,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 180,
                            height: 40,
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: FlatButton(
                                  onPressed: () {
                                    _pickDate();
                                  },
                                  textColor: Colors.black,
                                  hoverColor: Color.fromRGBO(30, 141, 202, 1),
                                  color: Colors.white,
                                  shape: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                          color: Colors.black),
                                      borderRadius:
                                      new BorderRadius.circular(20.0)),
                                  child: Text(
                                    "Set birthdate!",
                                    style: TextStyle(
                                        fontFamily: "Sen",
                                        fontSize: 13),
                                  ),
                                )),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    alignment: Alignment.bottomLeft,
                                    child: RaisedButton(
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.keyboard_arrow_left,
                                            size: 40.0,
                                            color: Colors.black,
                                          ),
                                          Container(
                                            child: Text(
                                              "Back",
                                              style: TextStyle(
                                                  fontSize: 11.0,
                                                  fontFamily: "Sen"),
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
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Proceed",
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                fontFamily: "Sen",
                                                color: Colors.black),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_right,
                                            size: 40.0,
                                            color: Color.fromRGBO(34, 167, 240, 1),
                                          ),
                                        ],
                                      ),
                                      textColor: Colors.white,
                                      shape: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              width: 1.0,
                                              color: Colors.white),
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
                                      onPressed: _validateTextViews,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    flex: 7),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
