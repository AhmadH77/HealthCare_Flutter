import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/Screens/auth/register.dart';
import 'package:health_care/Screens/auth/reset_password.dart';
import 'package:health_care/controllers/loginController.dart';
import 'package:health_care/widgets/authTextField.dart';
import 'package:health_care/widgets/background.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        withImage: true,
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: controller.loginKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "LOGIN",
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
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: AuthTextField(
                    controller: controller.passwordController,
                    labelText: "Password",
                    obscureText: true,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.to(() => ResetPasswordScreen()),
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Text(
                      "Forgot your password?",
                      style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: loginButton(size),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () => {
                      Get.off(() => RegisterScreen())
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                    },
                    child: Text(
                      "Don't Have an Account? Sign up",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2661FA)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginButton(size) {
    return ElevatedButton(
      onPressed: () {
        if (!controller.isLoading.value) {
          if (controller.loginKey.value.currentState!.validate()) {
            controller.logIn();
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
                "LOGIN",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
      ),
    );
  }
}
