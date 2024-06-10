// ignore_for_file: file_names

import 'dart:convert';
import 'package:demo_project/GetX%20Controller/loginController.dart';
import 'package:demo_project/GetX%20Controller/shippingControlle.dart';
import 'package:demo_project/Screens/addressScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class AddressController extends GetxController{
  final LoginController loginController=Get.put(LoginController());
 // ignore: non_constant_identifier_names
 RxList<dynamic> AddressDatas = <dynamic>[].obs;
 // ignore: non_constant_identifier_names
 RxList<dynamic> Datas = <dynamic>[].obs;
var addressLoading=true.obs;
  

  
  Future<void> fetchOldAddress(context) async {
    
    String url = "https://www.texasknife.com/dynamic/texasknifeapi.php?action=get_checkoutship&customer_id=${loginController.userId}";
    addressLoading.value=true;
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    try {
      
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final body = res.body;
        final json = jsonDecode(body);
        AddressDatas.assign(json['data'][0]);
         addressLoading.value=false;
          Get.back();
           Get.to(()=>const addressScreen()); 
           
      }
    } catch (e) {
      // print('Error in fetchOldAddress: $e');
    }
  }

   Future<void> fetchInputAddress(Addressone addressone) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    String url =
        "https://www.texasknife.com/dynamic/texasknifeapi.php?action=insert_update_checkoutship&bill_name=${addressone.firstName1}&bill_l_name=${addressone.lastName1}&bill_address1=${addressone.address1}&bill_address2=${addressone.address2}&bill_town_city=${addressone.city1}&bill_state_region1=${addressone.state1}&bill_zip_code=${addressone.zipCode1}&bill_country=${addressone.country1}&bill_phone=${addressone.phoneNumber1}&bill_email1=${addressone.email1}&customer_id=88985&sessions_id=123456&rurl=&ship_amt=&tx_amount=&check_out_total_amount=&payment_type=&shipment_name=&bill_company=";
    try {
      var res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final body = res.body;
        final json = jsonDecode(body);
        Datas.assign(json['data'][0]);
        Get.back();
        
        // Access the shipping method using an instance
        ShippingController shippingController = Get.find<ShippingController>();
        shippingController.shipping();
      }
    } catch (e) {
      // Handle the error appropriately
    }
  }
}


