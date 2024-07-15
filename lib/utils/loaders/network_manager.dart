// ignore_for_file: non_constant_identifier_names

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:skiive/utils/loaders/loaders.dart';

class NetworkManager extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();

  ConnectivityProvider() {
    _connectivity.onConnectivityChanged.listen((event) {
      _updateConnectionStatus;
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      SkiiveLoaders.warningSnackBar(title: 'No Internet Connection');
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
