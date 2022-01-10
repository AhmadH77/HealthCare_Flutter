import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_care/controllers/mainScreenController.dart';
import 'main_screens/patients_list_screen.dart';
import 'main_screens/profile_screen.dart';
import 'main_screens/reports_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainScreenController controller = Get.put(MainScreenController());
  var pages = [
    PatientsListScreen(),
    ReportsListScreen(),
    ProfileScreen(
      isPatient: false,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: controller.bottomNavigationKey.value,
          height: 50,
          items: <Widget>[
            Icon(Icons.people,
                color:
                    controller.page.value == 0 ? Colors.teal : Colors.black38,
                size: 30),
            Icon(Icons.list,
                color:
                    controller.page.value == 1 ? Colors.teal : Colors.black38,
                size: 30),
            Icon(Icons.person,
                color:
                    controller.page.value == 2 ? Colors.teal : Colors.black38,
                size: 30),
          ],
          onTap: (index) {
            setState(() {
              controller.page(index);
            });
          },
        ),
        body: pages[controller.page.value]);
  }
}
