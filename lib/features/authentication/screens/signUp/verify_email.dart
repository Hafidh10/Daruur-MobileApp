// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skiive/features/authentication/screens/login/login.dart';
import 'package:skiive/features/authentication/screens/signUp/success.dart';
import 'package:skiive/utils/helpers/helper_functions.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () => Get.offAll(() => LoginScreen()),
              icon: Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //image
              Image(
                image: const AssetImage(
                    'assets/logos/techny-email-marketing-and-newsletter.gif'),
                width: SkiiveHelperFunctions.screenWidth() * 0.6,
              ),
              SizedBox(
                height: 20,
              ),

              //Titles and subtitles
              Text(
                'Confirm Email',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              // Text(
              //   'hafidhmarjan10@gmail.com',
              //   style: Theme.of(context).textTheme.bodySmall,
              //   textAlign: TextAlign.center,
              Text(
                'Verify your email to start learning our various Courses available for your Career',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 30,
              ),

              //Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Get.to(() => SuccessScreen(
                          image: 'assets/logos/clip-1807.png',
                          title: 'Your Account was Successfully created',
                          subTitle:
                              'Welcome to our Ultimate collection of Courses, Lessons and Numerouse Quizes to boost your Career',
                          onPressed: () => Get.to(() => LoginScreen()),
                        )),
                    child: Text("Continue")),
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    onPressed: () {},
                    child: Text(
                      "Resend Email",
                      style: TextStyle(color: Colors.black),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
