import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_care/Screens/main_screen.dart';
import 'package:health_care/Screens/patients_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locationController.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var loginKey = GlobalKey<FormState>().obs;
  var isLoading = false.obs;
  var isPatientUser = ''.obs;

  LocationController controller = Get.put(LocationController());

  Future<void> logIn() async {
    isLoading(true);
    debugPrint('${controller.result.value['latitude']}');

    try {
      debugPrint(
          'email: ${emailController.text}, password: ${passwordController.text} ');
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("logged", true);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get()
          .then((value) async {
        debugPrint('userCredential.user ${value.get('accountType').toString() == '2'}  ${userCredential.user}');
        await controller.determinePosition();
        isLoading(false);
        prefs.setString('accountType', value.get('accountType').toString());

        Get.off(()=> value.get('accountType').toString() == '2' ? PatientMainScreen() : MainScreen());
      });
     
     
    } on FirebaseAuthException catch (e) {
      isLoading(false);
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "No user found for that email",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Wrong password provided for that user",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
        debugPrint('Wrong password provided for that user.');
      }
      else {
        Fluttertoast.showToast(
            msg: "Something went wrong! Please try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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
          fontSize: 16.0
      );
      debugPrint("catch  $e");
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    emailController.clear();
    passwordController.clear();
  }

   isPatient(String userId) async {
    try {

      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        debugPrint('testisPatient   ${value.get('accountType')}');
        if(value.get('accountType').toString() == '2') {
          isPatientUser('true');
        }
        isPatientUser('false');
      })
          .catchError((e) {
        Fluttertoast.showToast(
            msg: "Something went wrong! Please try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('error  $e');
        isPatientUser('-');
      });
    } on Exception catch (e) {
      // TODO
      debugPrint('error Exception getUserInfo   $e');
      Fluttertoast.showToast(
          msg: "Something went wrong! Please try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      isPatientUser('-');
    }
  }
}
