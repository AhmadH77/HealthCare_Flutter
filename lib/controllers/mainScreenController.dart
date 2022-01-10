import 'dart:collection';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:health_care/Screens/auth/login.dart';
import 'package:health_care/model/appUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenController extends GetxController {
  var isLoading = false.obs;
  var isReportsLoading = false.obs;
  var isUserInfoLoading = false.obs;
  var inEditMode = false.obs;
  var page = 0.obs;
  var status = "".obs;
  var gender = "".obs;
  var patientList = <AppUser>[].obs;
  var reportList = <Map>[].obs;
  var userInfo = <AppUser>[].obs;
  var bottomNavigationKey = GlobalKey<CurvedNavigationBarState>().obs;
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  getAllPatient() {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    patientList.clear();
    isLoading(true);
    try {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc['accountType'] == 2) {
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
            ));

            print('rrr  ${patientList[0].name}  ${patientList[0].status}');
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

  editStatusDialog(context, AppUser patient) {
    status(patient.status);
    AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.INFO,
            body: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Change '),
                          TextSpan(
                            text: patient.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: " 's Health Status"),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Radio(
                                value: "Healthy",
                                groupValue: status.value,
                                activeColor: Colors.teal,
                                onChanged: (value) {
                                  debugPrint("test status   $value");
                                  status(value.toString());
                                },
                              ),
                              const Text(
                                "Healthy",
                                style: TextStyle(color: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Radio(
                              value: "Patient",
                              groupValue: status.value,
                              activeColor: Colors.red,
                              onChanged: (value) {
                                debugPrint("test status   $value");
                                status(value.toString());
                              },
                            ),
                            const Text("Patient",
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                        SizedBox(),
                      ],
                    )
                  ],
                )),
            btnOkOnPress: () => changeStatus(patient.id),
            btnCancelOnPress: () {})
        .show();
  }

  changeStatus(id) {
    isLoading(true);
    try {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.id == id) {
            doc.reference
                .update({'status': status.value})
                .then((value) => print("User Updated"))
                .catchError((error) => Fluttertoast.showToast(
                    msg: "Something went wrong! Please try again later",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0));
            print('rrr  ${doc['name']}');
          }
        });
        getAllPatient();
      });
    } on Exception catch (e) {
      // TODO
      debugPrint('error Exception   $e');
      isLoading(false);
    }
  }

  //
  getAllReports() {
    reportList.clear();
    isReportsLoading(true);
    try {
      FirebaseFirestore.instance
          .collection('reports')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          String patientName = '';
          for (var element in patientList.value) {
            print(
                '${element.id} == ${doc.id}  ${element.id.toString() == doc.id.toString()}');
            element.id == doc['id'] ? patientName = element.name : null;
          }
          reportList.add(HashMap()
            ..putIfAbsent('patientName', () => patientName)
            ..putIfAbsent('id', () => doc['id'])
            ..putIfAbsent('report_id', () => doc.id)
            ..putIfAbsent('reportText', () => doc['reportText']));

          print('rrr $patientName   ${reportList[0]['reportText']}');
        });
        isReportsLoading(false);
      });
    } on Exception catch (e) {
      // TODO
      debugPrint('error Exception   $e');
      isReportsLoading(false);
    }
  }

  deleteReport(reportId, id, value1) {
    isReportsLoading(true);

    FirebaseFirestore.instance
        .collection('reports')
        .doc(reportId)
        .delete()
        .then((value) {
      debugPrint("doc Deleted  $id  $value1");
      getAllReports();
    }).catchError((error) {
      isReportsLoading(false);

      debugPrint("Failed to delete doc: $error");
      Fluttertoast.showToast(
          msg: "Something went wrong! Please try again later",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  //
  getUserInfo() {
    debugPrint('test   ${FirebaseAuth.instance.currentUser!.uid}');

    try {
      isUserInfoLoading(true);
      userInfo.clear();
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        debugPrint('test   ${value.data()}');
        gender(value.get('gender'));
        nameController.text = value.get('name');
        emailController.text = value.get('email');

        userInfo.add(AppUser(
          FirebaseAuth.instance.currentUser!.uid,
          value.get('accountType'),
          value.get('name'),
          value.get('email'),
          value.get('gender'),
          value.get('password'),
          value.get('accountType') == 2 ? value.get('status') : '-',
          value.get('latitude').toString(),
          value.get('longitude').toString(),
        ));
        isUserInfoLoading(false);
      }).catchError((e) {
        isUserInfoLoading(false);
        Fluttertoast.showToast(
            msg: "Something went wrong! Please try again later",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('error  $e');
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
      isUserInfoLoading(false);
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAll(() => LoginScreen());
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    debugPrint('test close');
    inEditMode(false);
  }

  void updateInfo() {
    isUserInfoLoading(true);
    try {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          if (doc.id == FirebaseAuth.instance.currentUser!.uid) {
            doc.reference.update({
              'name': nameController.text,
              'email': emailController.text,
              'gender': gender.value,
            }).then((value) {
              debugPrint("User Updated");
              inEditMode(false);
              getUserInfo();
            }).catchError((error) {
              Fluttertoast.showToast(
                  msg: "Something went wrong! Please try again later",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              print('rrr   $error');
            });
            isUserInfoLoading(false);
            print('rrr  ${doc['name']} ');
          }
        });
      });
    } on Exception catch (e) {
      // TODO
      debugPrint('error Exception   $e');
      isUserInfoLoading(false);
    }
  }
}
