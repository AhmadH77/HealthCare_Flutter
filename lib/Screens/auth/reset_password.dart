import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/controllers/signupController.dart';
import 'package:health_care/widgets/authTextField.dart';
import 'package:health_care/widgets/background.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        withImage: true,
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: controller.resetKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: AuthTextField(
                      controller: controller.emailController,
                      labelText: "Email"),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: resetButton(size),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  resetButton(size) {
    return ElevatedButton(
      onPressed: () {
        if (!controller.isLoading.value) {
          if (controller.resetKey.value.currentState!.validate()) {
            controller.resetPassword();
          }
        }
      },
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          ),
          textStyle: MaterialStateProperty.all(const TextStyle(
            color: Colors.white,
          ))),
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        width: size.width * 0.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 255, 136, 34),
              Color.fromARGB(255, 255, 177, 41)
            ])),
        padding: const EdgeInsets.all(0),
        child: Obx(() => controller.isLoading.value
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                "Reset",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
      ),
    );
  }
}
