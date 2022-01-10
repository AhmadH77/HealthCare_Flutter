import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/model/appUser.dart';

class Auth {
  Auth() {}

  Future<void> signUp(AppUser appUser) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: appUser.email, password: appUser.password);

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users
          .doc(userCredential.user!.uid)
          .set({
            'email': appUser.email,
            'password': appUser.password,
            'gender': appUser.gender,
            'name': appUser.name,
          })
          .then((value) => debugPrint("User Added"))
          .catchError((error) => debugPrint("Failed to add user: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      debugPrint("catch  $e");
    }
  }
}
