import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/Screens/auth/login.dart';
import 'package:health_care/controllers/locationController.dart';
import 'package:health_care/controllers/signupController.dart';
import 'package:health_care/widgets/authTextField.dart';
import 'package:health_care/widgets/background.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Background(
        withImage: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 40),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: controller.registerKey.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        radius: 10,
                        onTap: () => setState(() {
                          controller.selected(1);
                        }),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white30,
                                border: Border.all(
                                    width: 2,
                                    color: controller.selected.value == 1
                                        ? Colors.teal
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: Image.asset("assets/images/docs.png")
                                        .image)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        radius: 10,
                        onTap: () => setState(() {
                          controller.selected(2);
                        }),
                        child: Card(
                          color: Colors.white,
                          elevation: 8,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white30,
                                border: Border.all(
                                    width: 2,
                                    color: controller.selected.value == 2
                                        ? Colors.teal
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: Image.asset("assets/images/patient.png")
                                        .image)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: AuthTextField(
                    controller: controller.nameController,
                    labelText: "Name",
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: AuthTextField(
                      controller: controller.emailController,
                      labelText: "Email"),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender",
                        style: TextStyle(fontSize: 12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: "Female",
                                groupValue: controller.gender.value,
                                onChanged: (value) {
                                  setState(() {
                                    debugPrint("test gender   $value");
                                    controller.gender(value.toString());
                                  });
                                },
                              ),
                              const Text("Female"),
                            ],
                          ),
                          Row(
                            children: [
                              Radio(
                                value: "Male",
                                groupValue: controller.gender.value,
                                onChanged: (value) {
                                  setState(() {
                                    debugPrint("test gender   $value");
                                    controller.gender(value.toString());
                                  });
                                },
                              ),
                              const Text("Male"),
                            ],
                          ),
                          SizedBox(),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: AuthTextField(
                    controller: controller.passwordController,
                    labelText: "Password",
                    obscureText: true,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: signUpButton(size),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: gotoLogin(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  LocationController controller1 = Get.put(LocationController());

  signUpButton(size) {
    return ElevatedButton(
      onPressed: () {
        
        if (!controller.isLoading.value) {
          if (controller.registerKey.value.currentState!.validate()) {
            controller.signUp();
            // Auth().signUp(AppUser(0, 0, "name", "testtest@email.com", controller.gender.value, "123@1111"));
          }
        }
      },
      style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(80.0))),
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
                "SIGN UP",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
      ),
    );
  }

  gotoLogin(context) {
    return GestureDetector(
      onTap: () => Get.off(()=> LoginScreen())
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()))
      ,
      child: const Text(
        "Already Have an Account? Sign in",
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2661FA)),
      ),
    );
  }
}
