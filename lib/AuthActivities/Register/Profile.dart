import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unihub/AuthActivities/Register/Biography.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unihub/AuthActivities/Register/EmailVerification.dart';
import 'package:unihub/DartFiles/RegisterInformation.dart';
import 'Credentials.dart';
import 'RegPart1.dart';
import 'package:image_cropper/image_cropper.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String firstName;
  final GlobalKey<FormState> forms = new GlobalKey();

  final TextEditingController cont1 = new TextEditingController(), cont2 = new TextEditingController();
  Future<void> _validateTextViews() async {
      final RegisterInformation reInfo = new RegisterInformation();
      if(_selectedFile != null){
        RegisterInformation.image = _selectedFile;
        Navigator.pushNamedAndRemoveUntil(context, "/verification", (r) => false);
      }else{
        _showDialog("You have not selected an profile picture!", "Halt!");
      }
  }

  Future<void> _showDialog(String text, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Ok."))
            ],
          );
        });
  }
  bool inProcess = false;
  Widget imageWidget() {
    if (_selectedFile != null) {
      return Container(
        width: 200,
        height: 200,
        child: CircleAvatar(
          child: ClipOval(
            child: Image.file(
              _selectedFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: 200,
        height: 200,
        child: CircleAvatar(
          child: ClipOval(
            child: Image.asset(
              "./images/placeholder.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }
  }
  _getImage(ImageSource src) async {
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
  File _selectedFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          color: Color.fromRGBO(34, 167, 240, 1),
            child: Stack(
              children: [
               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Expanded(
                     child: Container(
                       margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                       decoration: BoxDecoration(
                         color: Color.fromRGBO(34, 167, 240, 1),
                       ),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(
                             "Show us what you look like!",
                             style: TextStyle(
                                 fontFamily: "Sen",
                                 fontSize: 40,
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold),
                           ),
                           Container(
                             margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                             child: Text(
                               "Let users know who you are and what you look like!",
                               style: TextStyle(
                                   fontFamily: "Sen",
                                   fontSize: 20,
                                   color: Colors.white),
                               textAlign: TextAlign.left,
                             ),
                           ),
                         ],
                       ),
                     ),
                     flex: 4,
                   ),
                   Expanded(
                       child: Container(
                         decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.only(
                                 topLeft: Radius.circular(30.0),
                                 topRight: Radius.circular(30.0))),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Container(
                               margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                               child: GestureDetector(
                                 child: imageWidget(),
                                 onTap: () => _getImage(ImageSource.gallery),
                               ),
                             ),
                             Text("Click to change profile",
                                 style: TextStyle(
                                     fontFamily: "DefaultFont",
                                     fontSize: 15,
                                     color: Colors.black)),
                             Expanded(
                               child: Row(
                                 children: [
                                   Expanded(
                                     child: Container(
                                       margin: EdgeInsets.all(20),
                                       alignment: Alignment.bottomLeft,
                                       child: RaisedButton.icon(
                                         onPressed: () {
                                           _validateTextViews();
                                           Navigator.pushNamedAndRemoveUntil(context, "/biography", (r) => false);
                                         },
                                         icon: Icon(
                                           Icons.keyboard_arrow_left,
                                           size: 40.0,
                                           color: Color.fromRGBO(34, 167, 240, 1),
                                         ),
                                         label: Text("Back", style: TextStyle(fontSize: 11.0, fontFamily: "Sen"),),
                                         color: Colors.white,
                                         shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(40)),
                                       ),
                                     ),
                                   ),
                                   Expanded(
                                     child: Container(
                                       margin: EdgeInsets.all(20),
                                       alignment: Alignment.bottomLeft,
                                       child: RaisedButton(
                                         color: Colors.white,
                                         child: Row(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             Text(
                                               "Proceed",
                                               style: TextStyle(fontSize: 11.0, fontFamily: "Sen"),
                                             ),
                                             Icon(
                                               Icons.keyboard_arrow_right,
                                               size: 40.0,
                                               color: Color.fromRGBO(34, 167, 240, 1),
                                             ),
                                           ],
                                         ),
                                         textColor: Colors.black,
                                         shape: OutlineInputBorder(
                                             borderSide: BorderSide(
                                                 style: BorderStyle.solid, width: 1.0, color: Colors.white),
                                             borderRadius: new BorderRadius.circular(20.0)),
                                         onPressed: () {
                                           _validateTextViews();

                                         },

                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             )
                           ],
                         ),
                       ),
                       flex: 7)
                 ]
               ),

                 (inProcess)
                   ? Container(
                 height: MediaQuery.of(context).size.height * 0.95,
                 child: Center(child: CircularProgressIndicator()),
               )
                   : Center()
              ],

            ),
          ),
        ),
    );
  }
}
