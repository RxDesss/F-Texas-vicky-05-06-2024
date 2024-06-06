// ignore_for_file: file_names

import 'package:demo_project/Screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController{
   void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Register Failed'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  void fetchRegister(username,email,password,context) async{
   String url='https://trackappt.desss-portfolio.com/dynamic/dynamicapi.php?action=create&table=mobile_app_users&name=$username&email=$email&password=$password';
  var res=await http.get(Uri.parse(url));
  if(res.statusCode==200){
    // final body=res.body;
    // final json=jsonDecode(body);
    Get.to(()=>const LoginScreen());
  }else{
 _showAlertDialog(context);
  }
  }
}