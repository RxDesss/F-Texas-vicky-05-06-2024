import 'package:demo_project/GetX%20Controller/cartController.dart';
import 'package:demo_project/GetX%20Controller/productdetailController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:flutter_html/flutter_html.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  final ProductDetailController productDetailContoller = Get.put(ProductDetailController());
  final CartController cartController = Get.put(CartController());

  String productName = '';
  String productSku = '';
  String productDescription = '';
  String productPrice = '';
  int productQuantity = 1;
  String imageUrl = '';
  String productId = '';
 
  void getData() {
    for (var obj in productDetailContoller.productDetailList) {
      setState(() {
        productName = obj['product_name'];
        productSku = obj['sku'];
        productDescription = obj['description'];
        productPrice = obj['product_price'];
        productId = obj['id'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imageUrl = productDetailContoller.imageUrl;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail',style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xff2a2e7e)),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 226, 224, 223),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Quantity",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2a2e7e)),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          productQuantity++;
                                        });
                                      },
                                      icon: const Icon(Icons.add)),
                                  Text('$productQuantity'),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (productQuantity > 1) {
                                            productQuantity--;
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.remove)),
                                ],
                              )
                            ],
                          ),
                          Obx(() {
                            return productDetailContoller.showButton.value
                                ? FloatingActionButton.extended(
                                    onPressed: () {
                                      cartController.getAddToCart(
                                        productId, productQuantity, productSku, productPrice, context
                                      );
                                    },
                                    icon: const Icon(Icons.add_shopping_cart,color: Colors.white,),
                                    label: const Text("Add To Cart",style: TextStyle(color: Colors.white),),
                                    backgroundColor: const Color.fromARGB(255, 243, 34, 34),
                                  )
                                : Container();
                          }),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        productName,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                           color: Color(0xff2a2e7e)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.greenAccent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(productSku),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Column(
                        children: [
                          const Text(
                            "Price :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2a2e7e)),
                          ),
                          Text("\$ $productPrice")
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description :",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff2a2e7e)),
                          ),
                          Text(
                            " ${productDescription.replaceAll(RegExp(r'<[^>]*>|<\/[^>]*>'), '')},",
                            textAlign: TextAlign.justify,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
