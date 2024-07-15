// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, unnecessary_nullable_for_final_variable_declarations

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/features/authentication/screens/login/login.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/helpers/helper_functions.dart';
import 'package:skiive/utils/http/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:skiive/utils/loaders/loaders.dart';
import 'package:skiive/utils/validators/validators.dart';

import '../../../../data/repositories/google_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController password = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  String loading = 'init';
  //Sign up
  Future<void> signup() async {
    try {
      //Form Validation
      if (!signupFormKey.currentState!.validate()) return;

      // Privacy Policy check
      if (!privacyPolicy.value) {
        SkiiveLoaders.warningSnackBar(
            title: 'Accept privacy policy',
            message:
                'to create account, you must accept the Privacy Policy and terms of Use');
      }
      setState(() {
        loading = 'processing';
      });
      Future.delayed(Duration(minutes: 1), () {
        setState(() {
          loading = 'init';
        });
        return false;
      });

      var headers = {'Content-Type': 'application/json'};
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.register);
      Map body = {
        'email': email.text.trim(),
        'firstName': firstName.text.toString(),
        'lastName': lastName.text.toString(),
        'password': password.text.toString(),
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        setState(() {
          loading = 'complete';
        });
        final json = jsonDecode(response.body);
        var id = json['data']['id'];
        final SharedPreferences? prefs = await _prefs;

        await prefs?.setString('id', id);
        email.clear();
        firstName.clear();
        lastName.clear();
        email.clear();
        password.clear();
        SkiiveLoaders.successSnackBar(
            title: 'Congratulations!',
            message:
                'Account created successfully, please open your email to verify.');

        Get.to(() => const LoginScreen());
      } else if (response.statusCode == 409) {
        setState(() {
          loading = 'init';
        });
        SkiiveLoaders.warningSnackBar(
            title: 'User Exists!',
            message:
                'This User already exists please use another email to create account');
      }
    } catch (e) {
      //Show generic error to user
      SkiiveLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = SkiiveHelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's create your account",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              SizedBox(
                height: 20,
              ),

              //Form
              Form(
                  key: signupFormKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: firstName,
                              validator: (value) =>
                                  SkiiveValidator.validateEmptyText(
                                      'First name', value),
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.user),
                                labelText: 'First Name',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: lastName,
                              validator: (value) =>
                                  SkiiveValidator.validateEmptyText(
                                      'Last name', value),
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.user),
                                labelText: 'Last Name',
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      //Email
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
                        height: 15,
                      ),

                      //password
                      Obx(
                        () => TextFormField(
                          controller: password,
                          validator: (value) =>
                              SkiiveValidator.validatePassword(value),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.password_check),
                            suffixIcon: IconButton(
                                onPressed: () =>
                                    hidePassword.value = !hidePassword.value,
                                icon: Icon(hidePassword.value
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye)),
                            labelText: 'Password',
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: hidePassword.value,
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      //terms and conditions
                      Row(
                        children: [
                          SizedBox(
                              height: 24,
                              width: 24,
                              child: Obx(() => Checkbox(
                                  value: privacyPolicy.value,
                                  onChanged: (value) => privacyPolicy.value =
                                      privacyPolicy.value))),
                          SizedBox(
                            width: 16,
                          ),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: 'I Agree to ',
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: 'Privacy Policy ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(
                                        color: dark
                                            ? SkiiveColors.white
                                            : SkiiveColors.primary,
                                        decoration: TextDecoration.underline)),
                            TextSpan(
                                text: 'and ',
                                style: Theme.of(context).textTheme.labelMedium),
                            TextSpan(
                                text: 'Terms of Use',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(
                                        color: dark
                                            ? SkiiveColors.white
                                            : SkiiveColors.primary,
                                        decoration: TextDecoration.underline,
                                        decorationColor: dark
                                            ? SkiiveColors.white
                                            : SkiiveColors.primary)),
                          ]))
                        ],
                      ),

                      SizedBox(
                        height: 25,
                      ),

                      //create button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: SkiiveColors.primary),
                            onPressed: () {
                              signup();
                            },
                            child: loading == 'init'
                                ? Text('Create Account')
                                : loading == 'processing'
                                    ? SizedBox(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor: AlwaysStoppedAnimation(
                                              Color.fromRGBO(
                                                  172, 173, 189, 0.9)),
                                          strokeWidth: 1.5,
                                        ),
                                        height: 16,
                                        width: 16,
                                      )
                                    : Icon(Iconsax.tick_circle)),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //dividers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                              child: Divider(
                            color: SkiiveColors.darkGrey,
                            thickness: 0.5,
                            indent: 20,
                            endIndent: 20,
                          )),
                          Text(
                            'or Sign Up with',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Flexible(
                              child: Divider(
                            color: SkiiveColors.darkGrey,
                            thickness: 0.5,
                            indent: 20,
                            endIndent: 20,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Footer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: SkiiveColors.grey),
                                borderRadius: BorderRadius.circular(100)),
                            child: IconButton(
                                onPressed: () {
                                  AuthMethods().signInWithGoogle(context);
                                },
                                icon: Image(
                                    width: 26,
                                    height: 26,
                                    image: AssetImage(
                                        'assets/images/icons8-google-48.png'))),
                          )
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
