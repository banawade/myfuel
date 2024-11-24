import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:test_prj/controller/appBase/appbase_controller.dart';

import '../service/provider/lavavel_provider.dart';

class LoginController extends AppBaseController {
  LaravelApiClient _laravelApiClient = Get.find<LaravelApiClient>();

  Rx<int> changeIndex = 0.obs;

  void changeIndexMethod(int index) {
    changeIndex.value = index;
  }

  RxBool isLoading = false.obs;

  Future<Map<String, dynamic>> login(
      String membNo, String emailPhone, String password) async {
    isLoading(true);

    Map<String, dynamic> value =
        await _laravelApiClient.Login(membNo, emailPhone, password);
    if (value.containsKey("errors")) {
      Fluttertoast.showToast(msg: "$value");
    } else if (value['token'] != "") {}
    isLoading(false);
    return value;
  }
}
