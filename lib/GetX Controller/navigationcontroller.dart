import 'package:demo_project/Screens/cartScreen.dart';
import 'package:demo_project/Screens/homeScreen.dart';
import 'package:demo_project/Screens/profileScreen.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const HomeScreen(),
    const CartScreeen(),
    const ProfileScreen(),
  ];

  // History to keep track of the tab navigation
  final RxList<int> history = <int>[0].obs;

  void clear() {
    selectedIndex.value = 0;
    history.clear();
    history.add(0);
  }

  void resetNavigation() {
    selectedIndex.value = 0; // Set the home screen as the selected index
    history.clear(); // Clear the history
    history.add(0); // Add the home screen to the history
  }
}
