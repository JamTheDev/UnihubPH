import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  final _firestoreRef = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User u = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder(
              stream: _firestoreRef.collection("UserInfo").doc(u.uid).snapshots(),
              builder: (_, snapshots){
                return Container(
                  child: Image.network(snapshots.data["profile"]),
                );
            },
            )
          ],
        ),
      ),
    );
  }
}
