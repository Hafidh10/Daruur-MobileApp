// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skiive/features/authentication/screens/password/reset_password.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/http/http_client.dart';
import '../../../../utils/loaders/loaders.dart';
import '../../../../utils/validators/validators.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController email = TextEditingController();
  String loading = "init";
  GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();

  Future<void> forgotPassword() async {
    try {
      // Form validation
      if (!emailFormKey.currentState!.validate()) return;

      // Set loading state
      setState(() {
        loading = 'processing';
      });
      Future.delayed(Duration(minutes: 1), () {
        setState(() {
          loading = 'init';
        });
        return false;
      });

      // API call
      final url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.forgotPassword);
      final headers = {'Content-Type': 'application/json'};
      final body = {'email': email.text.trim()};
      final response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      // Handle API response
      if (response.statusCode == 201) {
        // Success
        setState(() {
          loading = 'complete';
        });
        email.clear();
        Get.to(() => const ResetPassScreen());
      } else {
        // Error
        setState(() {
          loading = 'init';
        });
        SkiiveLoaders.errorSnackBar(
            title: 'Error', message: 'Failed to send reset password email');
      }
    } catch (e) {
      // Log error
      print('Error: $e');
      // Show generic error message
      SkiiveLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to send reset password email');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final dark = SkiiveHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forget Password",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(
                height: 5,
              ),

              Text(
                'Enter your email to be able to reset your password',
                style: Theme.of(context).textTheme.labelLarge,
              ),

              SizedBox(
                height: 20,
              ),

              //Form
              Form(
                  key: emailFormKey,
                  child: Column(
                    children: [
                      //username
                      TextFormField(
                        controller: email,
                        validator: (value) =>
                            SkiiveValidator.validateEmail(value),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Iconsax.direct_right),
                          labelText: 'Email',
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      //create button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: SkiiveColors.primary),
                            onPressed: () {
                              forgotPassword();
                            },
                            child: loading == 'init'
                                ? Text('Submit')
                                : loading == 'processing'
                                    ? SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation(
                                              Color.fromRGBO(
                                                  172, 173, 189, 0.9)),
                                          strokeWidth: 1.5,
                                        ),
                                      )
                                    : Icon(Iconsax.tick_circle)),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
