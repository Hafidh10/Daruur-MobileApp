// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, sort_child_properties_last, unnecessary_nullable_for_final_variable_declarations

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:skiive/data/repositories/google_auth.dart';
import 'package:skiive/features/authentication/screens/password/forgot_password.dart';
import 'package:skiive/features/authentication/screens/signUp/sign_up.dart';
import 'package:skiive/navigation.dart';
import 'package:skiive/utils/constants/colors.dart';
import 'package:skiive/utils/http/http_client.dart';
import 'package:skiive/utils/loaders/loaders.dart';
import 'package:skiive/utils/validators/validators.dart';

import '../../../../data/repositories/database_method.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    this.tokenId,
  }) : super(key: key);

  final String? tokenId;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  String googleLoading = 'init';
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final hidePassword = true.obs;
  String loading = 'init';
  TextEditingController password = TextEditingController();
  final privacyPolicy = true.obs;
  GlobalKey<FormState> signinFormKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Login
  Future<void> login() async {
    try {
      //Form Validation
      if (!signinFormKey.currentState!.validate()) return;

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
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.login);
      Map body = {
        'email': email.text.trim(),
        'password': password.text.toString(),
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        setState(() {
          loading = 'complete';
        });

        final json = jsonDecode(response.body);
        var token = json['data']['accessToken'];
        final jsonEmail = jsonDecode(response.body);
        var userEmail = jsonEmail['data']['email'];
        final jsonId = jsonDecode(response.body);
        var parameterId = jsonId['data']['parameterId'];

        var uriData = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.studentProfile);
        var responseData = await http.get(uriData, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
        final jsonfirstName = jsonDecode(responseData.body);
        var userfirstName = jsonfirstName['data']['firstName'];
        final jsonlastName = jsonDecode(responseData.body);
        var userlastName = jsonlastName['data']['lastName'];

        final SharedPreferences? prefs = await _prefs;

        await prefs?.setString('accessToken', token);
        await prefs?.setString('email', userEmail);
        await prefs?.setString('firstName', userfirstName);
        await prefs?.setString('lastName', userlastName);
        await prefs?.setString('parameterId', parameterId);

        email.clear();
        password.clear();
        SkiiveLoaders.successSnackBar(
            title: 'Login Successfully!',
            message: 'Welcome to Emerge Learning Management platform.');

        Get.to(() => const Navigation());
      } else if (response.statusCode == 401) {
        setState(() {
          loading = 'init';
        });
        SkiiveLoaders.warningSnackBar(
            title: 'Error!',
            message: "This email or password you entered is incorrect.");
      } else if (response.statusCode == 403) {
        setState(() {
          loading = 'init';
        });
        SkiiveLoaders.warningSnackBar(
            title: 'Error!',
            message:
                "This email address hasn't been verified. Use the link sent to your email address to complete verification.");
      } else {
        setState(() {
          loading = 'init';
        });
        // Handle other API errors
        SkiiveLoaders.errorSnackBar(
            title: 'Error',
            message:
                'An error occurred while logging in. Please try again later.');
      }
    } catch (e) {
      // Handle exceptions
      setState(() {
        loading = 'init';
      });
      SkiiveLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  //Google Sign In
  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() {
      googleLoading = 'processing';
    });

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;
    final name = userDetails!.displayName;
    final email = userDetails.email;
    final photo = userDetails.photoURL;
    final uid = userDetails.uid;

    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("uid", uid);
      prefs.setString("googleName", name!);
      prefs.setString("googleEmail", email!);
      prefs.setString("googlePhoto", photo!);

      //Call API
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndPoints.googleLogin);
      Map body = {
        'email': email,
        'uid': uid,
      };

      try {
        http.Response response =
            await http.post(url, body: jsonEncode(body), headers: headers);
        final json = jsonDecode(response.body);
        var token = json['data']['accessToken'];
        var parameterId = json['data']['parameterId'];

        final SharedPreferences? prefs = await _prefs;

        await prefs?.setString('accessToken', token);
        await prefs?.setString('parameterId', parameterId);
        if (response.statusCode == 201) {
          setState(() {
            googleLoading = 'complete';
          });
          Get.to(() => const Navigation());
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              googleLoading = 'init';
            });
          });
        } else {
          setState(() {
            googleLoading = 'init';
          });
          // Handle error response
          SkiiveLoaders.errorSnackBar(
              title: 'Error', message: 'API error: ${response.statusCode}');
        }
      } catch (e) {
        // Handle exception
        SkiiveLoaders.errorSnackBar(title: 'Error', message: 'API error: $e');
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            googleLoading = 'init';
          });
        });
      }

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
        "id": userDetails.uid
      };
      await DatabaseMethods()
          .addUser(userDetails.uid, userInfoMap)
          .then((value) async {
        setState(() {
          googleLoading = 'complete';
        });
      }).catchError((e) {
        setState(() {
          googleLoading = 'init';
        });
      });
    } else {
      setState(() {
        googleLoading = 'init';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              //Logo, title & subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 10),
                    child: Image(
                      image: AssetImage('assets/logos/pablita-reading.png'),
                      height: 150,
                    ),
                  ),
                  Text('Welcome back,',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    'Discover unlimited Coarses and Several Lessons all at once',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w100,
                      color: SkiiveColors.darkGrey,
                    ),
                  )
                ],
              ),

              //Form
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Form(
                  key: signinFormKey,
                  child: Column(
                    children: [
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

                      SizedBox(height: 15),

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

                      //Remember me & forgot password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Obx(() => Checkbox(
                                      value: privacyPolicy.value,
                                      onChanged: (value) => privacyPolicy
                                          .value = !privacyPolicy.value))),
                              Text(
                                'Remember me',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),

                          //Forgot password
                          TextButton(
                              onPressed: () => Get.to(() => ForgotPassScreen()),
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(color: SkiiveColors.darkGrey),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      //Sign in Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: SkiiveColors.primary),
                            onPressed: () {
                              login();
                              // Get.to(() => Navigation());
                            },
                            child: loading == 'init'
                                ? Text('Sign In')
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

                      //create account button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                side: BorderSide(color: Colors.black)),
                            onPressed: () => Get.to(() => SignUpScreen()),
                            child: Text(
                              'Create Account',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
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
                      'or Sign In with',
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
              ),
              SizedBox(
                height: 10,
              ),
              //Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      side: BorderSide(color: Colors.blueAccent, width: 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                    ),
                    onPressed: () {
                      signInWithGoogle(context);
                    },
                    child: googleLoading == 'init'
                        ? Image(
                            width: 26,
                            height: 26,
                            image: AssetImage(
                                'assets/images/icons8-google-48.png'),
                          )
                        : googleLoading == 'processing'
                            ? SizedBox(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.black,
                                  ),
                                  strokeWidth: 4,
                                ),
                                height: 16,
                                width: 16,
                              )
                            : Icon(
                                Iconsax.tick_circle,
                                color: Colors.blueAccent,
                              ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
