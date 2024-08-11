// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skiive/features/authentication/screens/login/login.dart';
import 'package:skiive/utils/helpers/helper_functions.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //image
              Image(
                image: AssetImage(
                    "assets/logos/marginalia-password-protection.gif"),
                width: SkiiveHelperFunctions.screenWidth() * 0.6,
              ),
              SizedBox(
                height: 20,
              ),

              //Titles and subtitles
              Text(
                "Password reset email sent",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Your Account Security is our Priority! We've sent you a secure link to safely change your password.",
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),

              SizedBox(
                height: 30,
              ),

              //Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => LoginScreen());
                    },
                    child: Text("Done")),
              ),

              SizedBox(
                height: 20,
              ),

              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.transparent),
              //       onPressed: () {},
              //       child: Text(
              //         "Resend Email",
              //         style: TextStyle(color: Colors.black),
              //       )),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
