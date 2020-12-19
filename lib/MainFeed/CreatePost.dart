import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool isPosting = false;
  Map<String, dynamic> uInfo = {};
  final GlobalKey<FormState> inp = new GlobalKey();
  final TextEditingController textEditingController =
      new TextEditingController();
  String postInfo;
  String name, tag = " ";
  bool isReady = false;
  User user = FirebaseAuth.instance.currentUser;

  void uploadToDatabase() async {
    setState(() {
      isPosting = true;
      isReady = true;
    });
    if (inp.currentState.validate()) {
      inp.currentState.save();
      CollectionReference ref =
          FirebaseFirestore.instance.collection("PostsPath");
      CollectionReference ref2 =
          FirebaseFirestore.instance.collection("PostLikes");
      CollectionReference ref3 =
          FirebaseFirestore.instance.collection("PostComments");
      final _storage = FirebaseStorage.instance;
      var id = FirebaseFirestore.instance.collection("PostsPath").doc().id;
      ref2.doc(id).set({"dummy": "dum"});
      ref.doc(id).collection("others").doc("reports").set({
        "test": "report",
      });
      ref.doc(id).collection("others").doc("hides").set({
        "test": "hidden",
      });
      ref3.doc(id).set({
        id: {
          "caption": null,
          "createdAt": null,
          "author": null,
          "commentID": null,
          "postID": null
        }
      });
      var snapshot;
      if (_selectedFile != null) {
        snapshot = await _storage
            .ref()
            .child("postsImages/" + id)
            .putFile(_selectedFile)
            .onComplete;
      }
      var downloadUrl =
          _selectedFile == null ? null : await snapshot.ref.getDownloadURL();
      ref.doc(id).set({
        "caption": postInfo,
        "images": _selectedFile == null ? null : downloadUrl,
        "time": DateTime.now().microsecondsSinceEpoch,
        "author": user.uid,
        "postID": id,
        "isShared": "false",
        "createdAt": Timestamp.now()
      }).whenComplete(() {
        Fluttertoast.showToast(
          msg: "Post has been posted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
        setState(() {
          isPosting = false;
          isReady = false;
          textEditingController.clear();
          _selectedFile = null;
          Navigator.of(context).pop();
        });
      });
    } else {
      setState(() {
        isPosting = true;
        isReady = true;
      });
    }
  }

  bool inProcess = false;
  File _selectedFile;

  _getImage(ImageSource src) async {
    if (inProcess != true) {
      setState(() {
        inProcess = true;
      });
      File imageFile = await ImagePicker.pickImage(source: src);
      if (imageFile != null) {
        setState(() {
          _selectedFile = imageFile;
          inProcess = false;
        });
      } else {
        setState(() {
          inProcess = false;
        });
      }
    }
  }

  Widget imageWidget() {
    if (_selectedFile != null) {
      return Container(child: Image.file(_selectedFile), margin: EdgeInsets.all(10), decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(5.0) //                 <--- border radius here
        ),
      ),);
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Text(
                "POST",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Sen",
                  color: Colors.black,
                ),
              ),
            ),
            onTap: () {
              uploadToDatabase();
            },
          )
        ],
        title: Text(
          "Post Photo / Status",
          style: TextStyle(
            fontSize: 15,
            fontFamily: "Sen",
            color: Colors.black,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(20),
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                          child: ClipOval(
                            child: Image.network(
                              auth.currentUser.photoURL.toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("UserInfo")
                                  .doc(user.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    "Hang on...",
                                    style: TextStyle(
                                        color: Colors.black, fontFamily: "Sen"),
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
                                           ),
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
                                  .doc(user.uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text(
                                    "Hang on...",
                                    style: TextStyle(
                                        color: Colors.black, fontFamily: "Sen"),
                                  );
                                } else {
                                  return Text(
                                    "@" + snapshot.data["usertag"],
                                    style: TextStyle(
                                        color: Colors.grey, fontFamily: "Sen"),
                                  );
                                }
                              }),
                        ],
                      )
                    ],
                  ),
                  Card(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(children: [
                        Form(
                          key: inp,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 2,
                              decoration: InputDecoration(
                                  hintText: "What are you feeling today?",
                                  border: InputBorder.none),
                              onSaved: (String value) {
                                postInfo = textEditingController.text;
                              },
                              controller: textEditingController,
                            ),
                          ),
                        ),
                        imageWidget(),

                      ])),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image_outlined,
                              color: Colors.black,
                              size: 20,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("Upload an image!",
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: "Sen")),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _getImage(ImageSource.gallery);
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera,
                              color: Colors.black,
                              size: 20,
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Text("Capture an Image!",
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: "Sen")),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      _getImage(ImageSource.camera);
                    },
                  ),
                  Center(
                    child: Image(image: AssetImage("./images/chat.png")),
                  ),
                  Center(
                    child: Container(
                      child: Text("Maintain The Cleanliness!", style: TextStyle(fontFamily: "Sen", fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                  )
                  /*
                  It is better to post only about our country to maintain the focus of Unihub. Avoid anything unpleasant to those who can see your post.
                   */
                ],
              ),
            ),
            (isPosting || inProcess)
                ? Container(
                    color: Colors.white30,
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Center()
          ],
        ),
      ),
    );
  }
}
