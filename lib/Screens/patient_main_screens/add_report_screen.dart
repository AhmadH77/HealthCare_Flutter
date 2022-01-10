import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/controllers/patients_main_controller.dart';
import 'package:health_care/widgets/background.dart';
import 'package:health_care/widgets/reportTextField.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({Key? key}) : super(key: key);

  @override
  _AddReportScreenState createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  PatientsMainController controller = Get.put(PatientsMainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Background(
        withImage: false,
        source: 'addReport',
        child: SingleChildScrollView(
          child: GetBuilder<PatientsMainController>(builder: (controller) {
            return Obx(() => controller.isSending.value
                ? CircularProgressIndicator()
                : Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: controller.reportKey.value,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Text(
                              'Write a report text and send it!',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 22),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ReportTextField(
                              controller: controller.reportTextController,
                              labelText: 'Report Text',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => controller.sendReport(),
                                    child: Text('Send'),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.all(20)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blueAccent),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10)))),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
          }),
        ),
      ),
    );
  }
}
