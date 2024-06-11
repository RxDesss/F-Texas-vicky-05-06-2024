// ignore_for_file: file_names, non_constant_identifier_names

import 'package:demo_project/GetX%20Controller/addressControlle.dart';
import 'package:demo_project/GetX%20Controller/cartController.dart';
import 'package:demo_project/GetX%20Controller/shippingControlle.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.put(CartController());
  final ShippingController shippingController = Get.put(ShippingController());
  final AddressController addressController = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout",style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF292e7e),),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 13,
              child: Content(context, cartController, shippingController, addressController),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20), // Add padding to the bottom
              child: CheckoutButton(shippingController, context),
            ),
          ],
        ),
      ),
    );
  }
}


Widget Content(BuildContext context, CartController cartController, ShippingController shippingController, AddressController addressController) {
  return SingleChildScrollView(
    child: Column(
      children: [
        OrderItemsSection(context, cartController, shippingController),
        AddressMethodPayWithSection(context, cartController, shippingController, addressController),
      ],
    ),
  );
}

Widget OrderItemsSection(BuildContext context, CartController cartController, ShippingController shippingController) {
  return Container(
    padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
    margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
    decoration: BoxDecoration(
     color:const Color.fromARGB(255, 249, 249, 252),
      borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.03),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          spreadRadius: 0,
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
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            decoration:  BoxDecoration(
              color:const Color(0xFFd2d5de),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.01),
            ),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.height * 0.09,
                  color:const Color.fromARGB(255, 251, 253, 249),
                  child: Image.network(
                    cartController.cartData[index]['product_image'],
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        height: MediaQuery.of(context).size.height * 0.05,
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
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "Total Price: \$${cartController.cartData[index]['total'].toString().substring(0, 3)}",
                        style: const TextStyle(
                          fontSize: 15, color: Color(0xFF292e7e),
                        ),
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
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sub Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("\$ ${cartController.totalAmount1.toString().substring(0, 3)}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            ],
          ),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Shipping Charge",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("${shippingController.shippingMethodTax}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            ],
          ),
        ),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Estimated salesTax",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("\$ ${shippingController.EstimatedSalesTax.toString().substring(0, 5)}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
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
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("\$ ${shippingController.NetAmount.toString().substring(0, 5)}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget AddressMethodPayWithSection(BuildContext context, CartController cartController, ShippingController shippingController, AddressController addressController) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Contact",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(addressController.AddressDatas[0]['bill_email1'],style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
          ],
        ),
        const DividerWidget(),
        RepeatAddress(context, addressController, "Shipping To",),
        const DividerWidget(),
        RepeatAddress(context, addressController, "Billing To"),
        const DividerWidget(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Pay With",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('${shippingController.PayWith}',style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
          ],
        ),
      ],
    ),
  );
}

Widget RepeatAddress(BuildContext context, AddressController addressController, String heading) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(heading,style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      Container(
        width: MediaQuery.of(context).size.width * 0.5,
        alignment: Alignment.centerRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${addressController.AddressDatas[0]['bill_name']}",style: const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            Text("${addressController.AddressDatas[0]['bill_l_name']}",style: const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            Text("${addressController.AddressDatas[0]['bill_address1']}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            Text("${addressController.AddressDatas[0]['bill_address2']}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            Text("${addressController.AddressDatas[0]['bill_town_city']}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            Text("${addressController.AddressDatas[0]['bill_state_region1']}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            Text("${addressController.AddressDatas[0]['bill_country']}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
            Text("${addressController.AddressDatas[0]['bill_zip_code']}",style:const TextStyle(fontSize: 16, color: Color(0xFF292e7e))),
          ],
        ),
      ),
    ],
  );
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.black,
      height: MediaQuery.of(context).size.height * 0.03,
      thickness: 2,
      indent: MediaQuery.of(context).size.height * 0.01,
      endIndent: MediaQuery.of(context).size.height * 0.01,
    );
  }
}

Widget CheckoutButton(ShippingController shippingController, BuildContext context) {
  return Container(
    width: double.infinity,
    height: 50,
    margin: const EdgeInsets.symmetric(horizontal: 30),
    decoration: BoxDecoration(
      color:const Color(0xFFCC0000),
      borderRadius: BorderRadius.circular(25),
    ),
    child: TextButton(
      onPressed: () {
        shippingController.fetchPlaceOrder(context);
      },
      child: const Text("Place Order",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
    ),
  );
}
