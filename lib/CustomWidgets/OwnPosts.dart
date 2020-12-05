import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/MainFeed/CommentSection.dart';

class OwnPostDesign extends StatefulWidget {
  final User u = FirebaseAuth.instance.currentUser;
  String caption, uid, image, postID, time;
  int len;

  OwnPostDesign({this.caption, this.uid, this.image, this.postID, this.time});

  @override
  _OwnPostDesignState createState() => _OwnPostDesignState();
}

class _OwnPostDesignState extends State<OwnPostDesign> {
  User u = FirebaseAuth.instance.currentUser;
  DocumentReference ref;
  CollectionReference postsRef;
  Map<String, dynamic> data;

  Future getUser() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore
        .collection("UserInfo")
        .orderBy("createdAt", descending: false)
        .get();
    return qs.docs;
  }

  Future getPosts() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore.collection("PostLikes").get();
    return qs.docs;
  }

  String keyA;

  Future getLikes() async {
    return FirebaseFirestore.instance
        .collection("PostLikes")
        .doc(widget.postID)
        .get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postsRef = FirebaseFirestore.instance.collection("PostsPath");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: StreamBuilder(
        stream: postsRef.snapshots(),
        builder: (_, snapshots) {
          if (!snapshots.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(children: [
              Row(
                children: [
                  CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        u.photoURL,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("UserInfo")
                                .doc(u.uid)
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
                                      fontSize: 10),
                                );
                              }
                              return null;
                            }),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("UserInfo")
                                .doc(u.uid)
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
                                  "@" + snapshot.data["usertag"],
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Sen",
                                      fontSize: 10),
                                );
                              }
                            }),
                        Row(
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("FollowUsers")
                                  .doc(u.uid)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("0 followers",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "Sen",
                                          fontSize: 10));
                                } else {
                                  int likes = snapshot.data.data().length;
                                  int l = likes - 1;
                                  return Text(l.toString() + " followers",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "Sen",
                                          fontSize: 10));
                                }
                              },
                            ),
                            Container(
                              child: Text(" | ",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Sen",
                                      fontSize: 10)),
                            ),
                            Container(
                              child: Text("Level 0",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: "Sen",
                                      fontSize: 10)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              widget.uid == u.uid
                                  ? Container()
                                  : Container(
                                      alignment: Alignment.bottomRight,
                                      child: MaterialButton(
                                          elevation: 5,
                                          minWidth: 7,
                                          height: 20,
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  style: BorderStyle.solid,
                                                  width: 1.0,
                                                  color: Colors.white),
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                          color: Colors.white,
                                          onPressed: () {
                                            Future<DocumentSnapshot> snap =
                                                FirebaseFirestore.instance
                                                    .collection("FollowUsers")
                                                    .doc(u.uid)
                                                    .get();
                                            snap.then((value) {
                                              if (!value
                                                  .data()
                                                  .containsKey(u.uid)) {
                                                FirebaseFirestore.instance
                                                    .collection("FollowUsers")
                                                    .doc(u.uid)
                                                    .set({
                                                  u.uid: "follow"
                                                }, SetOptions(merge: true));
                                              } else {
                                                FirebaseFirestore.instance
                                                    .collection("FollowUsers")
                                                    .doc(widget.uid)
                                                    .update({
                                                  u.uid: FieldValue.delete()
                                                });
                                              }
                                            });
                                          },
                                          child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection("FollowUsers")
                                                  .doc(widget.uid)
                                                  .snapshots(),
                                              builder: (_, snapshot) {
                                                if (snapshot.hasData) {
                                                  if (snapshot.data
                                                      .data()
                                                      .containsKey(u.uid)) {
                                                    return Text(
                                                      "Following",
                                                      style: TextStyle(
                                                          fontFamily: "Sen",
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                    );
                                                  } else {
                                                    return Text(
                                                      "Follow",
                                                      style: TextStyle(
                                                          fontFamily: "Sen",
                                                          fontSize: 10,
                                                          color: Colors.black),
                                                    );
                                                  }
                                                } else {
                                                  return Text(
                                                    "Follow",
                                                    style: TextStyle(
                                                        fontFamily: "Sen",
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  );
                                                }
                                              })),
                                    ),
                              Container(
                                alignment: Alignment.bottomRight,
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: GestureDetector(
                                  child: Icon(Icons.more_horiz),
                                ),
                              ),
                            ],
                          ))),
                ],
              ),
              widget.image != null
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text(widget.caption,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Sen",
                              fontSize: 13)),
                    )
                  : Card(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(10),
                        child: Text(widget.caption,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Sen",
                                fontSize: 13)),
                      ),
                    ),
              Container(
                child: Stack(
                  children: [
                    widget.image != null
                        ? Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 20),
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                widget.image == null ? null : widget.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            ),
                          ),
                    Positioned(
                      bottom: -3,
                      left: 10,
                      child: MaterialButton(
                        minWidth: 8,
                        height: 25,
                        color: Colors.white,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.solid,
                                width: 1.0,
                                color: Colors.white),
                            borderRadius: new BorderRadius.circular(20.0)),
                        onPressed: () {
                          setState(() {
                            Future<DocumentSnapshot> snap = FirebaseFirestore
                                .instance
                                .collection("PostLikes")
                                .doc(widget.postID)
                                .get();
                            final FirebaseFirestore firestore =
                                FirebaseFirestore.instance;
                            snap.then((value) {
                              if (!value.data().containsKey(u.uid)) {
                                firestore
                                    .collection("PostLikes")
                                    .doc(widget.postID)
                                    .set({u.uid: "liked"},
                                        SetOptions(merge: true));
                              } else {
                                firestore
                                    .collection("PostLikes")
                                    .doc(widget.postID)
                                    .update({u.uid: FieldValue.delete()});
                              }
                            });
                          });
                        },
                        child: Row(
                          children: [
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("PostLikes")
                                  .doc(widget.postID)
                                  .snapshots(),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data.data().containsKey(u.uid)) {
                                    return Image.asset(
                                      "images/like.png",
                                      color: Color.fromRGBO(34, 167, 240, 1),
                                      height: 15,
                                      width: 15,
                                    );
                                    return Icon(
                                      Icons.favorite,
                                      color: Colors.redAccent,
                                    );
                                  } else {
                                    return Image.asset(
                                      "./images/like.png",
                                      color: Colors.black,
                                      height: 15,
                                      width: 15,
                                    );
                                  }
                                } else {
                                  return Image.asset(
                                    "images/like.png",
                                    color: Colors.black,
                                    height: 15,
                                    width: 15,
                                  );
                                }
                              },
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("PostLikes")
                                    .doc(widget.postID)
                                    .snapshots(),
                                builder: (_, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text("0");
                                  } else {
                                    int likes = snapshot.data.data().length - 1;
                                    return Text(likes.toString());
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -3,
                        left: 80,
                        child: MaterialButton(
                          minWidth: 8,
                          height: 25,
                          color: Colors.white,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                  color: Colors.white),
                              borderRadius: new BorderRadius.circular(20.0)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CommentSection(
                                          postID: widget.postID,
                                          author: widget.uid,
                                        )));
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.maps_ugc,
                                size: 15,
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              )
            ]);
          }
        },
      ),
    );
  }
}
