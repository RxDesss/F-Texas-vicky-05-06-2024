import 'package:demo_project/GetX%20Controller/shippingControlle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final ShippingController shippingController = Get.put(ShippingController());

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
      isAnyCheckboxSelected = showCardFields || showMoneyOrderField || showCheckNumberField;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment",style: TextStyle(fontWeight: FontWeight.bold,color:Color(0xff2a2e7e)),),
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
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey.withOpacity(0.5);
                      }
                      return const Color(0xFFCC0000);
                    }),
                  ),
                  onPressed: isAnyCheckboxSelected ? () {
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
                  } : null,
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CheckboxListTile(
          title: const Text('Credit Card'),
          value: showCardFields,
          onChanged: onCardCheckboxChanged,
        ),
        if (showCardFields)
          PaymentFieldContainer(
            children: [
              CustomTextFormField(
                controller: cardNumberController,
                labelText: 'Card Number',
                validationMessage: 'Please enter Card Number',
              ),
              CustomTextFormField(
                controller: ccvController,
                labelText: 'CCV',
                validationMessage: 'Please enter CCV',
              ),
              CustomTextFormField(
                controller: endDateController,
                labelText: 'End Date',
                validationMessage: 'Please enter End Date',
              ),
            ],
          ),
        CheckboxListTile(
          title: const Text('Money Order'),
          value: showMoneyOrderField,
          onChanged: onMoneyOrderCheckboxChanged,
        ),
        if (showMoneyOrderField)
          PaymentFieldContainer(
            children: [
              CustomTextFormField(
                controller: moneyOrderController,
                labelText: 'Money Order',
                validationMessage: 'Please enter Money Order',
              ),
            ],
          ),
        CheckboxListTile(
          title: const Text('Check Number'),
          value: showCheckNumberField,
          onChanged: onCheckNumberCheckboxChanged,
        ),
        if (showCheckNumberField)
          PaymentFieldContainer(
            children: [
              CustomTextFormField(
                controller: checkNumberController,
                labelText: 'Cheque Number',
                validationMessage: 'Please enter Cheque Number',
              ),
            ],
          ),
      ],
    );
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
      decoration: const BoxDecoration(
       color: Color.fromARGB(255, 158, 168, 224),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String validationMessage;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validationMessage,
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
