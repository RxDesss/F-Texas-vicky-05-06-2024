// ignore_for_file: file_names

import 'dart:convert';
import 'package:demo_project/Screens/myOrders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyOrderController extends GetxController {
  var orderList = [].obs;

  Future<void> getMyOrder(String userid) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    String url = "https://www.texasknife.com/dynamic/texasknifeapi.php?action=get_orders&customer_id=$userid";
    var res = await http.get(Uri.parse(url));
    print(res.statusCode);
    if (res.statusCode == 200) {
      final body = res.body;
      final json = jsonDecode(body);
      orderList.value = json['data'];
      Get.back();
      Get.to(() => const MyOrders());
    } else {
      Get.back();
      // Handle error here
      Get.snackbar('Error', 'Failed to load orders');
    }
  }

  void clear() {
    orderList.value=[];
  }
}
