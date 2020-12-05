import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommendWidget extends StatefulWidget {
  String uid, postID, postCaption;
  CommendWidget({this.uid, this.postID, this.postCaption});
  @override
  _CommendWidgetState createState() => _CommendWidgetState();
}

class _CommendWidgetState extends State<CommendWidget> {
  Future getUser() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore.collection("UserInfo").orderBy("createdAt", descending: false).get();
    return qs.docs;
  }

  RichText _convertHashtag(String text) {
    List<String> split = text.split(RegExp("#"));
    List<String> hashtags = split.getRange(1, split.length).fold([], (t, e) {
      var texts = e.split(" ");
      if (texts.length > 1) {
        return List.from(t)
          ..addAll(["#${texts.first}", "${e.substring(texts.first.length)}"]);
      }
      return List.from(t)..add("#${texts.first}");
    });
    return RichText(
      text: TextSpan(
        children: [TextSpan(text: split.first)]..addAll(hashtags
            .map((text) => text.contains("#")
            ? TextSpan(text: text, style: TextStyle(
            fontFamily: "Sen", fontSize: 13, color: Color.fromRGBO(34, 167, 240, 1)))
            : TextSpan(text: text))
            .toList()),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          children: [
            Row(
              children: [
                StreamBuilder(
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return CircleAvatar(
                        child: ClipOval(child: Icon(Icons.face)),
                      );
                    } else {
                      return CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            snapshot.data["profile"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                  stream: FirebaseFirestore.instance
                      .collection("UserInfo")
                      .doc(widget.uid)
                      .snapshots(),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("UserInfo")
                              .doc(widget.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text(
                                "Hang on...",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Sen",
                                    fontSize: 10),
                              );
                            } else {
                              return Text(
                                snapshot.data["firstName"] +
                                    " " +
                                    snapshot.data["lastName"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Sen",
                                    fontSize: 12),
                              );
                            }
                            return null;
                          }),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("UserInfo")
                              .doc(widget.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text(
                                "Hang on...",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Sen",
                                    fontSize: 12),
                              );
                            } else {
                              return Text(
                                "@" + snapshot.data["usertag"],
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Sen",
                                    fontSize: 12),
                              );
                            }
                          }),

                    ],
                  ),
                ),
              ],
            ),

            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    padding: EdgeInsets.all(5),
                    child: Text(widget.postCaption,
                        style: TextStyle(
                            color: Colors.black, fontFamily: "Sen", fontSize: 13)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
