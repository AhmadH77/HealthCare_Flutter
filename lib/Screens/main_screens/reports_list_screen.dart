import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/controllers/mainScreenController.dart';

class ReportsListScreen extends StatefulWidget {
  ReportsListScreen({Key? key}) : super(key: key);

  @override
  _ReportsListScreenState createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends State<ReportsListScreen> {
  MainScreenController controller = Get.put(MainScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // test();
    controller.getAllReports();
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
          'Reports',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Obx(() => controller.isReportsLoading.value
                ? CircularProgressIndicator()
                : GetBuilder<MainScreenController>(
                    builder: (controller) => reportList())),
          ),
        ),
      ),
    );
  }

  reportList() {
    print('controller.reportList.length  ${controller.reportList.length}');
    return ListView.builder(
      itemCount: controller.reportList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Report from ',
                              style: TextStyle(fontSize: 15),
                            ),
                            TextSpan(
                              text: controller.reportList.value[index]
                                  ['patientName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                        onTap: () {
                          controller.deleteReport(
                            controller.reportList.value[index]['report_id'],
                            controller.reportList.value[index]['id'],
                            controller.reportList.value[index]['reportText'],
                          );
                        },
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                        )),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 12, bottom: 12),
                child: Text(
                    '${controller.reportList.value[index]['reportText']}',
                    style: TextStyle(fontWeight: FontWeight.w300)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
