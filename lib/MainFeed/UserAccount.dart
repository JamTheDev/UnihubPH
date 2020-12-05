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

class UserAccount extends StatefulWidget {
  String image, fullName, userTag, author;

  UserAccount(
      {this.image, this.fullName, this.userTag, this.author});

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
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
                child: Image.network(widget.image, fit: BoxFit.cover),
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
                                      Text(
                                        widget.fullName,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "Sen",
                                            fontSize: 15),
                                      ),
                                      Text(
                                        widget.userTag,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: "Sen",
                                            fontSize: 15),
                                      ),
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

                                                },
                                                child: Text(
                                                 "Follow",
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
                                                      widget.author
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
