import 'package:demo_project/GetX%20Controller/navigationcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabNavigation extends StatelessWidget {
  const TabNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.put(NavigationController());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navigationController.selectedIndex.value,
          onTap: (index) {
            navigationController.selectedIndex.value = index;
          },
          backgroundColor: const Color(0xff2a2e7e),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.3),
          selectedFontSize: 12,  // Adjust this value to change the size of the text
          unselectedFontSize: 12,  // Adjust this value to change the size of the text
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "CART",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "PROFILE",
            ),
          ],
        ),
      ),
      body: Obx(
        () => navigationController.screens[navigationController.selectedIndex.value],
      ),
    );
  }
}
