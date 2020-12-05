import 'package:flutter/material.dart';
import 'package:unihub/AuthActivities/Register/RegPart1.dart';

class WelcomeP1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 167, 240, 1),
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Unihub",
              style: TextStyle(
                  fontFamily: "Sen",
                  fontSize: 50,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: Text(
                "Let's get you started!",
                style: TextStyle(
                    fontFamily: "Sen", fontSize: 20, color: Colors.white),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
              child: FlatButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserInfo1()));
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
