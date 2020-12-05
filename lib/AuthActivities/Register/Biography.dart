import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unihub/AuthActivities/Register/Birthday.dart';
import 'package:unihub/DartFiles/RegisterInformation.dart';

import 'Credentials.dart';
import 'Profile.dart';
import 'RegPart1.dart';

class Biography extends StatefulWidget {
  @override
  _BiographyState createState() => _BiographyState();
}

class _BiographyState extends State<Biography> {
  String firstName;
  final GlobalKey<FormState> forms = new GlobalKey();
  final TextEditingController cont2 = new TextEditingController();
  void _validateTextViews(){
    if(forms.currentState.validate()){
      forms.currentState.save();
      RegisterInformation.bio = firstName;
      Navigator.pushNamedAndRemoveUntil(context, "/profile", (r) => false);
    }
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
                          "Introduce yourself",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            "Let others know your interest, hobbies and personal background!",
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
                            child: Text("Bio", style: TextStyle(fontSize: 15, fontFamily: "Sen", color: Colors.grey), textAlign: TextAlign.left,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(150),
                              ],
                              minLines: 1,//Normal textInputField will be displayed
                              maxLines: 5,// when user presses enter it will adapt to it
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: "Type here",
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
                                prefixIcon: Icon(Icons.apartment),
                              ),
                              onSaved: (String value) {
                                firstName = cont2.text;
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
                            child: Row(
                              children: [
                               Expanded(
                                 child: Container(
                                    margin: EdgeInsets.all(20),
                                    alignment: Alignment.bottomLeft,
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        _validateTextViews();
                                        Navigator.pushNamedAndRemoveUntil(context, "/birthday", (r) => false);
                                      },
                                      icon: Icon(
                                        Icons.keyboard_arrow_left,
                                        size: 40.0,
                                        color: Color.fromRGBO(34, 167, 240, 1),
                                      ),
                                      label: Text("Back", style: TextStyle(fontSize: 11.0, fontFamily: "Sen"),),
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)),
                                    ),
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
                                ),
                              ],
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
