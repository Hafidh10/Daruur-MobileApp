// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD2wjYfhtr9Eqsg5dUIFp1YfdMBDPNtBCU',
    appId: '1:97792142793:web:20143e0b8f0c32911ecc18',
    messagingSenderId: '97792142793',
    projectId: 'skiive',
    authDomain: 'skiive.firebaseapp.com',
    storageBucket: 'skiive.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQtQfJzlRDHY5ciomMyVtN8l9OWg5GF0c',
    appId: '1:97792142793:android:e5b3692fa4ff68431ecc18',
    messagingSenderId: '97792142793',
    projectId: 'skiive',
    storageBucket: 'skiive.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDftBV8Soj4k8P4vibtO5vePy6FM3QIsTY',
    appId: '1:97792142793:ios:49b7623d14a2a8a11ecc18',
    messagingSenderId: '97792142793',
    projectId: 'skiive',
    storageBucket: 'skiive.appspot.com',
    androidClientId: '97792142793-61uganonf3q1cl6iert9ugqq3854banc.apps.googleusercontent.com',
    iosClientId: '97792142793-vnn5tes2iu2ob89ahrp5in1l2729tgsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.skiive',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDftBV8Soj4k8P4vibtO5vePy6FM3QIsTY',
    appId: '1:97792142793:ios:49b7623d14a2a8a11ecc18',
    messagingSenderId: '97792142793',
    projectId: 'skiive',
    storageBucket: 'skiive.appspot.com',
    androidClientId: '97792142793-61uganonf3q1cl6iert9ugqq3854banc.apps.googleusercontent.com',
    iosClientId: '97792142793-vnn5tes2iu2ob89ahrp5in1l2729tgsq.apps.googleusercontent.com',
    iosBundleId: 'com.example.skiive',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD2wjYfhtr9Eqsg5dUIFp1YfdMBDPNtBCU',
    appId: '1:97792142793:web:b95d7982e53b313f1ecc18',
    messagingSenderId: '97792142793',
    projectId: 'skiive',
    authDomain: 'skiive.firebaseapp.com',
    storageBucket: 'skiive.appspot.com',
  );

}