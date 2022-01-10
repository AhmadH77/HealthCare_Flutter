import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/controllers/mainScreenController.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({Key? key}) : super(key: key);

  @override
  _PatientsListScreenState createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  MainScreenController controller = Get.put(MainScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // test();
    controller.getAllPatient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        )),
        title: const Text(
          'Patients',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : GetBuilder<MainScreenController>(
                    builder: (controller) => patientList())),
          ),
        ),
      ),
    );
  }

  patientList() {
    return ListView.builder(
      itemCount: controller.patientList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10, bottom: 10, left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/images/patient.png',
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.patientList[index].name}',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text('Status : ',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold)),
                            Text('${controller.patientList[index].status}',
                                style: TextStyle(
                                    color:
                                        controller.patientList[index].status ==
                                                'Healthy'
                                            ? Colors.teal
                                            : Colors.red)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      controller.editStatusDialog(
                          context, controller.patientList[index]);
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.teal,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
