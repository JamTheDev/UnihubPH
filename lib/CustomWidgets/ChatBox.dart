import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  String message;
  ChatBox({this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 150,
        child: Card(
          child: Container(
            alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Text("hello lol text text")),
        ),
      );
  }
}
