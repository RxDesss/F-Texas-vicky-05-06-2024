// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaymentCotroller extends GetxController{
     
  RxList<dynamic> paymentApiData = <dynamic>[].obs;
  
   Future<void> fetchPayment()async{
    String url='';
    try{
       var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final body = res.body;
        final json = jsonDecode(body);
        paymentApiData.assign(json['data']);
      }
    } catch (e) {
      // print('Error in fetchPayment: $e');

    }
   }  
   Future<void> navigation(context)async{
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
  //  print("Hello");
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=cus_featured_product';
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      // print("api");
      Get.back();
      Navigator.pushReplacementNamed(context, '/checkout');

    }
   } 

  //  void navigation(){
  //   Get.to(() => const CheckoutScreen());
  //  }
}