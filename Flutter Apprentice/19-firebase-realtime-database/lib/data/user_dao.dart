import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserDao extends ChangeNotifier
{
  final auth = FirebaseAuth.instance;

  // Return true if the user is logged in. If the current user is null,
  // they are logged out.
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  // Return the id of the current user, which could be null
  String? userId() {
    return auth.currentUser?.uid;
  }

  // Return the email of the current user
  String? email() {
    return auth.currentUser?.email;
  }

  void signup(String email, String password) async {
    try {
      // Call the Firebase method to create a new account
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      notifyListeners();
    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      // Catch any other type of exception
      print(e);
    }
  }
  
  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 3
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
