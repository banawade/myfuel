import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_prj/authPages/forgot_password.dart';
import 'package:test_prj/authPages/login_page_2.dart';
import 'package:test_prj/components/my_background.dart';
import 'package:test_prj/components/my_button.dart';
import 'package:test_prj/controller/login_controller.dart';
import 'package:test_prj/helper/app_images.dart';
import 'package:test_prj/helper/colors.dart';
import 'package:test_prj/home.dart';
import 'package:test_prj/authPages/sign_up.dart';
import 'package:test_prj/routes/app_pages.dart';
import 'package:test_prj/routes/app_routes.dart';

import '../helper/utils/shared_preference.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController memberShipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            body: SingleChildScrollView(
              child: MyBackground(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Image.asset(
                          AppImages.appLogo,
                          height: 62,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Login".tr,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please Sign in to your account".tr,
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.changeIndexMethod(0);
                                },
                                child: Container(
                                  height: 45,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    gradient: controller.changeIndex.value == 0
                                        ? colors.buttonGradient
                                        : colors.unselectGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Personal".tr,
                                    style: TextStyle(
                                      color: controller.changeIndex.value == 0
                                          ? colors.whiteTemp
                                          : colors.blackTemp,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.changeIndexMethod(1);
                                },
                                child: Container(
                                  height: 45,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    gradient: controller.changeIndex.value == 1
                                        ? colors.buttonGradient
                                        : colors.unselectGradient,
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade100),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text("Business".tr,
                                      style: TextStyle(
                                        color: controller.changeIndex.value == 1
                                            ? colors.whiteTemp
                                            : colors.blackTemp,
                                      )),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 15),
                        Obx(() {
                          return controller.changeIndex.value == 0
                              ? showPersonal()
                              : showBusiness();
                        }),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              "Forgot Password? ".tr,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgetPassword(),
                                  )),
                              child: Text(
                                "Reset It".tr,
                                style: TextStyle(
                                  color: Color.fromRGBO(138, 180, 2, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Obx(
                          () => controller.isLoading.value == true
                              ? Center(child: CircularProgressIndicator())
                              : GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      controller
                                          .login(
                                              memberShipController.text
                                                  .toString(),
                                              phoneEmailController.text
                                                  .toString(),
                                              passwordController.text
                                                  .toString())
                                          .then((value) async {
                                        if (value.containsKey("errors")) {
                                          Fluttertoast.showToast(msg: "$value");
                                        } else if (value['token'] != "") {
                                          SharedPreferencesService? instance =
                                              await SharedPreferencesService
                                                  .getInstance();
                                          instance.saveData(
                                              SharedPreferencesService
                                                  .kTokenKey,
                                              value['token'].toString());

                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home()));
                                        }
                                        // return null;
                                      });
                                    }
                                  },
                                  child: MyButton(text: "Login".tr),
                                ),
                        ),
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't Have an account? ".tr),
                            GestureDetector(
                              onTap: () {
                                String argumentData =
                                    controller.changeIndex.value.toString();
                                Get.toNamed(Routes.REGISTER,
                                    arguments: argumentData);
                                // Get.toNamed(Routes.REGISTER);
                              },
                              child: Text(
                                "Sign Up".tr,
                                style: TextStyle(
                                  color: Color.fromRGBO(138, 180, 2, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget showPersonal() {
    return Column(
      children: [
        TextFormField(
          controller: phoneEmailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Phone No. Or Email';
            }
            return null;
          },
          decoration: InputDecoration(
            label: Text('Phone No. Or Email'),
            labelStyle: TextStyle(color: Colors.grey.shade700),
            enabled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: passwordController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            return null;
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(Icons.remove_red_eye)),
            label: Text('Password'),
            labelStyle: TextStyle(color: Colors.grey.shade700),
            enabled: true,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.black),
            ),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget showBusiness() {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: TextFormField(
            controller: memberShipController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter Membership No.';
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text('Membership No.'),
              labelStyle: TextStyle(color: Colors.grey.shade700),
              enabled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 56,
          child: TextFormField(
            controller: phoneEmailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter User name';
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text('Phone No. Or Email'),
              labelStyle: TextStyle(color: Colors.grey.shade700),
              enabled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 56,
          child: TextFormField(
            controller: passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password';
              }
              return null;
            },
            decoration: InputDecoration(
              label: Text('Password'),
              labelStyle: TextStyle(color: Colors.grey.shade700),
              enabled: true,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}
