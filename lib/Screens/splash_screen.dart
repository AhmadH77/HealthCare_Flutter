import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/Screens/auth/register.dart';
import 'package:health_care/Screens/patients_main_screen.dart';
import 'package:health_care/controllers/locationController.dart';
import 'package:health_care/widgets/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LocationController controller = Get.put(LocationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      await controller.determinePosition();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (prefs.getBool("logged") ?? false) {
        if (prefs.getString("accountType") == '2') {
          Get.off(() => PatientMainScreen());
        } else {
          Get.off(() => MainScreen());
        }
      } else {
        Get.off(() => RegisterScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Background(
        withImage: false,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Welcome to',
                style: TextStyle(color: Colors.teal, fontSize: 24),
              ),
              Image.asset(
                "assets/images/splash.png",
                height: height / 4,
                width: 200,
              ),
              Text(
                'Health Care APP',
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                  child: Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : Text(
                          "Let's go",
                          style: TextStyle(color: Colors.teal, fontSize: 18),
                        )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
