import 'package:demo_project/GetX%20Controller/cartController.dart';
import 'package:demo_project/GetX%20Controller/paymentController.dart';
import 'package:demo_project/GetX%20Controller/shippingControlle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_paypal/flutter_paypal.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ShippingController shippingController = Get.put(ShippingController());
  final CartController cartController = Get.put(CartController());
  final PaymentCotroller paymentCotroller=Get.put(PaymentCotroller());

  bool showCardFields = false;
  bool showMoneyOrderField = false;
  bool showCheckNumberField = false;
  bool isAnyCheckboxSelected = false;

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController ccvController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController moneyOrderController = TextEditingController();
  final TextEditingController checkNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void updateCheckboxState() {
    setState(() {
      isAnyCheckboxSelected =
          showCardFields || showMoneyOrderField || showCheckNumberField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff292e7e),
            fontSize: 23,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ImageContainer(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Form(
                key: _formKey,
                child: PaymentContainer(
                  showCardFields: showCardFields,
                  showMoneyOrderField: showMoneyOrderField,
                  showCheckNumberField: showCheckNumberField,
                  cardNumberController: cardNumberController,
                  ccvController: ccvController,
                  endDateController: endDateController,
                  moneyOrderController: moneyOrderController,
                  checkNumberController: checkNumberController,
                  onCardCheckboxChanged: (value) {
                    setState(() {
                      showCardFields = value ?? false;
                      if (showCardFields) {
                        showMoneyOrderField = false;
                        showCheckNumberField = false;
                      }
                      updateCheckboxState();
                    });
                  },
                  onMoneyOrderCheckboxChanged: (value) {
                    setState(() {
                      showMoneyOrderField = value ?? false;
                      if (showMoneyOrderField) {
                        showCardFields = false;
                        showCheckNumberField = false;
                      }
                      updateCheckboxState();
                    });
                  },
                  onCheckNumberCheckboxChanged: (value) {
                    setState(() {
                      showCheckNumberField = value ?? false;
                      if (showCheckNumberField) {
                        showCardFields = false;
                        showMoneyOrderField = false;
                      }
                      updateCheckboxState();
                    });
                  },
                  cartController: cartController,
                  shippingController:shippingController,
                  paymentCotroller:paymentCotroller,
                  
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                width: double.infinity,
                height: 50,
                margin:
                    EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.withOpacity(0.5);
                      }
                      return const Color(0xFFCC0001);
                    }),
                  ),
                  onPressed: isAnyCheckboxSelected
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            if (showCardFields) {
                              shippingController.fetchPayment("Credit Card");
                              shippingController.PayWith.value = "Credit Card";
                            } else if (showMoneyOrderField) {
                              shippingController.fetchPayment("Money Order");
                              shippingController.PayWith.value = "Money Order";
                            } else if (showCheckNumberField) {
                              shippingController.fetchPayment("Cheque");
                              shippingController.PayWith.value = "Cheque";
                            }
                          }
                        }
                      : null,
                  child: const Text('Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.22,
      child: Image.asset("assets/card.png", fit: BoxFit.cover),
    );
  }
}

class PaymentContainer extends StatelessWidget {
  final bool showCardFields;
  final bool showMoneyOrderField;
  final bool showCheckNumberField;
  final TextEditingController cardNumberController;
  final TextEditingController ccvController;
  final TextEditingController endDateController;
  final TextEditingController moneyOrderController;
  final TextEditingController checkNumberController;
  final ValueChanged<bool?>? onCardCheckboxChanged;
  final ValueChanged<bool?>? onMoneyOrderCheckboxChanged;
  final ValueChanged<bool?>? onCheckNumberCheckboxChanged;
  final CartController cartController;
  final ShippingController shippingController;
  final PaymentCotroller paymentCotroller;

  const PaymentContainer({
    super.key,
    required this.showCardFields,
    required this.showMoneyOrderField,
    required this.showCheckNumberField,
    required this.cardNumberController,
    required this.ccvController,
    required this.endDateController,
    required this.moneyOrderController,
    required this.checkNumberController,
    required this.onCardCheckboxChanged,
    required this.onMoneyOrderCheckboxChanged,
    required this.onCheckNumberCheckboxChanged,
    required this.cartController,
    required this.shippingController,
    required this.paymentCotroller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CheckboxListTile(
          title: const Text(
            'Credit Card',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF292e7e),
            ),
          ),
          value: showCardFields,
          onChanged: onCardCheckboxChanged,
        ),
        if (showCardFields)
          PaymentFieldContainer(
            children: [
              TextFormField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Card Number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: ccvController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: const InputDecoration(
                  labelText: 'CCV',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter CCV';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: endDateController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  _DateInputFormatter(),
                  LengthLimitingTextInputFormatter(7),
                ],
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter End Date';
                  }
                  return null;
                },
              ),
            ],
          ),
        CheckboxListTile(
          title: const Text('Money Order',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF292e7e),
              )),
          value: showMoneyOrderField,
          onChanged: onMoneyOrderCheckboxChanged,
        ),
        if (showMoneyOrderField)
          PaymentFieldContainer(
            children: [
              TextFormField(
                controller: moneyOrderController,
                decoration: const InputDecoration(
                  labelText: 'Money Order',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Money Order';
                  }
                  return null;
                },
              ),
            ],
          ),
        CheckboxListTile(
          title: const Text('Check Number',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF292e7e),
              )),
          value: showCheckNumberField,
          onChanged: onCheckNumberCheckboxChanged,
        ),
        if (showCheckNumberField)
          PaymentFieldContainer(
            children: [
              TextFormField(
                controller: checkNumberController,
                decoration: const InputDecoration(
                  labelText: 'Cheque Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Cheque Number';
                  }
                  return null;
                },
              ),
            ],
          ),
        paypalButton(context, cartController,shippingController,paymentCotroller),
      ],
    );
  }
}

Widget paypalButton(BuildContext context, CartController cartController, ShippingController shippingController,paymentCotroller ) {
  return TextButton(
    onPressed: () {
      Get.to(UsePaypal(
        sandboxMode: true,
        clientId: "AY3yVdV6nydXDqIigklXFR9go5Hq8YoczITLIpnBtYPXiRv5KUoAzuGUIEjhRJVlxgU4Z3wrhzLcu14m",
        secretKey: "EJksZ0Z6GERBfvesI9agBVCqH1TZ2RskyvRT3AuuyaAhb45B4Kr0hqxrGNQloUJ-FbROljK5d-4-wvny",
        returnURL: "https://samplesite.com/return",
        cancelURL: "https://samplesite.com/cancel",
        transactions: [
          {
            "amount":  {
              "total": shippingController.NetAmount.toString().substring(0, 4),
              "currency": "USD",
              "details": {
                "subtotal": shippingController.NetAmount.toString().substring(0, 4),
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "The payment transaction description.",
            "item_list": {
              "items": [
                {
                  "name": "You will buy ${cartController.cartItemCount.value} products",
                  "quantity": 1,
                  "price": shippingController.NetAmount.toString().substring(0, 4),
                  "currency": "USD"
                }
              ],
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          // print("onSuccess: $params");
   paymentCotroller.navigation(context);
        },
        onError: (error) {
          // print("onError: $error");
        },
        onCancel: (params) {
          // print('cancelled: $params');
        },
      ));
    },
    child: const Text("Pay with Paypal"),
  );
}


class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = _formatInput(newValue.text);
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  String _formatInput(String input) {
    final strippedInput = input.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < strippedInput.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(strippedInput[i]);
    }
    return buffer.toString();
  }
}

class PaymentFieldContainer extends StatelessWidget {
  final List<Widget> children;

  const PaymentFieldContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: Column(children: children),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String validationMessage;
  final List<TextInputFormatter> inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validationMessage,
    required TextInputType keyboardType,
    this.inputFormatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PaymentScreen()));
}
