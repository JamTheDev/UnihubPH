import 'package:flutter/material.dart';
import 'package:unihub/DartFiles/RegisterInformation.dart';

import 'Credentials.dart';

class UserInfo1 extends StatefulWidget {
  @override
  _UserInfo1State createState() => _UserInfo1State();
}

class _UserInfo1State extends State<UserInfo1> {
  String firstName, lastName;
  final GlobalKey<FormState> forms = new GlobalKey();
  final TextEditingController cont1 = new TextEditingController(), cont2 = new TextEditingController();
  void _validateTextViews(){
    if(forms.currentState.validate()){
      forms.currentState.save();
      RegisterInformation.firstName = firstName;
      RegisterInformation.lastName = lastName;
      Navigator.pushNamedAndRemoveUntil(context, "/credentials", (r) => false);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                          "What's your name?",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            "Let your name be known!",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(45, 50, 0, 0),
                            child: Text("First name", style: TextStyle(fontSize: 15, fontFamily: "Sen", color: Colors.grey), textAlign: TextAlign.left,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.symmetric(vertical: 13.0),
                                labelText: "First name",
                                hintText: "First name",
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.redAccent),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.redAccent),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(34, 167, 240, 1)),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                                prefixIcon: Icon(Icons.face),
                              ),
                              onSaved: (String value) {
                                firstName = cont1.text;
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "This is Required.";
                                }
                                return null;
                              },
                              controller: cont1,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(45, 0, 0, 0),
                            child: Text("Last name", style: TextStyle(fontSize: 15, fontFamily: "Sen", color: Colors.grey)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.symmetric(vertical: 13.0),
                                labelText: "Last name",
                                hintText: "Last name",
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.redAccent),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.redAccent),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(34, 167, 240, 1)),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                                prefixIcon: Icon(Icons.face),
                              ),
                              onSaved: (String value) {
                                lastName = cont2.text;
                              },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "This is Required.";
                                }
                                return null;
                              },
                              controller: cont2,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(20),
                              alignment: Alignment.bottomRight,
                              child: RaisedButton(
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Proceed",
                                      style: TextStyle(fontSize: 11.0, fontFamily: "Sen"),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 40.0,
                                      color: Color.fromRGBO(34, 167, 240, 1),
                                    ),
                                  ],
                                ),
                                textColor: Colors.black,

                                shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        style: BorderStyle.solid, width: 1.0, color: Colors.white),
                                    borderRadius: new BorderRadius.circular(20.0)),
                                onPressed: () {
                                  _validateTextViews();

                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    flex: 7)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
