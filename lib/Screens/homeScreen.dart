// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:demo_project/GetX%20Controller/homeController.dart';
import 'package:demo_project/GetX%20Controller/loginController.dart';
import 'package:demo_project/GetX%20Controller/productdetailController.dart';
import 'package:demo_project/GetX%20Controller/searchproductController.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final LoginController loginController = Get.put(LoginController());
final HomeController homeController = Get.put(HomeController());
final ProductDetailController productDetailContoller = Get.put(ProductDetailController());
final SearchProductController searchProductController = Get.put(SearchProductController());

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  List<String> apiproductNames = [];
  List<String> apiproductPrice = [];
  List<String> apiproductImage = [];
  List<String> apicategoryName = [];
  List<String> apicategoryImage = [];
  List<String> apicategorysku = [];
  List<String> id = [];
  List<String> apicategoryId = [];

  void getProductDetail(String id) {
    productDetailContoller.getProductDetail(id);
  }

  void getData() {
    for (var obj in loginController.loginList) {
      setState(() {
        userName = obj['user_name'];
      });
    }
  }

  void getFeatureProduct() {
    for (var obj in homeController.featureProductList) {
      setState(() {
        apiproductPrice.add(obj['product_price']);
        apiproductNames.add(obj['product_name']);
        apiproductImage.add(obj['product_image']);
        apicategorysku.add(obj['sku']);
        id.add(obj["id"]);
      });
    }
  }

  void getCategoryProduct() {
    for (var obj in homeController.categoryProductList) {
      setState(() {
        apicategoryName.add(obj['name']);
        apicategoryImage.add(obj['image']);
        apicategoryId.add(obj['id']);
      });
    }
  }

  List<String> imageList = [
    'https://cdn.pixabay.com/photo/2015/12/11/17/51/knife-1088529_1280.png',
    'https://images.pexels.com/photos/168804/pexels-photo-168804.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/365631/pexels-photo-365631.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/39011/paprika-vegetables-snack-vegetables-cut-39011.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    // Add more image URLs here
  ];

  @override
  void initState() {
    super.initState();
    getData();
    homeController.fetchData(context); // Ensure you call the method to fetch category products
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (homeController.isScanning.value) { // Show scanning loader if scanning
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                header(context, userName),
                search(context),
                Obx(() => featureProducts(context, homeController.featureProductList, getProductDetail)),
                Obx(() => categoryProduct(context, homeController.categoryProductList)),
              ],
            ),
          );
        }
      }),
    ),
  );
}


  Widget header(BuildContext context, String? userName) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello',
                style: TextStyle(fontSize: 20, color: Color(0xff2a2e7e)),
              ),
              Text(
                "$userName",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.030,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff2a2e7e)),
              ),
            ],
          ),
          Image.asset(
            'assets/TexasImage.png',
            width: MediaQuery.of(context).size.width * 0.12,
            height: MediaQuery.of(context).size.height * 0.07,
          ),
        ],
      ),
    );
  }
}

Widget search(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.42,
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(const Color(0xff2a2e7e)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
            ),
            onPressed: () {
              searchProductController.fetchAllProduct();
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search, size: 20.0),
                SizedBox(width: 4),
                Text(
                  'Search Product',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
          width: MediaQuery.of(context).size.width * 0.42,
          child: TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(const Color(0xff2a2e7e)),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.black12),
            ),
            onPressed: scanBarcodeNormal,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt, size: 20.0),
                SizedBox(width: 4),
                Text(
                  'Scan Code',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}


Widget featureProducts(BuildContext context, List<dynamic> featureProducts, Function getProductDetail) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 10, top: 10, left: 20),
        child: Text(
          "Feature Products ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff2a2e7e)),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: featureProducts.length,
          itemBuilder: (context, index) {
            var product = featureProducts[index];
            return InkWell(
              onTap: () {
                getProductDetail(product['sku']);
                productDetailContoller.showButton.value = true;
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.40,
                margin: EdgeInsets.only(left: 10.0, right: index == featureProducts.length - 1 ? 10.0 : 0),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: CachedNetworkImage(
                        imageUrl: product['product_image'],
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.13,
                        height: MediaQuery.of(context).size.height * 0.022,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(
                              "\$${product['product_price']}",
                              style: const TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.068,
                        child: Center(
                          child: Text(
                            product['product_name'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget categoryProduct(BuildContext context, List<dynamic> categoryProducts) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10, top: 10, left: 10),
          child: Text(
            "Products Categories",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xff2a2e7e)),
          ),
        ),
        SizedBox(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              mainAxisExtent: MediaQuery.of(context).size.height * 0.17,
            ),
            itemCount: categoryProducts.length,
            itemBuilder: ((context, index) {
              var category = categoryProducts[index];
              return InkWell(
                onTap: () {
                  homeController.getSubList(context, category['id'], category['name']);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              category['name'],
                              style: const TextStyle(color: Color(0xff2a2e7e)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: CachedNetworkImage(
                            imageUrl: category['image'],
                            fit: BoxFit.fill,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        )
      ],
    ),
  );
}

Future<void> scanBarcodeNormal() async {
  String barcodeScanRes;
  try {
    homeController.isScanning.value = true; // Set scanning to true
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    homeController.isScanning.value = false; // Set scanning to false

    if (barcodeScanRes != '-1') { // Check if not cancelled
      productDetailContoller.getProductDetail(barcodeScanRes);
    }
  } on PlatformException {
    barcodeScanRes = "Failed to get platform version";
    homeController.isScanning.value = false; // Set scanning to false in case of error
  }
}

