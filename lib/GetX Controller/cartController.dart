// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:demo_project/Common/commom.dart';
import 'package:demo_project/GetX%20Controller/loginController.dart';
import 'package:demo_project/GetX%20Controller/navigationcontroller.dart';
import 'package:demo_project/Screens/tabNavigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  RxBool isLoadingCartAPI = true.obs;
  List<dynamic> Data = [].obs;
  List<dynamic> cartData = [].obs;
  String Message = "";
  double totalAmount = 0.0;
  RxDouble totalAmount1 = 0.0.obs;
  RxInt cartItemCount=0.obs;


  Future<void> getAddToCart(
      productId, productQuantity, productSku, productPrice, context) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    String url =
        'https://www.texasknife.com/dynamic/texasknifeapi.php?action=cart&store_id=1&user_id=${loginController.userId}&product_id=$productId&product_det_qty=$productQuantity&get_cur_price=$productPrice&sku=$productSku&user_email=${loginController.userEmail}&session_ids=123456&based_on=Add';
    var res = await http.get(Uri.parse(url));
    Get.back();
    if (res.statusCode == 200) {
      final body = res.body;
      final json = jsonDecode(body);
      Data = json['data'];
      Comman.sucesstoast("Product Added Successfully");
      getCartCount();
 
                    final NavigationController navigationController =
                        Get.find<NavigationController>();
                    navigationController.resetNavigation();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const TabNavigation()), // Replace HomePage with your home screen widget
                      (Route<dynamic> route) => false,
                    );
     
    }
  }

  

  Future<List<Map<String, dynamic>>> getCartItems() async {
    // totalAmount1.value = 0.0; // Reset totalAmount
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=final_cart_details&store_id=1&customer_id=${loginController.userId}';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      getCartCount();
      final body = response.body;
      final json = jsonDecode(body);
      cartData = json['data'];
      isLoadingCartAPI.value = false;
      List<dynamic> data = json['data'];

      for (var item in data) {
        totalAmount = double.parse(item['total'].toString());
        totalAmount1.value = double.parse(item['total'].toString());
      }

      return List<Map<String, dynamic>>.from(data);
    } else {

      throw Exception('Failed to load cart items');
    }
  }

  Future<void> deleteCartItem(productID) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=remove_cart&customer_id=${loginController.userId}&session_id=123456&product_id=$productID';

    try {
      var response = await http.get(Uri.parse(url));
              
      if (response.statusCode == 200) {
        getCartCount();
        // Handle success
        Get.back();
        
      } else {
        Get.back();
        throw Exception('Failed to remove cart item: ${response.reasonPhrase}');
      }
    } catch (e) {
      Get.back();
      throw Exception('Failed to remove cart item: $e');
    }
  }

  Future<void> addProductQuantity(productID, total) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=sku&id=$productID';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
      //  getCartCount();
        final body = response.body;
        final json = jsonDecode(body);
        List<dynamic> data = json['data'];
        String sku = data[0]['sku'];
        var res = await http.get(Uri.parse("https://www.texasknife.com/dynamic/texasknifeapi.php?action=cart&store_id=1&user_id=${loginController.userId}&product_id=$productID&product_det_qty=1&get_cur_price=$total&sku=$sku&user_email=${loginController.userEmail}&session_ids=123456&based_on=Add"));
        if (res.statusCode == 200) {
          // Handle success
          Get.back();
        }
      } else {
        Get.back();
        throw Exception('Failed to add product quantity: ${response.reasonPhrase}');
      }
    } catch (e) {
      Get.back();
      throw Exception('Failed to add product quantity: $e');
    }
  }

  Future<void> minusProductQuantity(productID, total) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=sku&id=$productID';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // getCartCount();
        final body = response.body;
        final json = jsonDecode(body);
        List<dynamic> data = json['data'];
        String sku = data[0]['sku'];
        var res = await http.get(Uri.parse("https://www.texasknife.com/dynamic/texasknifeapi.php?action=cart&store_id=1&user_id=${loginController.userId}&product_id=$productID&product_det_qty=1&get_cur_price=$total&sku=$sku&user_email=${loginController.userEmail}&session_ids=123456&based_on=Minus"));
        if (res.statusCode == 200) {
          // Handle success
          Get.back();
        }
      } else {
        Get.back();
        throw Exception('Failed to subtract product quantity: ${response.reasonPhrase}');
      }
    } catch (e) {
      Get.back();
      throw Exception('Failed to subtract product quantity: $e');
    }
  }


  // Define a method to fetch cart details and update the count
  Future<void> getCartCount() async {
    String url = "https://www.texasknife.com/dynamic/texasknifeapi.php?action=final_cart_details&store_id=1&customer_id=88985";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final body = response.body;
        final json = jsonDecode(body);
        List<dynamic> data = json['data'];
        // Set the count of items in the data array
        cartItemCount.value = data.length;
      } else {
        // Handle the case where the response status is not 200
        // print('Failed to load cart details');
      }
    } catch (error) {
      // Handle any errors that occur during the request
      // print('Error fetching cart details: $error');
    }
  }
}

