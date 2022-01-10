import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_care/Screens/auth/login.dart';
import 'package:health_care/Screens/main_screen.dart';
import 'package:health_care/Screens/patients_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locationController.dart';

class SignupController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var registerKey = GlobalKey<FormState>().obs;
  var resetKey = GlobalKey<FormState>().obs;
  var selected = 1.obs;
  var gender = "".obs;
  var isLoading = false.obs;

  LocationController controller = Get.put(LocationController());

  Future<void> signUp() async {
    print('${controller.result.value['latitude']}');
    isLoading(true);
    try {
      debugPrint(
          'email: ${emailController.text}, password: ${passwordController.text}  gender.value  ${gender.value} selected.value  ${selected.value}');
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      Map<String, dynamic> info = {};
      if (selected.value == 2) {
        info = {
          'email': emailController.text,
          'password': passwordController.text,
          'gender': gender.value,
          'name': nameController.text,
          'latitude': controller.result.value['latitude'],
          'longitude': controller.result.value['longitude'],
          'accountType': selected.value,
          'status': 'Healthy'
        };
      } else {
        info = {
          'email': emailController.text,
          'password': passwordController.text,
          'gender': gender.value,
          'name': nameController.text,
          'latitude': controller.result.value['latitude'],
          'longitude': controller.result.value['longitude'],
          'accountType': selected.value,
        };
      }
      await controller.determinePosition();
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.doc(userCredential.user!.uid).set(info).then((value) async {
        isLoading(false);
        debugPrint("User Added");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("logged", true);
        prefs.setString('accountType', selected.value.toString());
        selected.value == 2
            ? Get.off(() => PatientMainScreen())
            : Get.off(() => MainScreen());
      }).catchError((error) {
        isLoading(false);
        Fluttertoast.showToast(
            msg: "Something went wrong! Please try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        debugPrint("Failed to add user: $error");
      });
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: "The password provided is too weak",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        debugPrint('The account already exists for that email.');
      }
    } catch (e) {
      isLoading(false);
      Fluttertoast.showToast(
          msg: "Something went wrong! Please try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      debugPrint("catch  $e");
    }
  }

  resetPassword() async {
    isLoading(true);
    debugPrint('email: ${emailController.text}');
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text)
        .then((value) {
      isLoading(false);
      Fluttertoast.showToast(
          msg: "Reset password email has been sent!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.off(() => LoginScreen());
    }).catchError((e) {
      isLoading(false);
      debugPrint("Failed to add user: $e");
      if (e.toString().contains('user-not-found')) {
        Fluttertoast.showToast(
            msg: "There is no user record corresponding to this email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Something went wrong! Please try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    // registerKey.currentState!.dispose();
    // resetKey.currentState!.dispose();
  }
}
