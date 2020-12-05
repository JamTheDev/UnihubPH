import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextWid extends StatelessWidget {
  final String _text, fontFamily;
  final double fontSize;
  final Color color;
  TextWid(this._text, {this.fontSize, this.fontFamily, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
        _text,
        style: TextStyle(fontFamily: fontFamily,fontSize: fontSize, color: color),
        textAlign: TextAlign.center,
      ),
    );
  }
}
