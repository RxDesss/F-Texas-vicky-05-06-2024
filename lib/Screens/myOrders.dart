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
        title: const Text(
          "My Order",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff2a2e7e)),
        ),
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
                          color: const Color(0xddd2d5de),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.03),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Table(
                                  columnWidths: const {
                                    0: FlexColumnWidth(),
                                    1: FixedColumnWidth(10),
                                    2: FlexColumnWidth(),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        const Text(
                                          "Order ID",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          ":",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text(order['order_id']),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Text(
                                          "Order Date",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          ":",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text(order['created_at']),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        const Text(
                                          "Net Amount",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        const Text(
                                          ":",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                        Text(" ${order['net_amount']}"),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.04,
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width * 0.15,
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFFCC0000),
                                    ),
                                    onPressed: () {
                                      myOrderController.getInvoice(order['order_id']);
                                    },
                                    child: const Text(
                                      "Invoice",
                                      style: TextStyle(color: Colors.white),
                                    ),
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
