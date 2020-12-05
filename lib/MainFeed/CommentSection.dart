import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/CustomWidgets/CommentWidget.dart';

class CommentSection extends StatefulWidget {
  String postID, author;
  CommentSection({this.postID, this.author});
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final GlobalKey<FormState> keyForm = new GlobalKey();
  final TextEditingController cont = new TextEditingController();
  final ref = FirebaseFirestore.instance;
  User u = FirebaseAuth.instance.currentUser;
  bool uploading = false;
  String comment;

  Future<void> _showDialog(String text, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title, style: TextStyle(fontFamily: "Sen"),),
            content: Text(text, style: TextStyle(fontFamily: "Sen")),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok", style: TextStyle(fontFamily: "Sen")))
            ],
          );
        });
  }

  Future getComments() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot qs = await firestore
        .collection("PostComments/"+widget.postID.toString())
        .get();
    return qs.docs;
  }


  void uploadToDatabase() {
    setState(() {
      uploading = true;
    });
   if(keyForm.currentState.validate()){
     keyForm.currentState.save();
     var id = ref.collection("PostComments").doc().id;
     print(widget.postID);
     cont.text = "";
     ref.collection("PostComments").doc(widget.postID.toString()).set({
       id: {
         "caption": comment,
         "createdAt": Timestamp.now(),
         "author": u.uid,
         "commentID": id,
         "postID": widget.postID
       }
     }, SetOptions(merge: true)).whenComplete(() {
       setState(() {
         uploading = false;
       });
     }).catchError((onError) {
       setState(() {
         uploading = false;
       });
       _showDialog(onError.toString(), "Error!");
     });
     setState(() {
       uploading = false;
     });
   }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder(builder: (_, snapshot) {
                  if(!snapshot.hasData) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return ListView.builder(itemBuilder: (_, index) {
                      List<String> ids = [];
                      ids.clear();
                      for(var keys in snapshot.data.data().keys){
                        ids.add(keys);
                      }
                      return snapshot.data.data()[ids[index].toString()]["caption"] == null ? Container() : CommendWidget(uid: snapshot.data.data()[ids[index].toString()]["author"], postID: widget.postID, postCaption: snapshot.data.data()[ids[index].toString()]["caption"]);
                    }, itemCount: snapshot.data.data().length,);
                  }
                  },
                    stream: FirebaseFirestore.instance
                        .collection("PostComments").doc(widget.postID).snapshots(),
                  ),
                ),
                Container(
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        borderRadius: BorderRadius.circular(25.0),
                        elevation: 5,
                        child: Form(
                          key: keyForm,
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: "Comment on this post!",
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                prefixIcon: Icon(Icons.maps_ugc_outlined),
                                suffixIcon: GestureDetector(
                                  child: Icon(Icons.send),
                                  onTap: () {
                                    uploadToDatabase();
                                  },
                                )),
                            onSaved: (val) {
                              comment = cont.text;
                            },
                            controller: cont,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),


              (uploading) ? Container(
              color: Colors.white24,
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
