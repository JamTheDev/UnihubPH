import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/ChatActivities/ChatList.dart';
import 'package:unihub/CustomWidgets/PostDesignWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/CustomWidgets/PostShareWidget.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User u = FirebaseAuth.instance.currentUser;
  ScrollController controller;
  DocumentSnapshot _lastVisible;
  bool _isLoading;
  List<DocumentSnapshot> _data = new List<DocumentSnapshot>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future getPosts() async {
    QuerySnapshot data;
    final firestore = FirebaseFirestore.instance;
    if (_lastVisible == null) {
      data = await firestore
          .collection("PostsPath")
          .orderBy("createdAt", descending: true)
          .limit(15)
          .get();
    } else {
      data = await firestore
          .collection("PostsPath")
          .orderBy("createdAt", descending: true)
          .startAfter([_lastVisible["createdAt"]])
          .limit(10)
          .get();
    }

    if (data != null && data.docs.length > 0) {
      _lastVisible = data.docs[data.docs.length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(data.docs);
        });
      }
    } else {
      setState(() => _isLoading = false);
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('No more posts!'),
        ),
      );
    }
    return null;
  }

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
    _isLoading = true;
    getPosts();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        getPosts();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "send",
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatList()));
        },
        child: Icon(
          Icons.send,
          color: Colors.black,
          size: 30,
        ),
      ),

      key: scaffoldKey,
      body: SafeArea(
        child: Container(
          child: RefreshIndicator(
            onRefresh: () async {
              _data.clear();
              _lastVisible = null;
              await getPosts();
            },
            child: ListView.builder(
              controller: controller,
              itemCount: _data.length + 1,
              itemBuilder: (_, index) {
                if (index < _data.length) {
                  if (_data.length == 0) {
                    return Container(
                      child: Expanded(
                        child: Container(
                          child: Center(
                            child: Text("follow people dumbass"),
                          ),
                        ),
                      ),
                    );
                  }
                  final DocumentSnapshot document = _data[index];
                  return document["author"] != u.uid
                      ? StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("FollowUsers")
                              .doc(document["author"])
                              .snapshots(),
                          builder: (_, snapshots) {
                            if (!snapshots.hasData) {
                              return Container();
                            } else {
                              if (snapshots.data.data().containsKey(u.uid)) {
                                return document["isShared"] == "false"
                                    ? PostDesign(
                                        caption: document["caption"],
                                        image: document["images"],
                                        uid: document["author"],
                                        postID: document["postID"],
                                        sharedPost: "false",
                                      )
                                    : PostShareWidget(
                                        sharedUid: document["sharedPostOwner"],
                                        sharedPostID: document["postShared"],
                                        sharedBy: document["author"],
                                      );
                              } else {
                                return Container();
                              }
                            }
                          })
                      : document["isShared"] == "false"
                          ? PostDesign(
                              caption: document["caption"],
                              image: document["images"],
                              uid: document["author"],
                              postID: document["postID"],
                              sharedPost: "false",
                            )
                          : PostShareWidget(
                              sharedUid: document["sharedPostOwner"],
                              sharedPostID: document["postShared"],
                              sharedBy: document["author"],
                            );
                } else {
                  return Shimmer.fromColors(
                      child: Container(
                        height: 20,
                      ),
                      baseColor: Colors.grey[200],
                      highlightColor: Colors.grey[350]);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
