import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/features/authentication/screens/login/login.dart';
import 'package:skiive/features/authentication/screens/onboarding/onboarding.dart';
import 'package:skiive/navigation.dart';

import '../../utils/loaders/loaders.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();
  // final _auth = FirebaseAuth.instance;

  //Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  //Function to show Relevant Screen
  screenRedirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("userID");
    if (token != null) {
      Get.offAll(() => const Navigation());
    } else {
      // Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(const OnBoardingScreen());
    }
  }

  //Logout
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw SkiiveLoaders.errorSnackBar(
          title: "Oh Snap", message: e.toString());
    } on FirebaseException catch (e) {
      throw SkiiveLoaders.errorSnackBar(
          title: "Oh Snap", message: e.toString());
    } on FormatException catch (e) {
      throw SkiiveLoaders.errorSnackBar(
          title: "Oh Snap", message: e.toString());
    } catch (e) {
      throw "Something went wrong. Please try again!";
    }
  }
}
