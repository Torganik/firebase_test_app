import 'package:firebase_auth/firebase_auth.dart';

typedef UserChangeListener = void Function(User u);

class AuthService {
  static final AuthService _singleton = AuthService._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

  User getCurrentyUser() {
    return _auth.currentUser;
  }

  Future<User> tryToAuth(String login, String pass) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: login, password: pass);
      return userCredential.user;
    } catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future<void> registerNewUser(String email, String pass) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      _auth.signInWithCredential(userCredential.credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void setUserChangeListener(UserChangeListener listener) {
    _auth.userChanges().listen(listener);
  }
}
