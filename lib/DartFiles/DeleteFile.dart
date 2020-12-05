import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class DeleteFile {
  String oldUrl, fileName;
  static String url;
  File selectedFile;
  DeleteFile({this.oldUrl, this.selectedFile, this.fileName});
  Future<void> deleteAndUploadNewProfile() async {
    final _storage = FirebaseStorage.instance;
    if (oldUrl != null) {
      var fileUrl = Uri.decodeFull(basename(oldUrl))
          .replaceAll(new RegExp(r'(\?alt).*'), '');
      StorageReference photoRef = await FirebaseStorage.instance
          .ref().child("profilePictures/" + fileName);
      try {
        await photoRef.delete();
      } catch (e) {}
    }

    var snapshot = await _storage
        .ref()
        .child("profilePictures/" + fileName)
        .putFile(selectedFile)
        .onComplete;
    url = await snapshot.ref.getDownloadURL();
    print(url);
  }

  String getURL() {
    return url;
  }
}