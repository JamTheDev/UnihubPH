import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/CustomWidgets/PostDesignWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';


class PostShareWidget extends StatefulWidget {
  String sharedBy, sharedUid, sharedPostID;

  PostShareWidget({this.sharedBy, this.sharedUid, this.sharedPostID});

  @override
  _PostShareWidgetState createState() => _PostShareWidgetState();
}

class _PostShareWidgetState extends State<PostShareWidget> {
  bool isDeleting = false;
  User u = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
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
  Future openDialog() {
    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text("Post Settings"),
            content: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.sharedBy == u.uid ? Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isDeleting = true;
                        });
                        firestore
                            .collection("PostsPath")
                            .doc(widget.sharedPostID)
                            .delete();
                            Navigator.of(context).pop();
                            _showDialog(
                                "Your post has been deleted!", "Success!");
                        setState(() {
                          isDeleting = false;
                        });
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
                      onTap: () {
                        /*
                      if(widget.sharedPost != "true"){
                                              firestore.collection("PostsPath").doc(widget.postID).delete().then((value) async {
                                                StorageReference photoRef = FirebaseStorage.instance
                                                    .ref().child("profilePictures/" + widget.image);
                                                await photoRef.delete().whenComplete(() => _showDialog("Your post has been deleted!", "Success!"));
                                              });
                                            }
                       */
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
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.create),
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
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(Icons.create),
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
  Future getPosts() async {
    QuerySnapshot qs = await firestore
        .collection("PostsPath")
        .orderBy("createdAt", descending: true)
        .get();
    return qs.docs;
  }



  Future<bool> checkIfDocExists(String docId) async {
    try {
      var collectionRef = FirebaseFirestore.instance.collection('collectionName');
      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
             Column(
               children: [
                 StreamBuilder(
                   builder: (_, snapshot) {
                     if (!snapshot.hasData) {
                       return CircleAvatar(
                         child: Shimmer.fromColors(
                             baseColor: Colors.white30,
                             highlightColor: Colors.white24,
                             child: ClipOval(child: Container())
                         ),
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
                       .doc(widget.sharedBy)
                       .snapshots(),
                 ),

               ],
             ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("UserInfo")
                                .doc(widget.sharedBy)
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
                                    Text(
                                      " shared a post",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "Sen",
                                          fontSize: 10),
                                    ),
                                    snapshot.data["verified"] == "true" ? Container(margin: EdgeInsets.fromLTRB(3, 0,0,0),child: Icon(Icons.verified, color: Color.fromRGBO(34, 167, 240, 1), size: 15,),) : Container()
                                  ],
                                );
                              }
                              return null;
                            }),

                      ],
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("UserInfo")
                            .doc(widget.sharedBy)
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
                              .doc(widget.sharedBy)
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
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: GestureDetector(
                    child: Icon(Icons.more_horiz),
                    onTap: () {
                      openDialog();
                    },
                  ),
                ),
              )
            ],
          ),


          StreamBuilder(
            stream: firestore
                .collection("PostsPath")
                .doc(widget.sharedPostID)
                .snapshots(),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                return PostDesign(
                  caption: snapshot.data.data()["caption"],
                  image: snapshot.data.data()["images"],
                  uid: snapshot.data.data()["author"],
                  postID: snapshot.data.data()["postID"],
                  sharedPost: "true",
                );
              }
            },
          )

        ],
      ),
    );
  }
}
