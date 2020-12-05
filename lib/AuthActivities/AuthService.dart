import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/DartFiles/UserUID.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserUID _userFromFirebaseAuth(User user){
    return user != null ? UserUID(uid: user.uid) : null;
  }
  Future signIn(email, password) async {
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future registerAccount(email, password) async{
    try{
      UserCredential create = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseAuth(create.user).uid;
    }catch (e){
      print(e.toString());
      return null;
    }
  }




  Future<String> getCurrentUser() async{
    if(_firebaseAuth.currentUser.uid != null){
      return "success";
    }
    return "error";
  }
}