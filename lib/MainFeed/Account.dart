import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/CustomWidgets/OwnPosts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:unihub/CustomWidgets/PostShareWidget.dart';
import 'package:unihub/DartFiles/DeleteFile.dart';
import 'package:unihub/SettingsActivities/SettingsOne.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  User u = FirebaseAuth.instance.currentUser;
  bool isEditing = false;
  int a = 0;
  bool inProcess = false;
  double initChildSize = 0.6;
  double maxChildSize = 0.9;
  double minChildSize = 0.6;
  File _selectedFile;
  final firestore = FirebaseFirestore.instance;

  _signOut() async {
    await FirebaseAuth.instance.signOut().whenComplete(
        () => Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false));
  }

  Future<void> _showDialog(String type) async {
    final myController = TextEditingController();
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
            content: Column(
              children: [
                Expanded(
                  child: new TextField(
                    controller: myController2,
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'Edit ' + type + "...",
                        hintText: 'Text here!'),
                  ),
                ),
                type == "username"
                    ? Expanded(
                        child: new TextField(
                          controller: myController,
                          autofocus: true,
                          decoration: new InputDecoration(
                              labelText: "Last name", hintText: 'Text here!'),
                        ),
                      )
                    : Container()
              ],
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
                    if (type == "tag") {
                      firestore
                          .collection("UserInfo")
                          .doc(u.uid)
                          .update({"usertag": myController2.text});
                      u.updateProfile(displayName: myController2.text);
                    } else if (type == "username") {
                      firestore.collection("UserInfo").doc(u.uid).update({
                        "firstName": myController2.text,
                        "lastName": myController.text
                      });
                    }
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Future getOwnPosts() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore
        .collection("PostsPath")
        .orderBy("createdAt", descending: true)
        .get();
    return qs.docs;
  }

  Future _getImage(ImageSource src) async {
    if (inProcess != true) {
      setState(() {
        inProcess = true;
      });
      File imageFile = await ImagePicker.pickImage(source: src);
      if (imageFile != null) {
        File cropped = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 300,
          maxWidth: 300,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: "Pick your Profile Image!",
              toolbarColor: Colors.blue,
              statusBarColor: Colors.blue,
              backgroundColor: Colors.white),
        );

        setState(() {
          _selectedFile = cropped;
          inProcess = false;
        });
      } else {
        setState(() {
          inProcess = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Container(
                child: GestureDetector(
                  child: Image.network(u.photoURL, fit: BoxFit.cover),
                  onTap: () {
                    if (isEditing) {
                      _getImage(ImageSource.gallery).then((value) {
                        setState(() {
                          firestore.collection("UserInfo").doc(u.uid).update({
                            "profile": DeleteFile.url,
                          });
                          DeleteFile(
                                  oldUrl: u.photoURL,
                                  fileName: u.uid,
                                  selectedFile: _selectedFile)
                              .deleteAndUploadNewProfile();
                          String url = DeleteFile.url;
                          u.updateProfile(photoURL: url);
                          u.reload();
                        });
                      });
                    }
                  },
                ),
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                child: DraggableScrollableSheet(
                  initialChildSize: initChildSize,
                  maxChildSize: maxChildSize,
                  minChildSize: minChildSize,
                  builder: (_, controller) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          )),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        child: StreamBuilder(
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
                                                      fontSize: 15),
                                                );
                                              } else {
                                                return Text(
                                                  snapshot.data["firstName"] +
                                                      " " +
                                                      snapshot.data["lastName"],
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Sen",
                                                      fontSize: 15),
                                                );
                                              }
                                              return null;
                                            }),
                                        onTap: () {
                                          if (isEditing) {
                                            _showDialog("username");
                                          }
                                        },
                                      ),
                                      GestureDetector(
                                        child: StreamBuilder(
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
                                                      fontSize: 15),
                                                );
                                              } else {
                                                return Text(
                                                  "@" +
                                                      snapshot.data["usertag"],
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontFamily: "Sen",
                                                      fontSize: 15),
                                                );
                                              }
                                            }),
                                        onTap: () {
                                          if (isEditing) {
                                            _showDialog("tag");
                                          }
                                        },
                                      ),
                                      (isEditing)
                                          ? Text(
                                              "(Click a field to edit it!)",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "Sen",
                                                  fontSize: 13),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        alignment: Alignment.bottomRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            MaterialButton(
                                                elevation: 5,
                                                minWidth: 7,
                                                height: 30,
                                                shape: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(20.0)),
                                                color: Colors.white,
                                                onPressed: () {
                                                  if (isEditing) {
                                                    setState(() {
                                                      isEditing = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isEditing = true;
                                                    });
                                                  }
                                                },
                                                child: Text(
                                                  !isEditing
                                                      ? "Edit Profile"
                                                      : "Editing",
                                                  style: TextStyle(
                                                      fontFamily: "Sen",
                                                      fontSize: 13,
                                                      color: Colors.black),
                                                )),
                                            MaterialButton(
                                                elevation: 5,
                                                minWidth: 7,
                                                height: 30,
                                                shape: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1.0,
                                                        color: Colors.white),
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(20.0)),
                                                color: Colors.white,
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SettingsOne()));
                                                },
                                                child: Text(
                                                  "Settings",
                                                  style: TextStyle(
                                                      fontFamily: "Sen",
                                                      fontSize: 13,
                                                      color: Colors.black),
                                                )),
                                          ],
                                        ))),
                              ],
                            ),
                            Expanded(
                              child: FutureBuilder(
                                builder: (_, snapshot) {
                                  return snapshot.connectionState ==
                                              ConnectionState.waiting &&
                                          a == 0
                                      ? Container()
                                      : ListView.builder(
                                          itemBuilder: (_, index) {
                                            a = 1;
                                            // snapshot.data[index]["isShared"] != "true"
                                            if (snapshot.data[index]
                                                    ["isShared"] ==
                                                "true") {
                                              if (snapshot.data[index]
                                                      ["author"] ==
                                                  u.uid) {
                                                return PostShareWidget(
                                                  sharedUid:
                                                      snapshot.data[index]
                                                          ["sharedPostOwner"],
                                                  sharedPostID:
                                                      snapshot.data[index]
                                                          ["postShared"],
                                                  sharedBy: snapshot.data[index]
                                                      ["author"],
                                                );
                                              } else {
                                                return Container();
                                              }
                                            } else {
                                              return snapshot.data[index]
                                                          ["author"] ==
                                                      u.uid
                                                  ? OwnPostDesign(
                                                      caption:
                                                          snapshot.data[index]
                                                              ["caption"],
                                                      image:
                                                          snapshot.data[index]
                                                              ["images"],
                                                      uid: snapshot.data[index]
                                                          ["author"],
                                                      postID:
                                                          snapshot.data[index]
                                                              ["postID"],
                                                    )
                                                  : Container();
                                            }
                                          },
                                          itemCount: snapshot.data.length,
                                          controller: controller,
                                        );
                                },
                                future: getOwnPosts(),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
