import 'dart:convert';
import 'package:demo_project/Screens/noCategoryScreen.dart';
import 'package:demo_project/Screens/subCategoyScreen.dart';
import 'package:demo_project/Screens/subsubCategoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


class HomeController extends GetxController {
  var featureProductList = [].obs;
  var categoryProductList = [].obs;
  var noCategoryData = [].obs;
  var subCategoryData = [].obs;
  var subSubCategoryData = [].obs;
  var isLoading = false.obs;
  var isScanning = false.obs; // New observable for scanning

  String productCategoryName = '';

  Future<void> fetchData(context) async {
    isLoading.value = true;
    await fetchFeatureApi();
    await fetchCategoryApi();
    isLoading.value = false;
  }

  Future<void> fetchFeatureApi() async {
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=cus_featured_product';
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      featureProductList.value = json['data'];
    }
  }

  Future<void> fetchCategoryApi() async {
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=cus_category';
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      categoryProductList.value = json['data'];
    }
  }

  Future<void> getSubList(BuildContext context, String categoryId, String categoryName) async {
    productCategoryName = categoryName;
    subCategoryData.assign([]);
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    String url = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=cus_sub_category&category_id=$categoryId';
    var res = await http.get(Uri.parse(url));
    Get.back();
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      subCategoryData.assign(json['data']);
      Get.to(() => const SubCategoryScreen(), arguments: categoryName);
    } else {
      String noProductUrl = 'https://www.texasknife.com/dynamic/texasknifeapi.php?action=cus_category_product&category=$categoryName';
      var response = await http.get(Uri.parse(noProductUrl));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        noCategoryData.assign(json['data']);
      }
      Get.to(() => const NoCategoryPage(), arguments: categoryName);
    }
  }

  Future<void> getSubSubCategory(BuildContext context, String productSubCategoryName) async {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
    subSubCategoryData.assign([]);
    String url = "https://www.texasknife.com/dynamic/texasknifeapi.php?action=cus_subcategory_product&category=$productCategoryName&sub_category=$productSubCategoryName";
    var res = await http.get(Uri.parse(url));
    Get.back();
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      subSubCategoryData.assign(json['data']);
      Get.to(() => const SubSubCategoryPage(), arguments: productSubCategoryName);
    }
  }
}
