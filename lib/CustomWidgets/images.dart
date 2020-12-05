import 'package:flutter/material.dart';

class images extends StatelessWidget {
  final String url;

  images(this.url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 150,
      height: 150,
      child: CircleAvatar(
        radius: 50.0,
          backgroundImage: AssetImage("./images/app_icon.png")
      ),
    );
  }
}
