import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:test_prj/components/my_appbar.dart';
import 'package:test_prj/controller/carservice_controller.dart';
import 'package:test_prj/home_page.dart';

import '../SelectNewAddress.dart';
import '../components/my_button.dart';
import '../data/model/VehicleModel.dart';
import '../data/model/VehicleType.dart';
import '../helper/colors.dart';

class RescueMe extends StatefulWidget {
  const RescueMe({super.key});

  @override
  State<RescueMe> createState() => _RescueMeState();
}

class _RescueMeState extends State<RescueMe> {
  List<String> services = [
    'Fuel',
    'Tyres',
    'Changes',
    'Jump Start',
    'Towing(break down)'
  ];

  TextEditingController fuelQuantityController = TextEditingController();
  List<String> vehicles = ['2 wheeler', '4 wheeler'];
  List<String> fuelTypes = ['Diesel', 'Petrol'];

  // String? selectedVehicle;
  String? selectedServices;
  String? selectedfuelType;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    CarServiceController carServiceController = Get.find();
    carServiceController.getVehiCleType();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarServiceController>(
        init: CarServiceController(),
        builder: (carServiceController) {
          return Scaffold(
            appBar: MyAppbar(title: 'Rescue Me'.tr),
            body: Column(
              children: [
                // Container(
                //   height: 100,
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.centerLeft,
                //       end: Alignment.centerRight,
                //       colors: [
                //         Color.fromRGBO(252, 130, 59, 1),
                //         Color.fromRGBO(252, 130, 59, 1),
                //         Color.fromRGBO(211, 83, 7, 1),
                //       ],
                //     ),
                //     borderRadius: BorderRadius.only(
                //       bottomLeft: Radius.circular(23),
                //       bottomRight: Radius.circular(23),
                //     ),
                //   ),
                //   child: Row(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(top: 45.0, left: 20),
                //         child: Icon(
                //           Icons.arrow_back,
                //           color: Colors.white,
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.only(top: 45.0, left: 70),
                //         child: Text(
                //           'Rescue Me'.tr,
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.black12, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Obx(() => DropdownButton<VehicleData>(
                              hint: Text('Select Vehicle'.tr),
                              value: carServiceController.selectedVehicle.value,
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (VehicleData? newValue) {
                                if (newValue != null) {
                                  carServiceController.selectedVehicle.value =
                                      newValue;
                                  carServiceController
                                      .getVehicleModel(newValue.id.toString());

                                  otherCategory.vehicleType =
                                      newValue.id.toString();
                                  setState(() {});
                                }
                              },
                              items: carServiceController.vehicleList!
                                  .map<DropdownMenuItem<VehicleData>>(
                                      (VehicleData value) {
                                return DropdownMenuItem<VehicleData>(
                                  value: value,
                                  child: Text(value.name.toString()),
                                );
                              }).toList(),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // carServiceController.vehicleModelList!.isNotEmpty &&
                      //         carServiceController.selectedService != null &&
                      //         carServiceController.selectedService.value != null
                      //     ? Container(
                      //         decoration: BoxDecoration(
                      //           border:
                      //               Border.all(color: colors.black12, width: 2),
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         padding: EdgeInsets.symmetric(horizontal: 10),
                      //         child: Obx(() => DropdownButton<VehicleModelData>(
                      //               hint: Text('Select Services'.tr),
                      //               value: carServiceController
                      //                   .selectedService.value,
                      //               underline: Container(),
                      //               isExpanded: true,
                      //               onChanged: (VehicleModelData? newValue) {
                      //                 if (newValue != null) {
                      //                   carServiceController
                      //                       .selectedService.value = newValue;
                      //                   otherCategory.service =
                      //                       newValue.id.toString();
                      //                   // setState(() { });
                      //                 }
                      //               },
                      //               items: carServiceController
                      //                   .vehicleModelList!
                      //                   .map<
                      //                           DropdownMenuItem<
                      //                               VehicleModelData>>(
                      //                       (VehicleModelData value) {
                      //                 return DropdownMenuItem<VehicleModelData>(
                      //                   value: value,
                      //                   child: Text(value.name.toString()),
                      //                 );
                      //               }).toList(),
                      //             )),
                      //       )
                      //     : Container(),
                      /// Services

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.black12, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          hint: Text('Select Services'.tr),
                          value: selectedServices,
                          underline: Container(),
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              selectedServices = newValue;
                              otherCategory.service = newValue.toString();
                              setState(() {});
                            }
                          },
                          items: services!
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                      carServiceController.selectedService.value == null
                          ? Container()
                          : SizedBox(
                              height: 20,
                            ),
                      carServiceController.selectedService.value == null
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: colors.black12, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: DropdownButton<String>(
                                hint: Text('Fuel Type'.tr),
                                value: selectedfuelType,
                                underline: Container(),
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedfuelType = newValue;

                                      otherCategory.notes = newValue.toString();
                                    });
                                  }
                                },
                                items: fuelTypes.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                      selectedfuelType == null
                          ? Container()
                          : SizedBox(
                              height: 20,
                            ),
                      selectedfuelType == null
                          ? Container()
                          : Container(
                              height: 50,
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: colors.black12, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextFormField(
                                controller: fuelQuantityController,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(left: 5),
                                    hintText:
                                        'Fuel Quantity(Min 5 ltrs - Max 20 ltrs'
                                            .tr,
                                    border: InputBorder.none),
                              )),
                      SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            if (otherCategory.vehicleType == null ||
                                otherCategory.vehicleType!.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "PLease select Vehicle Type");
                            } else if (otherCategory.notes == null ||
                                otherCategory.notes!.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "PLease select Vehicle Model");
                            } else if (otherCategory.service == null ||
                                selectedfuelType!.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please select Fuel Type");
                            } else if (fuelQuantityController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please Enter Fuel Quantity");
                            } else {
                              otherCategory.tyreSize =
                                  fuelQuantityController.text.toString();
                              print(
                                  "object Cate Id ${otherCategory.categoryId}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          SelectNewAddress())));
                            }
                          },
                          child: MyButton(text: 'Done'.tr),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
