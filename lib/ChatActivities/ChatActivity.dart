import 'package:flutter/material.dart';
import 'package:unihub/CustomWidgets/ChatBox.dart';

class ChatActivity extends StatefulWidget {
  String userID, profile;
  ChatActivity({this.userID, this.profile});
  @override
  _ChatActivityState createState() => _ChatActivityState();
}

class _ChatActivityState extends State<ChatActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          color: Colors.red,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              ListView.builder(itemBuilder: (_, index){
                return Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            widget.profile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ChatBox()
                    ],
                  ),
                );
              },
                itemCount: 1,
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
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "Comment on this post!",
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: GestureDetector(
                                child: Icon(Icons.send),
                                onTap: () {
                                },
                              )),
                          onSaved: (val) {

                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
