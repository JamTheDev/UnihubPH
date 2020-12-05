import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import "package:image_picker/image_picker.dart";
import 'package:unihub/MainFeed/HomeScreen.dart';

class BiographyScreen extends StatefulWidget {
  @override
  _BiographyScreenState createState() => _BiographyScreenState();
}

class _BiographyScreenState extends State<BiographyScreen> {
  Widget imageWidget() {
    if (_selectedFile != null) {
      return Container(
        width: 100,
        height: 100,
        child: CircleAvatar(
          child: ClipOval(
            child: Image.file(
              _selectedFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 100,
        height: 100,
        child: CircleAvatar(
          child: ClipOval(
            child: Image.asset(
              "./images/placeholder.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
  }

  final ref = FirebaseDatabase.instance.reference();
  String userstr, biostr, adrstr, monthstr, dayint, pnint, yearint;
  final GlobalKey<FormState> _key = new GlobalKey<FormState>();
  final TextEditingController username = new TextEditingController();
  final TextEditingController bio = new TextEditingController();
  final TextEditingController address = new TextEditingController();
  final TextEditingController pn = new TextEditingController();
  final TextEditingController day = new TextEditingController();
  final TextEditingController year = new TextEditingController();
  final TextEditingController month = new TextEditingController();

  void pushToDatabase() {
    var map = {
      "username": userstr,
      "bio": biostr,
      "address": adrstr,
      "phone": pnint,
      "month": monthstr,
      "day": dayint,
      "year": yearint
    };
    ref.child("UserInfo/").push().set(map).whenComplete(() => Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomeScreen())));
  }

  void _validateTextViews() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      print(userstr);
      pushToDatabase();
    }
  }

  bool inProcess = false;
  File _selectedFile;

  _getImage(ImageSource src) async {
    if (inProcess != true) {
      setState(() {
        inProcess = true;
      });
      File imageFile = await ImagePicker.pickImage(source: src);
      if (imageFile != null) {
        File cropped = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 300,
          maxWidth: 300,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: "Pick your Profile Image!",
              toolbarColor: Colors.blue,
              statusBarColor: Colors.blue,
              backgroundColor: Colors.white),
        );

        setState(() {
          _selectedFile = cropped;
          inProcess = false;
        });
      } else {
        setState(() {
          inProcess = false;
        });
      }
    }
  }

  Future<void> _showDialog(String text, String title) async {
    return showDialog<void>(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(34, 167, 240, 1),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(34, 167, 240, 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => _getImage(ImageSource.gallery),
                              child: imageWidget(),
                            ),
                            Text("Click to change profile",
                                style: TextStyle(
                                    fontFamily: "DefaultFont",
                                    fontSize: 15,
                                    color: Colors.white60))
                          ],
                        )),
                  ),
                  Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0))),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _key,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: Text("Introduce yourself!",
                                      style: TextStyle(
                                        fontFamily: "DefaultFont",
                                        fontSize: 20,
                                        color: Colors.black,
                                      )),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                      "Double-Tap a field to show extra information!",
                                      style: TextStyle(
                                        fontFamily: "DefaultFont",
                                        fontSize: 15,
                                        color: Colors.grey,
                                      )),
                                ),
                                Row(children: [
                                  Container(
                                      margin:
                                          EdgeInsets.fromLTRB(35, 20, 30, 10),
                                      child: Text(
                                          "Basic Information (* is required field): ",
                                          style: TextStyle(
                                            fontFamily: "DefaultFont",
                                            color: Colors.grey,
                                          )))
                                ]),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: GestureDetector(
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: "Username (*)",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent),
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

                                          return null;
                                        },
                                        controller: username,
                                        onSaved: (String value) {
                                          userstr = username.text;
                                        }),
                                    onDoubleTap: () => _showDialog(
                                        "This represents your username / nickname.",
                                        "Username"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: GestureDetector(
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: "Bio",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
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
                                      onSaved: (String value) {
                                        biostr = bio.text;
                                      },
                                      controller: bio,
                                    ),
                                    onDoubleTap: () => _showDialog(
                                        "Detailed description of a person's life. It involves more than just the basic facts like education, work, relationships, etc...",
                                        "Biography"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: GestureDetector(
                                    child: TextFormField(
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: InputDecoration(
                                        hintText: "Address",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
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
                                      onSaved: (String value) {
                                        adrstr = address.text;
                                      },
                                      controller: address,
                                    ),
                                    onDoubleTap: () => _showDialog(
                                        "An address is a collection of information, presented in a mostly fixed format, used to give the location of a building, apartment, or other structure or a plot of land.",
                                        "Address"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: GestureDetector(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "Phone Number",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
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
                                      onSaved: (String value) {
                                        pnint = pn.text;
                                      },
                                      controller: pn,
                                    ),
                                    onDoubleTap: () => _showDialog(
                                        "This represents your mobile number (EG: 09123456789)",
                                        "Phone Number"),
                                  ),
                                ),
                                Row(children: [
                                  Container(
                                      margin:
                                          EdgeInsets.fromLTRB(35, 0, 30, 10),
                                      child: Text("Birthday: ",
                                          style: TextStyle(
                                            fontFamily: "DefaultFont",
                                            color: Colors.grey,
                                          )))
                                ]),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(30, 0, 10, 10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                          hintText: "Day",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent),
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
                                        onSaved: (String value) {
                                          dayint = day.text;
                                        },
                                        controller: day,
                                      ),
                                    )),
                                    Flexible(
                                        child: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 0, 30, 10),
                                      child: TextFormField(
                                        keyboardType: TextInputType.datetime,
                                        decoration: InputDecoration(
                                          hintText: "Year",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.redAccent),
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
                                        onSaved: (String value) {
                                          yearint = year.text;
                                        },
                                        controller: year,
                                      ),
                                    )),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: GestureDetector(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: "Month",
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.redAccent),
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
                                      onSaved: (String value) {
                                        monthstr = month.text;
                                      },
                                      controller: month,
                                    ),
                                    onDoubleTap: () => _showDialog(
                                        "This represents your mobile number (EG: 09123456789)",
                                        "Phone Number"),
                                  ),
                                ),
                                Container(
                                  width: 300,
                                  height: 60,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 20, 0),
                                      child: FlatButton(
                                        onPressed: () {
                                          _validateTextViews();
                                        },
                                        textColor: Colors.white,
                                        hoverColor:
                                            Color.fromRGBO(30, 141, 202, 1),
                                        color: Color.fromRGBO(34, 167, 240, 1),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Text(
                                          "Confirm",
                                          style: TextStyle(
                                              fontFamily: "DefaultFont",
                                              fontSize: 20),
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              (inProcess)
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Center()
            ],
          ),
        ),
      ),
    );
  }
}
