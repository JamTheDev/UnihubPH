import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unihub/CustomWidgets/PostDesignWidget.dart';
class DBRef {
  final firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> initPostStream() {
    return firestore.collection("PostsPath").snapshots();
  }

  Stream<QuerySnapshot> initCommentsStream() {
    return firestore.collection("PostComments").snapshots();
  }

  Stream<QuerySnapshot> initLikesStream() {
    return firestore.collection("PostLikes").snapshots();
  }

  Stream<QuerySnapshot> initFollowStream() {
    return firestore.collection("FollowUsers").snapshots();
  }

  Stream<QuerySnapshot> initUserStream() {
    return firestore.collection("UserInfo").snapshots();
  }


  Future<String> createPost(String postID, String image, String createdAt, String author, String caption) async {
    DocumentReference create = await firestore.collection("PostsPath").add({
      "postID": postID,
      "image": image,
      "createdAt": createdAt,
      "author": author,
      "caption": caption
    });
    return create.id;
  }

  Future<String> createUser(String firstName, String lastName, String usertag, String bio, String city, String province, String month, String id, String day, String year, String profile) async {
    DocumentReference create = await firestore.collection("UserInfo").add({
      "firstName": firstName,
      "lastName": lastName,
      "usertag": usertag,
      "bio": bio,
      "city": city,
      "province": province,
      "month": month,
      "id": id,
      "day": day,
      "year": year,
      "profile": profile,
    });
    return create.id;
  }


}

DBRef dbRef = new DBRef();