import 'package:firebase_auth/firebase_auth.dart';
import 'package:unihub/DartFiles/AuthExceptionHandler.dart';
import 'package:unihub/DartFiles/UserUID.dart';

class AuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _auth = FirebaseAuth.instance;
  AuthResultStatus _status;
  Future<AuthResultStatus> createAccount({email, pass}) async {
    try {
      print(email);
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  Future<AuthResultStatus> login({email, pass}) async {
    try {
      final authResult =
      await _auth.signInWithEmailAndPassword(email: email, password: pass);

      if (authResult.user != null) {
        _status = AuthResultStatus.successful;
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return _status;
  }

  logout() {
    _auth.signOut();
  }


  Future<String> getCurrentUser() async{
    if(_firebaseAuth.currentUser.uid != null){
      return "success";
    }
    return "error";
  }
}