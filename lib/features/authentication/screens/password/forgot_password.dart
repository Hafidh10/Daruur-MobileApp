// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skiive/features/authentication/screens/password/reset_password.dart';
import 'package:skiive/utils/constants/colors.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});

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
                  child: Column(
                children: [
                  //username
                  TextFormField(
                    expands: false,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Iconsax.direct_right)),
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
                        onPressed: () => Get.to(() => ResetPassScreen()),
                        child: Text('Submit')),
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
