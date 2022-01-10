import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/controllers/patients_main_controller.dart';

class NearbyPatients extends StatefulWidget {
  const NearbyPatients({Key? key}) : super(key: key);

  @override
  _NearbyPatientsState createState() => _NearbyPatientsState();
}

class _NearbyPatientsState extends State<NearbyPatients> {
  PatientsMainController controller = Get.put(PatientsMainController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getNearbyPatient();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => controller.isLoading.value
            ? CircularProgressIndicator()
            : RefreshIndicator(
                onRefresh: () => controller.getNearbyPatient(),
                child: GetBuilder<PatientsMainController>(
                  builder: (controller) => controller.patientList.length > 0
                      ? patientList()
                      : Stack(
                          children: [
                            ListView(),
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "There're no nearby Patients",
                                style: TextStyle(color: Colors.black38),
                              ),
                            ),
                          ],
                        ),
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
                Text('${controller.patientList[index].distance ?? ''} m')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
