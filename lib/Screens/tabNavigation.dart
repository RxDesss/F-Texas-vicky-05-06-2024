import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_project/GetX%20Controller/navigationcontroller.dart';

import '../GetX Controller/cartController.dart';

class TabNavigation extends StatelessWidget {
  const TabNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = Get.put(NavigationController());
    final CartController cartController=Get.put(CartController());

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
        navigationController.history.removeLast();
        navigationController.selectedIndex.value = navigationController.history.last;
        return false;
      } else {
        bool exitApp = await showExitConfirmationDialog(context);
        return exitApp;
      }
    }

    // Fetch the cart count initially
    cartController.getCartCount();

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
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "HOME",
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_cart),
                    Positioned(
                      right: 0,
                      child: Obx(() {
                        return cartController.cartItemCount.value > 0
                            ? Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${cartController.cartItemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Container();
                      }),
                    ),
                  ],
                ),
                label: "CART",
              ),
              const BottomNavigationBarItem(
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
