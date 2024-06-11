import 'package:demo_project/GetX%20Controller/navigationcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabNavigation extends StatelessWidget {
  const TabNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.put(NavigationController());

    Future<bool> showExitConfirmationDialog(BuildContext context) async {
      return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you really want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        ),
      ) ?? false;
    }

    Future<bool> onWillPop(BuildContext context) async {
      if (navigationController.history.length > 1) {
        // If there is more than one tab in the history, navigate to the previous tab
        navigationController.history.removeLast();
        navigationController.selectedIndex.value = navigationController.history.last;
        return false;
      } else {
        // If there is only one tab in the history (Home), show exit confirmation dialog
        bool exitApp = await showExitConfirmationDialog(context);
        return exitApp;
      }
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: navigationController.selectedIndex.value,
            onTap: (index) {
              if (navigationController.selectedIndex.value != index) {
                navigationController.history.add(index);
                navigationController.selectedIndex.value = index;
              }
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
      ),
    );
  }
}
