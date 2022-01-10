import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/controllers/mainScreenController.dart';
import 'package:health_care/widgets/authTextField.dart';

class ProfileScreen extends StatefulWidget {
  final bool isPatient;

  const ProfileScreen({Key? key, required this.isPatient}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MainScreenController controller = Get.put(MainScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Obx(() => controller.isUserInfoLoading.value
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: controller.userInfo.value.length > 0
                    ? GetBuilder<MainScreenController>(
                        builder: (controller) => Obx(() => Column(
                              children: [
                                Card(
                                  margin: EdgeInsets.all(10),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.only(
                                              bottom: 20, left: 10, right: 10),
                                          title: Text(
                                            'Personal Information',
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(
                                              controller.inEditMode.value
                                                  ? Icons.check_rounded
                                                  : Icons.edit_outlined,
                                              color: Colors.teal,
                                            ),
                                            onPressed: () {
                                              if (controller.inEditMode.value) {
                                                controller.updateInfo();
                                              } else {
                                                controller.inEditMode(
                                                    !controller
                                                        .inEditMode.value);
                                              }
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.blue,
                                          ),
                                          title: controller.inEditMode.value
                                              ? AuthTextField(
                                                  controller:
                                                      controller.nameController)
                                              : Text(
                                                  controller
                                                      .userInfo.value[0].name,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          subtitle: controller.inEditMode.value
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "Gender",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Radio(
                                                            value: "Female",
                                                            groupValue:
                                                                controller
                                                                    .gender
                                                                    .value,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                debugPrint(
                                                                    "test gender   $value");
                                                                controller
                                                                    .gender(value
                                                                        .toString());
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
                                                            groupValue:
                                                                controller
                                                                    .gender
                                                                    .value,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                debugPrint(
                                                                    "test gender   $value");
                                                                controller
                                                                    .gender(value
                                                                        .toString());
                                                              });
                                                            },
                                                          ),
                                                          const Text("Male"),
                                                        ],
                                                      ),
                                                      SizedBox(),
                                                    ],
                                                  ),
                                                )
                                              : Text(controller
                                                  .userInfo.value[0].gender),
                                        ),
                                        ListTile(
                                          leading: Icon(
                                            Icons.email,
                                            size: 40,
                                            color: Colors.amber,
                                          ),
                                          title: controller.inEditMode.value
                                              ? AuthTextField(
                                                  controller: controller
                                                      .emailController)
                                              : Text(
                                                  controller
                                                      .userInfo.value[0].email,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                        ),
                                        controller.userInfo.value[0]
                                                    .accountType ==
                                                2
                                            ? ListTile(
                                                leading: Icon(
                                                  Icons.health_and_safety,
                                                  size: 40,
                                                  color: Colors.teal,
                                                ),
                                                title: Text(
                                                  controller
                                                      .userInfo.value[0].status,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: controller
                                                                  .userInfo
                                                                  .value[0]
                                                                  .status ==
                                                              'Healthy'
                                                          ? Colors.teal
                                                          : Colors.red),
                                                ),
                                              )
                                            : Container(),
                                        ListTile(
                                          leading: Icon(
                                            Icons.account_circle_outlined,
                                            size: 40,
                                            color: Colors.deepOrangeAccent,
                                          ),
                                          title: Text(
                                            controller.userInfo.value[0]
                                                        .accountType ==
                                                    2
                                                ? 'Patient User'
                                                : 'Medical Stuff User',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 50.0, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red),
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            elevation:
                                                MaterialStateProperty.all(8),
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.only(
                                                    left: 30,
                                                    right: 30,
                                                    top: 10,
                                                    bottom: 10)),
                                          ),
                                          onPressed: () {
                                            controller.logout();
                                          },
                                          icon: Icon(
                                            Icons.logout_outlined,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          label: Text(
                                            'Log out',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      )
                    : Container(),
              )),
      ),
    );
  }

  appBar() {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 220),
      child: Stack(
        children: [
          Container(
            height: widget.isPatient ? 180 : 200,
            child: AppBar(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40))),
              elevation: 4.0,
              title: widget.isPatient
                  ? null
                  : Text(
                      'Profile',
                    ),
            ),
          ),
          Align(
            child: Card(
              elevation: 8,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Obx(() => controller.isUserInfoLoading.value
                      ? CircularProgressIndicator()
                      : Image.asset(
                          controller.userInfo.value[0].accountType == 2
                              ? 'assets/images/patient.png'
                              : 'assets/images/docs.png',
                          height: 100,
                          width: 100,
                        )),
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
}
