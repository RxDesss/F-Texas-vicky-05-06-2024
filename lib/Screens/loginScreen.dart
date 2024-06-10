// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_project/GetX%20Controller/loginController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController logincontroller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;

  void _saveForm(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      logincontroller.fetchLogin(username, password, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.92,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Image.asset(
                        'assets/TexasImage.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.05,
                        left: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: 'dev@desss.com',
                              onSaved: (value) {
                                username = value;
                              },
                              decoration:
                                  const InputDecoration(hintText: "Email"),
                              validator: (value) {
                                String pattern =
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                                RegExp regExp = RegExp(pattern);
                                if (value == null || value.isEmpty) {
                                  return "Enter Email Id";
                                } else if (!regExp.hasMatch(value)) {
                                  return 'Enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              initialValue: '\$heshU98',
                              onSaved: (value) {
                                password = value;
                              },
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value == "" ) {
                                  return "Enter a password";
                                }else if (value.length < 5){
                                  return "Enter a valid password";
                                }
                                return null;
                              },
                              decoration:
                                  const InputDecoration(hintText: "Password"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Obx(
                      () => Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFCC0000),
                        ),
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextButton(
                          onPressed: logincontroller.isLoading.value
                              ? null
                              : () {
                                  _saveForm(context);
                                },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.04,
                    // ),
                    // const Text("Don't have an account "),
                    // TextButton(
                    //   onPressed: () {
                    //     Get.to(() => const RegisterScreen());
                    //   },
                    //   child: const Text("Sign Up"),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
