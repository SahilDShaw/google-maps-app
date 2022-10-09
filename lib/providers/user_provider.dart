import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  // Data
  String? _name;
  String? _email;
  String? _address;

  // getters
  String? get name => _name;
  String? get email => _email;
  String? get address => _address;

  // setters
  void setData({
    required String name,
    required String email,
    required String address,
  }) {
    _name = name;
    _email = email;
    _address = address;
    print('Values set: $_name  $_email  $_address');
  }

  // create new user
  Future<String?> createNewUser(String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String?> signInUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print('User signed in');
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}
