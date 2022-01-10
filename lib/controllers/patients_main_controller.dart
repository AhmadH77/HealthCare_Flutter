import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:health_care/model/appUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientsMainController extends GetxController {
  var patientList = <AppUser>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var pageIndex = 0.obs;
  var reportTextController = TextEditingController();
  var reportKey = GlobalKey<FormState>().obs;

  changePageIndex(index) {
    pageIndex(index);
  }

  getNearbyPatient() async {
    patientList.clear();
    isLoading(true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          if (doc.id != FirebaseAuth.instance.currentUser!.uid &&
              doc['accountType'] == 2) {
            if (doc['status'] == 'Patient') {
              double distanceInMeters = Geolocator.distanceBetween(
                double.parse(prefs.getString('latitude') ?? '0'),
                double.parse(prefs.getString('longitude') ?? '0'),
                double.parse(doc['latitude']),
                double.parse(doc['longitude']),
              );
              if (distanceInMeters <= 1000) {
                debugPrint('Nearby user   ${doc['name']}');

                debugPrint(
                    'Nearby user   ${double.parse(prefs.getString('latitude') ?? '0')} , ${double.parse(prefs.getString('longitude') ?? '0')} - ${double.parse(doc['latitude'])} , ${double.parse(doc['longitude'])}');

                patientList.add(AppUser(
                    doc.id,
                    doc['accountType'],
                    doc['name'],
                    doc['email'],
                    doc['gender'],
                    doc['password'],
                    doc['status'],
                    doc['latitude'],
                    doc['longitude'],
                    distance: distanceInMeters.toStringAsFixed(2)));
              } else
                debugPrint(
                    'Nearby user $distanceInMeters   ${double.parse(prefs.getString('latitude') ?? '0')} , ${double.parse(prefs.getString('longitude') ?? '0')} - ${double.parse(doc['latitude'])} , ${double.parse(doc['longitude'])}');
            }
          }
        });
        isLoading(false);
      });
    } on Exception catch (e) {
      // TODO
      debugPrint('error Exception   $e');
      isLoading(false);
    }
  }

  sendReport() {
    if (reportKey.value.currentState!.validate()) {
      isSending(true);
      try {
        FirebaseFirestore.instance.collection('reports').doc().set({
          'id': FirebaseAuth.instance.currentUser!.uid,
          'reportText': reportTextController.text
        }).then((value) {
          debugPrint('success');
          reportKey(GlobalKey<FormState>());
          reportTextController.clear();
          isSending(false);
          Fluttertoast.showToast(
              msg: "Report sent Successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.teal,
              textColor: Colors.white,
              fontSize: 16.0);
        }).catchError((onError) {
          isSending(false);
          debugPrint('onError  $onError');
          Fluttertoast.showToast(
              msg: "Something went wrong! Please try again later",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      } on Exception catch (e) {
        // TODO
        isSending(false);
        debugPrint('Exception sendReport   $e ');
        Fluttertoast.showToast(
            msg: "Something went wrong! Please try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    reportTextController.clear();
  }
}
