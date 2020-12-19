import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/AuthActivities/Verification/PhoneVerification.dart';
import 'package:unihub/DartFiles/AuthExceptionHandler.dart';
import 'package:unihub/DartFiles/RegisterInformation.dart';

import '../AuthService.dart';



class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  String mode = "not";
  String id;
  String number;
  TextEditingController num = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void uploadToDb(String uid) async {
    AuthService a = AuthService();
    final status = a.createAccount(email: email, pass: RegisterInformation.password);
    if (status.toString() == AuthResultStatus.successful.toString()) {
      final u = FirebaseAuth.instance.currentUser;
      var snapshot = await _storage
          .ref()
          .child("profilePictures/" + u.uid)
          .putFile(RegisterInformation.image)
          .onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      User user = auth.currentUser;
      user.updateProfile(
          displayName: RegisterInformation.userTag, photoURL: downloadUrl);
      CollectionReference refS =
      FirebaseFirestore.instance.collection("UserInfo");
      CollectionReference ref2 =
      FirebaseFirestore.instance.collection("FollowUsers");
      ref2.doc(user.uid).set({"dummy": "dum"});
      refS.doc(user.uid).set({
        "firstName": RegisterInformation.firstName,
        "lastName": RegisterInformation.lastName,
        "usertag": RegisterInformation.userTag,
        "createdAt": Timestamp.now(),
        "bio": RegisterInformation.bio,
        "city": RegisterInformation.city,
        "province": RegisterInformation.province,
        "month": RegisterInformation.month,
        "id": user.uid,
        "betauser": true,
        "day": RegisterInformation.day,
        "year": RegisterInformation.year,
        "profile": downloadUrl
      }).whenComplete(() {
        setState(() {
          isRegistering = false;
        });
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
        _showDialog(
            "Welcome to the beta-testing of unihub, " +
                RegisterInformation.firstName,
            "Welcome!");
      });
    } else {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(
          status);
      _showDialog(errorMsg, "Error!");
      return;
    }

  }

  String email;
  final TextEditingController controller = new TextEditingController();
  final TextEditingController controller2 = new TextEditingController();
  final GlobalKey<FormState> form = new GlobalKey();
  final GlobalKey<FormState> form2 = new GlobalKey();
  bool isRegistering = false;

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

  void setID(String id1) {
    id1 = id;
  }



  Future<bool> registerAccountUsingPhone(String number, context) async {
    auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 60),
      verificationCompleted: (credentials) async {
        Navigator.of(context).pop();
        UserCredential u = await auth.signInWithCredential(credentials);
        User user = u.user;
      },
      verificationFailed: (exception) {
        print(exception);
      },
      codeSent: (id, [forceResend]) {
        setID(id);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }



  void confirmMobileNumber() async {
    AuthCredential cred = PhoneAuthProvider.credential(
        verificationId: id, smsCode: num.text.trim());
    UserCredential u = await auth.signInWithCredential(cred);
    User user = u.user;
    if (user != null) {
      var snapshot = await _storage
          .ref()
          .child("profilePictures/" + user.uid)
          .putFile(RegisterInformation.image)
          .onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      user.updateProfile(
          displayName: RegisterInformation.userTag,
          photoURL: downloadUrl);
      CollectionReference refS =
      FirebaseFirestore.instance.collection("UserInfo");
      CollectionReference ref2 =
      FirebaseFirestore.instance.collection("FollowUsers");
      ref2.doc(user.uid).set({"dummy": "dum"});
      refS.doc(user.uid).set({
        "firstName": RegisterInformation.firstName,
        "lastName": RegisterInformation.lastName,
        "usertag": RegisterInformation.userTag,
        "createdAt": Timestamp.now(),
        "bio": RegisterInformation.bio,
        "city": RegisterInformation.city,
        "province": RegisterInformation.province,
        "month": RegisterInformation.month,
        "id": user.uid,
        "betauser": true,
        "day": RegisterInformation.day,
        "year": RegisterInformation.year,
        "profile": downloadUrl
      }).whenComplete(() {
        setState(() {
          isRegistering = false;
        });
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", (r) => false);
        _showDialog(
            "Welcome to the beta-testing of unihub, " +
                RegisterInformation.firstName,
            "Welcome!");
      });
    }
  }

  void validateForm() async {
    setState(() {
      isRegistering = true;
    });
    form.currentState.save();
    form2.currentState.save();
    email = email == "" ? null : email;
    number = number == "" ? null : number;
    if (email != null && number != null) {
      _showDialog("Use only 1 way for verification", "Error!");
      setState(() {
        isRegistering = false;
      });
      return;
    }
    if (number != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerifyPhone(num: numberConvert(number),)));
      return;
    }
    AuthService a = new AuthService();
    a.createAccount(email: email, pass: RegisterInformation.password).whenComplete(() {
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser;
      uploadToDb(user.uid);
    });
    setState(() {
      isRegistering = false;
    });
  }


  String numberConvert(String number) {
    List numSep = number.split("");

    if(numSep[0] == "0") {
      numSep[0] = "+63";
    } else {
      return number;
    }
    return numSep.join();
  }
  

  Widget buildEmailAndNumberFields() {
    return Column(
      children: [
        Form(
          key: form,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: TextFormField(
                decoration: InputDecoration(
                  contentPadding:
                  new EdgeInsets.symmetric(vertical: 13.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(34, 167, 240, 1)),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.perm_identity),
                ),
                validator: (String value) {
                  return value.isEmpty
                      ? "This field is required"
                      : null;
                },
                controller: controller,
                onSaved: (String value) {
                  email = controller.text;
                }),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            "OR",
            style: TextStyle(fontFamily: "Sen", color: Colors.white),
          ),
        ),
        Form(
          key: form2,
          child: Container(
            child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding:
                  new EdgeInsets.symmetric(vertical: 13.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Phone Number",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(34, 167, 240, 1)),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.perm_identity),
                ),
                validator: (String value) {
                  return value.isEmpty
                      ? "This field is required"
                      : null;
                },
                controller: controller2,
                onSaved: (String value) {
                  number = controller2.text;
                }),
          ),
        )
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(34, 167, 240, 1),
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Verify your account",
              style: TextStyle(
                  fontFamily: "Sen",
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: Text(
                "Enter your email or phone to use.",
                style: TextStyle(
                    fontFamily: "Sen", fontSize: 20, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
            buildEmailAndNumberFields(),
            (isRegistering)
                ? Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          "Registering your account",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ))
                : Container(),
            Container(
              margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: FlatButton.icon(
                onPressed: () {
                  validateForm();
                },
                icon: Icon(
                  Icons.arrow_right_alt,
                  size: 40.0,
                ),
                label: Text("Proceed"),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
