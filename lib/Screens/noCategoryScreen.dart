// ignore_for_file: file_names

import 'package:demo_project/GetX%20Controller/homeController.dart';
import 'package:demo_project/GetX%20Controller/productdetailController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoCategoryPage extends StatefulWidget {
  const NoCategoryPage({super.key});

  @override
  State<NoCategoryPage> createState() => _NoCategoryPageState();
}

class _NoCategoryPageState extends State<NoCategoryPage> {
  final HomeController homeController = Get.put(HomeController());
  final ProductDetailController productDetailController = Get.put(ProductDetailController());
final data=Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,
      appBar: AppBar(
              backgroundColor: Colors.white,
 title: Text(data.toString(),style: const TextStyle(fontWeight: FontWeight.bold,color:Color(0xff2a2e7e)),),        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () {
            if (homeController.noCategoryData.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return noCategoryWidget(context, homeController, productDetailController);
            }
          },
        ),
      ),
    );
  }
}

Widget noCategoryWidget(BuildContext context, HomeController homeController, ProductDetailController productDetailController) {
  return Obx(() => ListView.builder(
    itemCount: homeController.noCategoryData.length,
    itemBuilder: (context, index) {
      final itemsList = homeController.noCategoryData[index];
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemsList.length,
        itemBuilder: (context, itemIndex) {
          final item = itemsList[itemIndex];
          return InkWell(
            onTap: () {
              productDetailController.getProductDetail1(item["id"]);
              productDetailController.showButton.value=true;
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.14,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color(0xddd2d5de),
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.02)
                      ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.12,
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: item["product_image"] != null 
                      ? Image.network(
                          item["product_image"],
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                        )
                      : const Center(child: Text('No image')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Text(
                            item["product_name"] ?? '',
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Color(0xff2a2e7e)),
                          ),
                        ),
                        const SizedBox(height: 4,),
                        Text("\$${item["product_price"] ?? ''}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  ));
}
