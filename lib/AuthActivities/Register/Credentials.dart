import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unihub/DartFiles/RegisterInformation.dart';

import 'Credentials.dart';
import 'Location.dart';
import 'RegPart1.dart';

class Credentials extends StatefulWidget {
  @override
  _CredentialsState createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  bool _obscureText = true;
  String firstName, lastName;
  final GlobalKey<FormState> forms = new GlobalKey();
  final TextEditingController cont1 = new TextEditingController(), cont2 = new TextEditingController();
  void _validateTextViews(){
    if(forms.currentState.validate()){
      forms.currentState.save();
      if(lastName != ""){
        List len = lastName.split("");
        if(len.length < 6) {
          _showDialog("Password is too short!", "Error!");
        } else {
          if(validateStructure(lastName)) {
            RegisterInformation.userTag = firstName;
            RegisterInformation.password = lastName;
            Navigator.pushNamedAndRemoveUntil(context, "/location", (r) => false);
          } else {
            _showDialog("Password isn't strong enough!", "Error");
          }
        }

      }
    }
  }
  Future<void> _showDialog(String text, String title) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok."))
            ],
          );
        });
  }
  bool validateStructure(String value){
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
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
                          "Set your credentials",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: Text(
                            "Your credentials makes your identity unique in this app!",
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
                            child: Text("User tag", style: TextStyle(fontSize: 15, fontFamily: "Sen", color: Colors.grey), textAlign: TextAlign.left,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: TextFormField(
                              inputFormatters: [
                                new LengthLimitingTextInputFormatter(15),
                              ],
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.symmetric(vertical: 13.0),
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
                                prefixIcon: Icon(Icons.alternate_email),
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
                            child: Text("Password", style: TextStyle(fontSize: 15, fontFamily: "Sen", color: Colors.grey)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                            child: TextFormField(
                              obscureText: _obscureText,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                contentPadding: new EdgeInsets.symmetric(vertical: 13.0),
                                labelText: "Password",
                                hintText: "Password",
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
                                prefixIcon: Icon(Icons.vpn_key),
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
                                    ))
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
                            child: Row(
                              children: [
                               Expanded(
                                 child: Container(
                                    margin: EdgeInsets.all(20),
                                    alignment: Alignment.bottomLeft,
                                    child: RaisedButton.icon(
                                      onPressed: () {
                                        _validateTextViews();
                                        Navigator.pushNamedAndRemoveUntil(context, "/regp1", (r) => false);
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
