import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/CustomWidgets/ReadMoreText.dart';
import 'package:unihub/MainFeed/CommentSection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  CollectionReference ref =
  FirebaseFirestore.instance.collection("PostsPath");
  bool isDeleting = false;
  Future<void> _editPost() async {
    final myController2 = TextEditingController();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Change Info",
              style: TextStyle(fontFamily: "Sen"),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  Expanded(
                    child: new TextField(
                      controller: myController2,
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Edit ',
                          hintText: 'Text here!'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Submit!'),
                  onPressed: () {
                      firestore
                          .collection("PostsPath")
                          .doc(widget.postID)
                          .update({"caption": myController2.text}).whenComplete(() =>   Navigator.pop(context));

                  })
            ],
          );
        });
  }
  Future openDialog() {
    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text("Post Menu", style: TextStyle(fontFamily: "Sen")),
            content: Container(
              height: MediaQuery.of(context).size.height / 2.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.uid == u.uid ? Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _editPost();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.create),
                          Container(
                            child: Text(
                              "Edit Post",
                              style: TextStyle(fontFamily: "Sen"),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ) : Container(),
                  widget.uid == u.uid ? Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          isDeleting = true;
                        });
                        if (widget.sharedPost != "true") {
                          firestore
                              .collection("PostsPath")
                              .doc(widget.postID)
                              .delete();
                          if(widget.image != null) {
                            StorageReference photoRef = FirebaseStorage.instance
                                .ref()
                                .child("profilePictures/" + widget.image);

                            photoRef.delete().whenComplete(() {
                              Navigator.of(context).pop();
                              _showDialog(
                                  "Your post has been deleted!", "Success!");
                            });
                          }
                          setState(() {
                            isDeleting = false;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          Container(
                            child: Text(
                              "Delete Post",
                              style: TextStyle(fontFamily: "Sen"),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ) : Container(),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.insights),
                          Container(
                            child: Text(
                              "Support",
                              style: TextStyle(fontFamily: "Sen"),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ref.doc(widget.postID).collection("others").doc("reports").set({
                          u.uid: "report",
                        }, SetOptions(merge: true));
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.error),
                          Container(
                            child: Text(
                              "Report Post",
                              style: TextStyle(fontFamily: "Sen"),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.bookmark_border),
                          Container(
                            child: Text(
                              "Save Post",
                              style: TextStyle(fontFamily: "Sen"),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        ref.doc(widget.postID).collection("others").doc("hides").set({
                          u.uid: "hide",
                        }, SetOptions(merge: true)).whenComplete(() => print("done"));
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.indeterminate_check_box),
                          Container(
                            child: Text(
                              "Hide Post",
                              style: TextStyle(fontFamily: "Sen"),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.arrow_downward),
                          Container(
                            child: Text(
                              "Downvote Post",
                              style: TextStyle(fontFamily: "Sen"),
                            ),
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("EXIT"))
            ],
          );
        });
  }

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
            return Shimmer.fromColors(
                child: Container(
                  height: 20,
                ),
                baseColor: Colors.grey[200],
                highlightColor: Colors.grey[350]);
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
                                      builder: (context) => UserAccount(
                                            image: widget.image,
                                            author: widget.uid,
                                            fullName:
                                                snapshot.data["firstName"] +
                                                    " " +
                                                    snapshot.data["lastName"],
                                            userTag: snapshot.data["userTag"],
                                          )));
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
                                      snapshot.data["verified"] == "true"
                                          ? Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  3, 0, 0, 0),
                                              child: Icon(
                                                Icons.verified,
                                                color: Color.fromRGBO(
                                                    34, 167, 240, 1),
                                                size: 15,
                                              ),
                                            )
                                          : Container()
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
                                                stream: FirebaseFirestore
                                                    .instance
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
                                                            color:
                                                                Colors.black),
                                                      );
                                                    } else {
                                                      return Text(
                                                        "Follow",
                                                        style: TextStyle(
                                                            fontFamily: "Sen",
                                                            fontSize: 10,
                                                            color:
                                                                Colors.black),
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
                                      onTap: () {
                                        openDialog();
                                      }),
                                )
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
                                  colorClickableText:
                                      Color.fromRGBO(34, 167, 240, 1),
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
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: ReadMoreText(
                                        widget.caption,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Sen",
                                            fontSize: 13),
                                        trimLength: 110,
                                        colorClickableText:
                                            Color.fromRGBO(34, 167, 240, 1),
                                        trimExpandedText: " collapse",
                                      ),
                                    )),
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
                                    child: CachedNetworkImage(
                                      imageUrl: widget.image,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey[200],
                                        highlightColor: Colors.grey[400],
                                        child: Container(
                                          child: Image(
                                            image: AssetImage(
                                                "./images/placeh.jpg"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
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
                        : Container(),

                      (isDeleting)
                        ? Container(
                      color: Colors.white30,
                      height: MediaQuery.of(context).size.height * 0.95,
                      child: Center(child: CircularProgressIndicator()),
                    )
                        : Center()
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
