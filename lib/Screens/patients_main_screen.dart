import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:health_care/Screens/patient_main_screens/nearby-patients.dart';
import 'package:health_care/controllers/patients_main_controller.dart';
import 'main_screens/profile_screen.dart';
import 'patient_main_screens/add_report_screen.dart';

class PatientMainScreen extends StatefulWidget {
  @override
  State<PatientMainScreen> createState() => _PatientMainScreenState();
}

class _PatientMainScreenState extends State<PatientMainScreen> {
  final _advancedDrawerController = AdvancedDrawerController();
  PatientsMainController controller = Get.put(PatientsMainController());
  var pages = [
    NearbyPatients(),
    AddReportScreen(),
    ProfileScreen(
      isPatient: true,
    ),
  ];
  var titles = ['Nearby Patients', 'Reports', 'Profile'];

  @override
  Widget build(BuildContext context) {
    Color color = Color(0xFF0069B1);
    return AdvancedDrawer(
      backdropColor: color,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Obx(() => Scaffold(
            appBar: AppBar(
              elevation: controller.pageIndex.value == 2 ? 0.0 : 4.0,
              shape: controller.pageIndex.value == 2
                  ? null
                  : RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    )),
              title: Text(titles[controller.pageIndex.value]),
              leading: IconButton(
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      child: Icon(
                        value.visible ? Icons.clear : Icons.menu,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              ),
            ),
            body: pages[controller.pageIndex.value],
          )),
      drawer: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/top12.png',
              color: Colors.blue[100],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/bottom1.png',
                color: Colors.blue[400],
              ),
            ),
            Container(
              child: ListTileTheme(
                textColor: Colors.white,
                iconColor: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Card(
                      color: Colors.transparent,
                      elevation: 8,
                      margin: const EdgeInsets.only(
                          top: 24.0, bottom: 64.0, left: 0, right: 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      child: Container(
                        width: 128.0,
                        height: 128.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/patient.png',
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        controller.changePageIndex(0);
                        _advancedDrawerController.hideDrawer();
                      },
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                    ListTile(
                      onTap: () {
                        controller.changePageIndex(1);
                        _advancedDrawerController.hideDrawer();
                      },
                      leading: Icon(Icons.list),
                      title: Text('Reports'),
                    ),
                    ListTile(
                      onTap: () {
                        controller.changePageIndex(2);
                        _advancedDrawerController.hideDrawer();
                      },
                      leading: Icon(Icons.account_circle_rounded),
                      title: Text('Profile'),
                    ),
                    Spacer(),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white54,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: Text('Terms of Service | Privacy Policy'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
}
