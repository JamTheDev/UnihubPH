import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsOne extends StatefulWidget {
  @override
  _SettingsOneState createState() => _SettingsOneState();
}



class _SettingsOneState extends State<SettingsOne> {
  _signOut() async {
    await FirebaseAuth.instance.signOut().whenComplete(
            () => Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: RaisedButton(
              onPressed: () {
                 _signOut();
              },
            ),
          ),
        ),
      ),
    );
  }
}
