import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import 'appBase/appbase_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';

class InternetController extends AppBaseController {
  final Connectivity _connectivity = Connectivity();
  // final _isConnected = false.obs;
  RxBool isConnected = false.obs;
  // bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    _checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      isConnected.value = result != ConnectivityResult.none;
      if (result == ConnectivityResult.none) {
        // I am not connected to any network.
        isConnected.value = true;
      } else {
        isConnected.value = true;
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    print("_checkConnectivity ${connectivityResult}");
    // isConnected.value = result != ConnectivityResult.none;
    if (connectivityResult == ConnectivityResult.none) {
      // I am not connected to any network.
      isConnected.value = true;
    } else {
      isConnected.value = true;
    }
    print("object");
    update();
    // isConnected = result != ConnectivityResult.none;
    print("_checkConnectivity ${isConnected}");
  }
}
