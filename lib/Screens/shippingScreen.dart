// ignore_for_file: file_names

import 'package:demo_project/Screens/checkoutScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_project/GetX%20Controller/cartController.dart';
import 'package:demo_project/GetX%20Controller/shippingControlle.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    final ShippingController shippingController = Get.find();

    // Select the first shipping method by default and run the onchange function
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shippingController.shippingMethodsData.isNotEmpty &&
          shippingController.shippingMethodTaxName.isEmpty) {
        final String firstOption =
            shippingController.shippingMethodsData[0]['shipping'].split(',')[0];
        final String firstOptionName = firstOption.split('||')[0];
        final String firstOptionValue = firstOption.split('||')[1];
        shippingController.shippingMethodTax.value = firstOptionValue;
        shippingController.shippingMethodTaxName.value = firstOptionName;
        shippingController.getEstimatedSalesTax();
      }
    });

    return Scaffold(
            backgroundColor: Colors.white,
      appBar: AppBar(
              backgroundColor: Colors.white,
        title: const Text(
          "Shipping",
          style: TextStyle(
              color: Color(0xFF292e7e),
              fontSize: 23,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 9,
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (cartController.isLoadingCartAPI.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return orderItemsSection(
                            context, cartController, shippingController);
                      }),
                      Obx(() {
                        if (shippingController.isLoadingShippingAPI.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return taxItemSection(context, shippingController);
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Obx(() {
                bool isShippingMethodSelected =
                    shippingController.shippingMethodTaxName.isNotEmpty;
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: ElevatedButton(
                    onPressed: isShippingMethodSelected
                        ? () {
                            // shippingController.fetchContinueToPayment();
                             Get.to(() => const CheckoutScreen());
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: isShippingMethodSelected
                          ? const Color(0xFFCC0001)
                          : Colors.grey,
                      disabledForegroundColor: Colors.grey.withOpacity(0.38),
                      disabledBackgroundColor:
                          Colors.grey.withOpacity(0.12), // Disabled color
                    ),
                    child: Text(
                      isShippingMethodSelected
                          ? "Continue to checkout"
                          : "Select Shipping Method",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget orderItemsSection(BuildContext context, CartController cartController,
    ShippingController shippingController) {
  return Container(
    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
    margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 251, 251, 253),
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.height * 0.03),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int index = 0; index < cartController.cartData.length; index++)
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFd2d5de),
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * 0.01),
            ),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.height * 0.09,
                  color: const Color.fromARGB(255, 251, 253, 249),
                  child: Image.network(
                    cartController.cartData[index]['product_image'],
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: Text(
                          cartController.cartData[index]['product_name'],
                          style: const TextStyle(
                            overflow: TextOverflow.fade,
                            fontSize: 14,
                            color: Color(0xFF292e7e),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "${cartController.cartData[index]['quantity']} * ${cartController.cartData[index]['product_price']}",
                        style: const TextStyle(fontSize: 15),
                      ),
                      Text(
                        "Total Price: \$${cartController.cartData[index]['total'].toString().length >= 5 ? cartController.cartData[index]['total'].toString().substring(0, 5) : cartController.cartData[index]['total'].toString()}",
                        style: const TextStyle(
                            fontSize: 15, color: Color(0xFF292e7e)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Divider(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.03,
          thickness: 2,
          indent: MediaQuery.of(context).size.height * 0.01,
          endIndent: MediaQuery.of(context).size.height * 0.01,
        ),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sub Total",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  "\$${cartController.totalAmount1.toString().length >= 5 ? cartController.totalAmount1.toString().substring(0, 5) : cartController.totalAmount1.toString()}",
                  style: const TextStyle(fontSize: 16, color: Color(0xFF292e7e)),
                )
              ],
            )),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Shipping Charge",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(shippingController.shippingMethodTax.isNotEmpty
                    ? "${shippingController.shippingMethodTax}"
                    : "-", // Display "-" if there is no value
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF292e7e)))
              ],
            )),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Estimated salesTax",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(shippingController.EstimatedSalesTax.toString().isNotEmpty
                    ? "\$${shippingController.EstimatedSalesTax.toString().length >= 5 ? shippingController.EstimatedSalesTax.toString().substring(0, 4) : shippingController.EstimatedSalesTax.toString()}"
                    : "-", // Display "-" if there is no value
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF292e7e)))
              ],
            )),
        Divider(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.03,
          thickness: 2,
          indent: MediaQuery.of(context).size.height * 0.01,
          endIndent: MediaQuery.of(context).size.height * 0.01,
        ),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(shippingController.NetAmount.toString().isNotEmpty
                    ? "\$${shippingController.NetAmount.toString().length >= 5 ? shippingController.NetAmount.toString().substring(0, 5) : shippingController.NetAmount.toString()}"
                    : "-", // Display "-" if there is no value
                    style: const TextStyle(
                        fontSize: 16, color: Color(0xFF292e7e)))
              ],
            )),
      ],
    ),
  );
}

Widget taxItemSection(BuildContext context, ShippingController shippingController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        child: const Text("Shipping Method",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff2a2e7e))),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 249, 250, 248),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Obx(
          () => shippingController.shippingMethodsData.isNotEmpty
              ? ListView.builder(
                  itemCount: shippingController.shippingMethodsData[0]
                          ['shipping']
                      .split(',')
                      .length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = shippingController
                        .shippingMethodsData[0]['shipping']
                        .split(',')[index];
                    final String optionName = option.split('||')[0];
                    final String optionValue = option.split('||')[1];

                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("United Parcel Service",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          ShippingOptionTile(
                            optionName: optionName,
                            optionValue: optionValue,
                          ),
                        ],
                      );
                    } else if (index == 4) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("United State Postal Service",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          ShippingOptionTile(
                            optionName: optionName,
                            optionValue: optionValue,
                          ),
                        ],
                      );
                    } else if (index == 5) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Store PickUp",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold)),
                          ),
                          ShippingOptionTile(
                            optionName: optionName,
                            optionValue: optionValue,
                          ),
                        ],
                      );
                    } else {
                      return ShippingOptionTile(
                        optionName: optionName,
                        optionValue: optionValue,
                      );
                    }
                  },
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    ],
  );
}

class ShippingOptionTile extends StatefulWidget {
  final String optionName;
  final String optionValue;

  const ShippingOptionTile({
    super.key,
    required this.optionName,
    required this.optionValue,
  });

  @override
  _ShippingOptionTileState createState() => _ShippingOptionTileState();
}

class _ShippingOptionTileState extends State<ShippingOptionTile> {
  final ShippingController shippingController = Get.put(ShippingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return RadioListTile(
        title: Text(widget.optionName,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF292e7e),
            )),
        value: widget.optionName,
        groupValue: shippingController.shippingMethodTaxName.value,
        onChanged: (String? value) {
          if (value != null) {
            shippingController.shippingMethodTax.value = widget.optionValue;
            shippingController.shippingMethodTaxName.value = value;
            shippingController.getEstimatedSalesTax();
          }
        },
        secondary: Text(widget.optionValue,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF292e7e),
            )),
      );
    });
  }
}
