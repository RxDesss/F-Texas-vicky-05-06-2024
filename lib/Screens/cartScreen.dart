import 'package:demo_project/GetX%20Controller/addressControlle.dart';
import 'package:demo_project/GetX%20Controller/cartController.dart';
import 'package:demo_project/GetX%20Controller/productdetailController.dart';
import 'package:demo_project/GetX%20Controller/shippingControlle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreeen extends StatefulWidget {
  const CartScreeen({super.key});

  @override
  State<CartScreeen> createState() => _CartScreeenState();
}

class _CartScreeenState extends State<CartScreeen> {
  final CartController cartController = Get.put(CartController());
  final ProductDetailController productDetailContoller = Get.put(ProductDetailController());
  final ShippingController shippingController = Get.put(ShippingController());
     final AddressController addressControlle = Get.put(AddressController());
  late Future<List<Map<String, dynamic>>> _futureCartData;

  void _fetchCartData() {
    _futureCartData = cartController.getCartItems();
    _futureCartData.catchError((error) {
      // Handle the error accordingly
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCartData();
  }

  void _showDeleteConfirmationDialog(BuildContext context, int itemId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this item from your cart?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                cartController.deleteCartItem(itemId).then((_) => setState(_fetchCartData));
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff2a2e7e))),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureCartData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 100,
                            color: Colors.grey,
                          ),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        final itemId = int.parse(item['id'].toString());
                        final itemQuantity = int.parse(item['quantity'].toString());
                        final itemTotal = double.parse(item['total'].toString());

                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 158, 168, 224),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(10),
                                      height: MediaQuery.of(context).size.height * 0.10,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blueGrey[50],
                                      ),
                                      child: Image.network(
                                        item['product_image'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.03,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            iconSize: 18.0,
                                            onPressed: () {
                                              cartController
                                                  .minusProductQuantity(itemId, itemTotal)
                                                  .then((_) => setState(_fetchCartData));
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                          Text(itemQuantity.toString()),
                                          IconButton(
                                            iconSize: 18.0,
                                            onPressed: () {
                                              cartController
                                                  .addProductQuantity(itemId, itemTotal)
                                                  .then((_) => setState(_fetchCartData));
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      height: MediaQuery.of(context).size.height * 0.15,
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            height: MediaQuery.of(context).size.height * 0.05,
                                            child: Text(
                                              item['product_name'],
                                              style: const TextStyle(
                                                overflow: TextOverflow.fade,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "Quantity : ",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Text(itemQuantity.toString()),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "TotalPrice : ",
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                              Text("\$ ${itemTotal.toStringAsFixed(2)}"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.info),
                                      onPressed: () {
                                        productDetailContoller.getProductDetail1(itemId);
                                        productDetailContoller.showButton.value = false;
                                      },
                                      color: const Color.fromARGB(255, 6, 104, 11),
                                      iconSize: 20.0,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _showDeleteConfirmationDialog(context, itemId);
                                      },
                                      color: const Color.fromARGB(255, 243, 34, 34),
                                      iconSize: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Sub Total - ",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff2a2e7e)),
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _futureCartData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text("...loading", style: TextStyle(color: Colors.red));
                            } else {
                              double totalAmount = 0;
                              if (snapshot.hasData) {
                                for (var item in snapshot.data!) {
                                  totalAmount += double.parse(item['total'].toString());
                                }
                              }
                              return Text(
                                "\$ ${totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureCartData,
                    builder: (context, snapshot) {
                      bool isCartEmpty = snapshot.hasData && snapshot.data!.isEmpty;
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        decoration: BoxDecoration(
                          color: isCartEmpty ? Colors.grey : const Color(0xFFCC0000),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextButton(
                          onPressed:isCartEmpty ? null :()async{await addressControlle.fetchOldAddress(context);
                         },
                          child: const Text("Proceed to Checkout", style: TextStyle(color: Colors.white)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
