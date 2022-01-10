import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationController extends GetxController {
  var result = HashMap().obs;
  var isLoading = false.obs;
  late SharedPreferences prefs;


  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    prefs = await SharedPreferences.getInstance();

    isLoading(true);
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {

        isLoading(false);
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {

          isLoading(false);
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLoading(false);
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }


      await Geolocator.getCurrentPosition().then((value) async {
        debugPrint('loc test  _locationData ${value.longitude}');

        result(HashMap()
          ..putIfAbsent("latitude", () => value.latitude)
          ..putIfAbsent("longitude", () => value.longitude));
        debugPrint('result  ${result.value}');

        prefs.setString("latitude", value.latitude.toString());
        prefs.setString("longitude", value.longitude.toString());

        if (prefs.getBool('logged') ?? false) {
          debugPrint('logged  ${FirebaseAuth.instance.currentUser!.uid}');
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'latitude': value.latitude.toString(),
            'longitude': value.longitude.toString(),
          });
        }

        isLoading(false);
        update();

      });
    } on Exception catch (e) {
      // TODO
      isLoading(false);
      debugPrint('location Exception  $e');
    }
  }
}
