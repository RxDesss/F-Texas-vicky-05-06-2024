// ignore_for_file: camel_case_types

import 'package:demo_project/GetX%20Controller/addressControlle.dart';
import 'package:demo_project/Screens/shippingScreen.dart';
import 'package:demo_project/Screens/cartScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Address {
  String firstName;
  String lastName;
  String address;
  String city;
  String country;
  String state;
  String zipCode;
  String phoneNumber;

  Address({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.country,
    required this.state,
    required this.zipCode,
    required this.phoneNumber,
  });
}

class Addressone {
  String email1;
  String firstName1;
  String lastName1;
  String address1;
  String address2;
  String city1;
  String country1;
  String state1;
  String zipCode1;
  String phoneNumber1;

  Addressone({
    required this.email1,
    required this.firstName1,
    required this.lastName1,
    required this.address1,
    required this.address2,
    required this.city1,
    required this.country1,
    required this.state1,
    required this.zipCode1,
    required this.phoneNumber1,
  });
}

class addressScreen extends StatefulWidget {
  const addressScreen({super.key});

  @override
  State<addressScreen> createState() => _addressScreenState();
}

class _addressScreenState extends State<addressScreen> {
  String? userName;
  // String? email;
  int? _selectedValue = 0;

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final List<TextEditingController> _textControllers =
      List.generate(17, (_) => TextEditingController());

  final AddressController addressControlle = Get.put(AddressController());

  void submitForm() async {
    if (_selectedValue == 1) {
      if (_formKey1.currentState != null) {
        if (_formKey1.currentState!.validate()) {
          Addressone addressone = Addressone(
            email1: addressControlle.AddressDatas[0]['bill_email1'],
            firstName1: addressControlle.AddressDatas[0]['bill_name'],
            lastName1: addressControlle.AddressDatas[0]['bill_l_name'],
            address1: addressControlle.AddressDatas[0]['bill_address1'],
            address2: addressControlle.AddressDatas[0]['bill_address2'],
            city1: addressControlle.AddressDatas[0]['bill_town_city'],
            country1: addressControlle.AddressDatas[0]['bill_country'],
            state1: addressControlle.AddressDatas[0]['bill_state_region1'],
            zipCode1: addressControlle.AddressDatas[0]['bill_zip_code'],
            phoneNumber1: addressControlle.AddressDatas[0]['bill_phone'],
          );
          addressControlle.fetchInputAddress(addressone);
        }
      } else {
        // print('Form state is null for form 1');
      }
    } else if (_selectedValue == 2) {
      if (_formKey2.currentState != null) {
        if (_formKey2.currentState!.validate()) {
          Addressone addressone = Addressone(
            firstName1: _textControllers[0].text,
            lastName1: _textControllers[1].text,
            address1: _textControllers[2].text,
            city1: _textControllers[3].text,
            country1: _textControllers[4].text,
            state1: _textControllers[5].text,
            zipCode1: _textControllers[6].text,
            phoneNumber1: _textControllers[7].text,
            email1: '',
            address2: '',
          );
          addressControlle.fetchInputAddress(addressone);
          Get.to(() => const ShippingScreen());
        }
      } else {
        // print('Form state is null for form 2');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Address"),
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back), // Wrap the icon with Icon widget
            onPressed: () {
              Get.to(() => const CartScreeen());
            },
          ),
          centerTitle: true,
        ),
        body: Form(
          child: SafeArea(
            child: Obx(
              () => addressControlle.addressLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: true,
                                  child: Form(
                                    key: _formKey1,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Contact Information",
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              initialValue:
                                                  "${addressControlle.AddressDatas[0]['bill_email1']}",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Email';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Email"),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Shipping Address',
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    initialValue:
                                                        "${addressControlle.AddressDatas[0]['bill_name']}",
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your name';
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                "FirstName"),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    initialValue:
                                                        "${addressControlle.AddressDatas[0]['bill_l_name']}",
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your name';
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText:
                                                                "LastName"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              initialValue:
                                                  "${addressControlle.AddressDatas[0]['bill_company']}",
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      "Company(optional)"),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              initialValue:
                                                  "${addressControlle.AddressDatas[0]['bill_address1']}",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your name';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "Address"),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              initialValue:
                                                  "${addressControlle.AddressDatas[0]['bill_address2']}",
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      "Apartment,Suite,Etc(optional)"),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              initialValue:
                                                  "${addressControlle.AddressDatas[0]['bill_town_city']}",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter city';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "city"),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    initialValue:
                                                        "${addressControlle.AddressDatas[0]['bill_country']}",
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter Country/Region';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText:
                                                            "Country/Region"),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: TextFormField(
                                                    initialValue:
                                                        "${addressControlle.AddressDatas[0]['bill_state_region1']}",
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter State';
                                                      }
                                                      return null;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelText: "State"),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              initialValue:
                                                  "${addressControlle.AddressDatas[0]['bill_zip_code']}",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter ZipCode';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "ZipCode"),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: TextFormField(
                                              initialValue:
                                                  "${addressControlle.AddressDatas[0]['bill_phone']}",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter PhoneNumber';
                                                }
                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "PhoneNumber"),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Billing Address',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                          'Select The Address That Matches Your Cards Or Payment method',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    RadioMenuButton(
                                        value: 1,
                                        groupValue: _selectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedValue = value!;
                                          });
                                        },
                                        child: const Text('Same As Shipping',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    117, 78, 13, 231)))),
                                    const Divider(
                                      color: Colors.black,
                                      thickness: 1.0,
                                      height: 20.0,
                                      indent: 20.0,
                                      endIndent: 20.0,
                                    ),
                                    RadioMenuButton(
                                        value: 2,
                                        groupValue: _selectedValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedValue = value!;
                                          });
                                        },
                                        child: const Text('Use a Different',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    117, 78, 13, 231)))),
                                  ],
                                ),
                                Visibility(
                                  visible: _selectedValue == 2,
                                  child: Form(
                                    key: _formKey2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Billing Address',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                // key: _formKey2,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  controller:
                                                      _textControllers[0],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter LastName';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: "FirstName",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      _textControllers[1],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter FirstName';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText:
                                                              "LastName"),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Company(optional)"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: _textControllers[2],
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Address"),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter Address';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    "Apartment,Suite,Etc(optional)"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: _textControllers[3],
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "city"),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter city';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      _textControllers[4],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter Country/Region ';
                                                    }
                                                    return null;
                                                  },
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText:
                                                              "Country/Region"),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: TextFormField(
                                                  controller:
                                                      _textControllers[5],
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          labelText: "State"),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter State';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: _textControllers[6],
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "ZipCode"),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter ZipCode';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: TextFormField(
                                            controller: _textControllers[7],
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "PhoneNumber"),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter PhoneNumber';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(left: 30, right: 30),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFCC0000),
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextButton(
                                onPressed: () {
                                  if (_selectedValue == 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please select a billing address.',
                                          style: TextStyle(
                                            color:
                                                Colors.white, // Set text color
                                            fontSize: 16.0, // Set font size
                                          ),
                                        ),
                                        duration: Duration(
                                            seconds: 2), // Adjust duration
                                        backgroundColor: Colors.deepOrange,
                                      ),
                                    );
                                  } else {
                                    submitForm();
                                  }
                                },
                                // onPressed: submitForm,
                                child: const Text("Continue to Shipping",
                                 style: TextStyle(
                                            color:
                                                Colors.white, // Set text color
                                            fontSize: 16.0, // Set font size
                                          ),),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
