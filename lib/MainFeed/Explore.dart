import 'package:flutter/material.dart';
import 'package:unihub/CustomWidgets/UserDisplayWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  String search;
  final GlobalKey<FormState> searchKey = GlobalKey();
  final TextEditingController cont = new TextEditingController();
  Future getUsers(String text) async {
    print(text);
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

  CollectionReference ref = FirebaseFirestore.instance.collection("UserInfo");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      child: GestureDetector(
                        child: Text(
                          "Users",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 20,
                              fontWeight: currentTab == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: Colors.black),
                        ),
                        onTap: () {
                          currentTab = 0;
                        },
                      ),
                    )
                  ],
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
                                  return UserDisplay(
                                    profile: snapshot.data[index]["profile"],
                                    username: snapshot.data[index]["firstName"] +
                                        " " +
                                        snapshot.data[index]["lastName"],
                                    tag: "@" + snapshot.data[index]["usertag"],
                                    uid: snapshot.data[index]["id"],
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
