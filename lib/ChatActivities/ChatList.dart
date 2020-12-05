import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/CustomWidgets/ChatUser.dart';

import 'ChatActivity.dart';


class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // Variables
  final GlobalKey<FormState> searchKey = new GlobalKey<FormState>();
  final TextEditingController cont = new TextEditingController();
  String search;
  // Methods
  Future getUsers(String text) async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot qs_noparam = await firestore.collection("UserInfo").orderBy("createdAt", descending: true).get();
    QuerySnapshot qs_wtparam = await firestore.collection("UserInfo").where("usertag", isEqualTo: text).get();
    return text != null ? qs_wtparam.docs : qs_noparam.docs;
  }

  void valid() {
    if(searchKey.currentState.validate()) {
      searchKey.currentState.save();
      cont.text = "";
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
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                child: Form(
                  key: searchKey,
                  child: Material(
                    borderRadius: BorderRadius.circular(25.0),
                    elevation: 5,
                    child: TextFormField(
                      controller: cont,
                      decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 10.0),
                          hintText: "Search",
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: GestureDetector(
                            child: Icon(Icons.send),
                            onTap: () {
                              valid();
                            },
                          )
                      ),

                      onSaved: (value) {
                        setState(() {
                            search = cont.text;
                        });
                      },
                    ),
                  ),
                ),
              ),

              Container(

                child: FutureBuilder(
                    future: search != null ? getUsers(search) : getUsers(null),
                    builder: (_, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Container(
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : Expanded(
                        child: ListView.builder(
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              child: ChatUser(
                                profile: snapshot.data[index]["profile"],
                                username: snapshot.data[index]["firstName"] +
                                    " " +
                                    snapshot.data[index]["lastName"],
                                tag: "@" + snapshot.data[index]["usertag"],
                                uid: snapshot.data[index]["id"],
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatActivity(userID: snapshot.data[index]["id"],profile: snapshot.data[index]["profile"])));
                              },
                            );
                          },
                          itemCount: snapshot.data.length == null ? 0 : snapshot.data.length,
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
