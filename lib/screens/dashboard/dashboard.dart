import 'package:bukka/screens/order/orderscreen.dart';
import 'package:bukka/screens/profile/profilescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../home/homescreen.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController()); // register the controller

    return GetBuilder<DashboardController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: IndexedStack(
              index: controller.tabIndex,
              children: [
                HomeScreen(),
                OrderScreen(),
                ProfileScreen()
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.yellow,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.shifting,
          currentIndex: controller.tabIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            _bottomNavigationBarItem(icon: CupertinoIcons.home, label: 'Home'),
            _bottomNavigationBarItem(icon: CupertinoIcons.list_bullet_below_rectangle, label: 'Orders'),
            _bottomNavigationBarItem(icon: CupertinoIcons.profile_circled, label: 'Profile')],
        ),
      );
    });
  }
}

BottomNavigationBarItem _bottomNavigationBarItem({required IconData icon, required String label}) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: label,
  );
}
