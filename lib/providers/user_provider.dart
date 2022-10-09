import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<String?> createNewUser({
    required String name,
    required String emailAddress,
    required String password,
    required String address,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      await dataEntry(
        name: name,
        emailAddress: emailAddress,
        address: address,
      );
      _name = name;
      _email = emailAddress;
      _address = address;
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

  // create entry in the database
  Future<void> dataEntry({
    required String name,
    required String emailAddress,
    required String address,
  }) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final users = FirebaseFirestore.instance.collection('UserData');
    return users
        .doc(uid)
        .set(
          {
            'name': name,
            'email': emailAddress,
            'address': address,
          },
        )
        .then((value) => print("User Created"))
        .catchError(
          (error) => print("Failed to create user: $error"),
        );
  }

  // sign in
  Future<String?> signInUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      print('User signed in');
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
  }

  // updating provider from firebase
  Future<void> getDataFromFirebase() {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final document = FirebaseFirestore.instance.collection('UserData').doc(uid);
    return document.get().then(
      (snapshot) {
        final values = snapshot.data();
        print(values);
        setData(
          name: values!['name'].toString(),
          email: values['email'].toString(),
          address: values['address'].toString(),
        );
      },
    );
  }

  // edit user
  Future<String?> editUser({
    required String name,
    required String emailAddress,
    required String address,
    required String password,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final users = FirebaseFirestore.instance.collection('UserData');

    await user.updateEmail(emailAddress);
    await user.updatePassword(password);

    return users.doc(uid).set(
      {
        'name': name,
        'email': emailAddress,
        'address': address,
      },
    ).then((value) {
      _name = name;
      _email = emailAddress;
      _address = address;
      notifyListeners();
      print("User Edited");
    }).catchError(
      (error) => print("Failed to create user: $error"),
    );
  }

  // sign out
  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
