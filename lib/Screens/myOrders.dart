// ignore_for_file: file_names

import 'package:demo_project/GetX%20Controller/loginController.dart';
import 'package:demo_project/GetX%20Controller/myorderController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final LoginController loginController = Get.put(LoginController());
  final MyOrderController myOrderController = Get.put(MyOrderController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myOrderController.getMyOrder(loginController.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Order",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xff2a2e7e)),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (myOrderController.orderList.isEmpty) {
            return const Center(child: Text("No orders found"));
          } else {
            return SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: ListView.builder(
                    itemCount: myOrderController.orderList.length,
                    itemBuilder: (context, index) {
                      var order = myOrderController.orderList[index];
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.20,
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: MediaQuery.of(context).size.height * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 158, 168, 224),
                          borderRadius: BorderRadius.only(bottomRight:Radius.circular( MediaQuery.of(context).size.height * 0.1)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left:10,right:10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Order ID"),
                                      const Text(":"),
                                    Text(order['order_id']),
                                  ],
                                ),
                                Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Order Date"),
                                    const Text(":"),
                                    Text(order['created_at']),
                                  ],
                                ),
                                Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text("Net Amount"),
                                      const Text(":"),
                                    Text(" ${order['net_amount']}"),
                                   
                                  ],
                                ),
                                 SizedBox(
                                      height: MediaQuery.of(context).size.width * 0.04 ,
                                    ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width * 0.15,
                                      right:
                                          MediaQuery.of(context).size.width * 0.15),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFCC0000), // Set the background color
                                    ),
                                    onPressed: () {
                                            myOrderController.getInvoice(order['order_id']);
                                    },
                                    child: const Text("Invoice",style: TextStyle(color: Colors.white),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
