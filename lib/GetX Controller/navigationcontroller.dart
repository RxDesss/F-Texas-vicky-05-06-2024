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

  void clear() {}
}
