import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatUser extends StatefulWidget {
  String profile, username, tag, uid;

  ChatUser({this.profile, this.username, this.tag, this.uid});

  @override
  _ChatUserState createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  User u = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  child: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        widget.profile,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.username,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Sen",
                            fontSize: 10),
                      ),
                      Text(
                        widget.tag,
                        style: TextStyle(
                            color: Colors.grey,
                            fontFamily: "Sen",
                            fontSize: 10),
                      ),
                    ],
                  ),


                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
