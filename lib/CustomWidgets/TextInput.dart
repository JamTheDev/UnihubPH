import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  String returnInput() {
    return _TextInputState().text;
  }
  @override
  _TextInputState createState() => new _TextInputState();
}


class _TextInputState extends State{
  String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        decoration: new InputDecoration(
          hintText: "Type in here!"
        ),
        onSubmitted: (String str) =>  text = str,
      ),
    );
  }

}