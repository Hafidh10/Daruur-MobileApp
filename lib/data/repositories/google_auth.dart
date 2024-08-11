// ignore_for_file: unnecessary_null_comparison, await_only_futures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skiive/data/repositories/database_method.dart';
import 'package:skiive/navigation.dart';

class AuthMethods with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String googleLoading = 'init';

  String get loadingState => googleLoading;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    googleLoading = 'processing';
    notifyListeners();

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
      prefs.setString("UserID", uid);
      prefs.setString("Name", name!);
      prefs.setString("Email", email!);
      prefs.setString("Photo", photo!);

      Map<String, dynamic> userInfoMap = {
        "email": userDetails.email,
        "name": userDetails.displayName,
        "imgUrl": userDetails.photoURL,
        "id": userDetails.uid
      };
      await DatabaseMethods()
          .addUser(userDetails.uid, userInfoMap)
          .then((value) {
        googleLoading = 'complete';
        notifyListeners();
        Get.to(() => const Navigation());
      }).catchError((e) {
        googleLoading = 'init';
        notifyListeners();
      });
    } else {
      googleLoading = 'init';
      notifyListeners();
    }
  }
}
