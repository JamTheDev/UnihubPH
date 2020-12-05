import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/CustomWidgets/ReadMoreText.dart';
import 'package:unihub/MainFeed/CommentSection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unihub/MainFeed/UserAccount.dart';

class PostDesign extends StatefulWidget {
  final User u = FirebaseAuth.instance.currentUser;
  String caption, uid, image, postID, time, sharedPost;
  int len;

  PostDesign(
      {this.caption,
      this.uid,
      this.image,
      this.postID,
      this.time,
      this.sharedPost});

  @override
  _PostDesignState createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
  User u = FirebaseAuth.instance.currentUser;
  CollectionReference postsRef;
  Map<String, dynamic> data;
  QuerySnapshot collectionState;
  final firestore = FirebaseFirestore.instance;
  Future getUser() async {

    QuerySnapshot qs = await firestore
        .collection("UserInfo")
        .orderBy("createdAt", descending: false)
        .get();
    return qs.docs;
  }

  Future getPosts() async {

    QuerySnapshot qs = await firestore.collection("PostLikes").get();
    return qs.docs;
  }

  String keyA;

  void sharePost() {
    var id = FirebaseFirestore.instance.collection("PostsPath").doc().id;
    firestore.collection("PostsPath").doc(id).set({
      "id": id,
      "isShared": "true",
      "author": u.uid,
      "postShared": widget.postID,
      "sharedPostOwner": widget.uid,
      "createdAt": Timestamp.now()
    }).whenComplete(() {
      Fluttertoast.showToast(
        msg: "Post Shared!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    });
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
                ? TextSpan(
                    text: text,
                    style: TextStyle(
                        fontFamily: "Sen",
                        fontSize: 13,
                        color: text.contains("#")
                            ? Color.fromRGBO(34, 167, 240, 1)
                            : Colors.black))
                : TextSpan(
                    text: text,
                    style: TextStyle(
                        fontFamily: "Sen", fontSize: 13, color: Colors.black)))
            .toList()),
      ),
    );
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
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: StreamBuilder(
        stream: postsRef.snapshots(),
        builder: (_, snapshots) {
          if (!snapshots.hasData) {
            return Shimmer.fromColors(child: Container(height: 20,), baseColor: Colors.grey[200], highlightColor: Colors.grey[350]);
          } else {
            return Column(children: [
              Container(
                child: Row(
                  children: [
                    StreamBuilder(
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return CircleAvatar(
                            child: Shimmer.fromColors(
                                baseColor: Colors.white30,
                                highlightColor: Colors.white24,
                                child: ClipOval(child: Container())),
                          );
                        } else {
                          return GestureDetector(
                            child: CircleAvatar(
                              child: ClipOval(
                                child: Image.network(
                                  snapshot.data["profile"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserAccount(image: widget.image, author: widget.uid, fullName: snapshot.data["firstName"] + " " + snapshot.data["lastName"], userTag: snapshot.data["userTag"],)));
                            },
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
                                  return Shimmer.fromColors(
                                    baseColor: Colors.white30,
                                    highlightColor: Colors.white24,
                                    child: Text(
                                      "Hang on...",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Sen",
                                          fontSize: 10),
                                    ),
                                  );
                                } else {
                                  return Row(
                                    children: [
                                  Text(
                                  snapshot.data["firstName"] +
                                  " " +
                                  snapshot.data["lastName"],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "Sen",
                                        fontSize: 10),
                                  ),
                                      snapshot.data["verified"] == "true" ? Container(margin: EdgeInsets.fromLTRB(3, 0,0,0),child: Icon(Icons.verified, color: Color.fromRGBO(34, 167, 240, 1), size: 15,),) : Container()

                                    ],
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
                                    .doc(widget.uid)
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
                                                      .doc(widget.uid)
                                                      .get();
                                              snap.then((value) {
                                                if (!value
                                                    .data()
                                                    .containsKey(u.uid)) {
                                                  FirebaseFirestore.instance
                                                      .collection("FollowUsers")
                                                      .doc(widget.uid)
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
                                widget.sharedPost != "true"
                                    ? Container(
                                        alignment: Alignment.bottomRight,
                                        margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                        child: GestureDetector(
                                          child: Icon(Icons.delete),
                                          onTap: () {
                                            if(widget.sharedPost != "true"){
                                              firestore.collection("PostsPath").doc(widget.postID).delete().then((value) async {
                                                StorageReference photoRef = FirebaseStorage.instance
                                                    .ref().child("profilePictures/" + widget.image);
                                                await photoRef.delete().whenComplete(() => _showDialog("Your post has been deleted!", "Success!"));
                                              });
                                            }
                                          }
                                        ),
                                      )
                                    : Container()
                              ],
                            ))),
                  ],
                ),
              ),
              Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        widget.image != null
                            ? Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 2),
                                child: ReadMoreText(
                                  widget.caption,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Sen",
                                      fontSize: 13),
                                  colorClickableText: Color.fromRGBO(34, 167, 240, 1),
                                  trimExpandedText: " Collapse",
                                  trimCollapsedText: "...Show more",
                                  trimLength: 110,
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    child: ReadMoreText(
                                      widget.caption,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Sen",
                                          fontSize: 13),
                                      trimLength: 110,
                                      colorClickableText: Color.fromRGBO(34, 167, 240, 1),
                                      trimExpandedText: " collapse",

                                    ),
                                    )
                                  ),
                                ),


/*

 */
                       Container(
                         child: widget.image != null
                             ? Container(
                           padding: widget.image == null
                               ? EdgeInsets.fromLTRB(0, 5, 0, 0)
                               : EdgeInsets.fromLTRB(0, 5, 0, 20),
                           margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                           alignment: Alignment.center,
                           child: ClipRRect(
                             borderRadius: BorderRadius.circular(15.0),
                             child: widget.image == null ? Shimmer.fromColors(child: SizedBox(
                               height: 50,
                               child: Container(
                                 color: Colors.grey,
                               ),
                             ), baseColor: null, highlightColor: null) : Image.network(
                               widget.image,
                               fit: BoxFit.cover,
                             ),
                           ),
                         )
                             : Center(
                           child: Container(
                             padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                           ),
                         ),
                       )

                      ],
                    ),
                    Positioned(
                      bottom: widget.image != null ? -7 : 15,
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
                        bottom: widget.image != null ? -7 : 15,
                        left: 75,
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
                        )),
                    widget.sharedPost != "true"
                        ? Positioned(
                        bottom: widget.image != null ? -7 : 15,
                            left: 130,
                            child: MaterialButton(
                              minWidth: 8,
                              height: 25,
                              color: Colors.white,
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      width: 1.0,
                                      color: Colors.white),
                                  borderRadius:
                                      new BorderRadius.circular(20.0)),
                              onPressed: () {
                                sharePost();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.reply,
                                    size: 15,
                                  )
                                ],
                              ),
                            ))
                        : Container()
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
