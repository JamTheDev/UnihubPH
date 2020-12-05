import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/DartFiles/RegisterInformation.dart';

class VerifyPhone extends StatefulWidget {
  String num;
  VerifyPhone({this.num});
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final TextEditingController controller = new TextEditingController();
  final TextEditingController controller2 = new TextEditingController();
  String _id;
  bool isRegistering;
 
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



  void verify(String id) async {
    AuthCredential cred = PhoneAuthProvider.credential(verificationId: id, smsCode: controller.text.trim());
    UserCredential u = await auth.signInWithCredential(cred).catchError((onError) {
      setState(() {
        isRegistering = false;
      });
      _showDialog(onError, "Error!");
    });
    User user = u.user;
    if (user != null) {
      var snapshot = await _storage
          .ref()
          .child("profilePictures/" + user.uid)
          .putFile(RegisterInformation.image)
          .onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      user.updateProfile(displayName: RegisterInformation.userTag, photoURL: downloadUrl);
      CollectionReference refS = FirebaseFirestore.instance.collection("UserInfo");
      CollectionReference ref2 = FirebaseFirestore.instance.collection("FollowUsers");
      ref2.doc(user.uid).set({
        "dummy": "dum"
      });
      refS.doc(user.uid).set({"firstName": RegisterInformation.firstName,
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
        "profile": downloadUrl}).whenComplete(() {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
        _showDialog("Welcome to the beta-testing of unihub, " + RegisterInformation.firstName, "Welcome!");
      });
    }
    setState(() {
      isRegistering = false;
    });
  }



  Future<bool> registerAccountUsingPhone(String number, context) async {
    auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 60),
      verificationCompleted: (credentials) async {
        Navigator.of(context).pop();
        UserCredential u = await auth.signInWithCredential(credentials);
      },
      verificationFailed: (exception) {
        print(exception);
      },
      codeSent: (id, [forceResend]) {
        print(id + " <- id lol");
        _id = id;
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

 

  @override
  Widget build(BuildContext context) {
    registerAccountUsingPhone(widget.num, context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromRGBO(34, 167, 240, 1),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verify Phone Number",
                style: TextStyle(
                    fontFamily: "Sen",
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Text(
                  "Enter the code recieved down below",
                  style: TextStyle(
                      fontFamily: "Sen", fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
               Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                      decoration: InputDecoration(
                        contentPadding:
                        new EdgeInsets.symmetric(vertical: 13.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Code here",
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
                      controller: controller,
                ),
               ),
              (isRegistering)
                  ? Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircularProgressIndicator(),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "Registering your account",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ))
                  : Container(),
              (!isRegistering) ? Container(
                margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: FlatButton.icon(
                  onPressed: () {
                    setState(() {
                      isRegistering = true;
                    });
                    verify(_id);
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
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }
}
