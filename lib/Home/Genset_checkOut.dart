import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:test_prj/controller/cart_controller.dart';
import 'package:test_prj/payment/paymentScreen.dart';
import 'package:test_prj/splashScreen.dart';

import '../components/my_button.dart';
import '../helper/colors.dart';
import '../main.dart';
import '../payment/pay_success_page.dart';
import '../payment/payment_form.dart';
import '../routes/app_routes.dart';

class GetSetCheckoutScreen extends StatefulWidget {
  final bool? isfrom;
  const GetSetCheckoutScreen({super.key, this.isfrom});

  @override
  State<GetSetCheckoutScreen> createState() => _GetSetCheckoutScreenState();
}

class _GetSetCheckoutScreenState extends State<GetSetCheckoutScreen> {
  Razorpay? razorpay;
  int? pricerazorpayy;
  String payment_type = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initUI();
  }

  void openCheckout(amount) async {
    double res = double.parse(amount.toString().replaceAll(",", ""));
    pricerazorpayy = int.parse(res.toStringAsFixed(0)) * 100;
    // Navigator.of(context).pop();
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': "$pricerazorpayy",
      'name': 'My Fuel',
      'image': 'assets/images/Group 165.png',
      'description': 'My Fuel',
    };
    try {
      razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: "Payment successfully");

    CartController controller = Get.find();
    controller.placeOrder(address_id.toString(), "razorpay").then((value) {
      Get.offAll(
        OrderPlaced(
          isFromFuelOnTap: true,
          amount: "${controller.checkOutModel.value.total}",
        ),
      );

      // Navigator.pushReplacement(
      //   navigatorKey.currentState!.context!,
      //   MaterialPageRoute(
      //     builder: (context) => OrderPlaced(
      //       isFromFuelOnTap: true,
      //       amount: "${controller.checkOutModel.value.total}",
      //     ),
      //   ),
      // );
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => const PaymentScreenTree()));
    });

    Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment cancelled by user");
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  String address_id = "";
  String category_id = "";
  void initUI() {
    razorpay = Razorpay();
    razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    final arguments = Get.arguments ?? {};
    address_id = arguments['address_id'].toString();
    category_id = arguments['category_id'].toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CartController controller = Get.find();
      controller.manageCart(address_id, category_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final arguments = Get.arguments ?? {};

    return GetBuilder<CartController>(
        init: CartController(),
        builder: (controller) {
          controller.manageCart(address_id, category_id);
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    size: 20,
                  )),
              foregroundColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromRGBO(252, 130, 59, 1),
                      Color.fromRGBO(252, 130, 59, 1),
                      Color.fromRGBO(211, 83, 7, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                  ),
                ),
              ),
              title: Text('Checkout'),
              centerTitle: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Obx(() {
                return controller.isLoading.value == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromRGBO(245, 245, 245, 1),
                              ),
                              // height: 105,
                              width: MediaQuery.sizeOf(context).width,
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery Address',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${controller.checkOutModel.value.address!.contactPersonName},${controller.checkOutModel.value.address!.zip}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${controller.checkOutModel.value.address!.building} ${controller.checkOutModel.value.address!.landmark},${controller.checkOutModel.value.address!.city}..',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    118, 118, 128, 1),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 24,
                                        width: 57,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color:
                                                colors.primary.withOpacity(.1),
                                            border: Border.all(
                                                color: colors.primary)),
                                        child: const Center(
                                          child: Text(
                                            'Home',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colors.primary,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  ListView.builder(
                                    itemCount: controller
                                        .checkOutModel.value.data!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 0,
                                        // elevation: 3,
                                        //  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.network(
                                                    '${configModel!.baseUrls!.productThumbnailUrl}/${controller.checkOutModel.value.data![index].thumbnail}',
                                                    // 'https://media.istockphoto.com/id/1330589502/photo/electric-vehicle-charging-station.jpg?s=1024x1024&w=is&k=20&c=gwve61BLBc9djE8P9Qp-2KSxS-ehZtvlcTW6AKy4DOA=',
                                                    height: 130,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.asset(
                                                          "assets/indianoil.png");
                                                    },
                                                    width: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${controller.checkOutModel.value.category!.name!}",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${controller.checkOutModel.value.data![index].name}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${controller.checkOutModel.value.data![index].slug}",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Card(
                                  //   elevation: 0,
                                  //   // elevation: 3,
                                  //   //  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  //
                                  //   child: Padding(
                                  //     padding: EdgeInsets.all(4),
                                  //     child: Row(
                                  //       children: [
                                  //         Container(
                                  //           height: 100,
                                  //           width: 100,
                                  //           decoration: BoxDecoration(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10),
                                  //           ),
                                  //           margin: EdgeInsets.only(right: 10),
                                  //           child: ClipRRect(
                                  //             borderRadius:
                                  //                 BorderRadius.circular(10),
                                  //             child: Image.network(
                                  //               'https://media.istockphoto.com/id/1330589502/photo/electric-vehicle-charging-station.jpg?s=1024x1024&w=is&k=20&c=gwve61BLBc9djE8P9Qp-2KSxS-ehZtvlcTW6AKy4DOA=',
                                  //               height: 130,
                                  //               width: 100,
                                  //               fit: BoxFit.cover,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           child: Padding(
                                  //             padding: EdgeInsets.symmetric(
                                  //                 vertical: 10),
                                  //             child: Column(
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                   "Genset Maintenance",
                                  //                   style: TextStyle(
                                  //                     fontSize: 20,
                                  //                     fontWeight: FontWeight.bold,
                                  //                     color: Colors.black,
                                  //                   ),
                                  //                 ),
                                  //                 Row(
                                  //                   children: [
                                  //                     Text(
                                  //                       "Engion oil filter",
                                  //                       style: TextStyle(
                                  //                         fontSize: 14,
                                  //                         color: Colors.black54,
                                  //                       ),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //                 Row(
                                  //                   children: [
                                  //                     Text(
                                  //                       "Preodic Service",
                                  //                       style: TextStyle(
                                  //                         fontSize: 14,
                                  //                         color: Colors.black54,
                                  //                       ),
                                  //                     ),
                                  //                     Spacer(),
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  widget.isfrom ?? false
                                      ? Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                  .width,
                                              color: colors.lightgray,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Scheduled Date and Time',
                                                    style: TextStyle(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Text(
                                                    '11:00 to 12:00',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    '13 jan 2024,Man',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "RSP",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        "₹120.00",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Diesel Quantity",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        "₹0",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Delivery Fee",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        "₹${controller.checkOutModel.value.deliveryCharge}",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "GST(On Delivery Fee)",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        "₹0",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Other Charges",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        "₹80",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Discount",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                        "₹0",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  const Divider(
                                                    // thickness: 2,
                                                    color: Colors.black26,
                                                    //indent: 15,
                                                    //endIndent: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Total Amount",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Rs.${controller.checkOutModel.value.total}",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(
                                                    // thickness: 2,
                                                    color: Colors.black26,
                                                    //indent: 15,
                                                    //endIndent: 10,
                                                  ),
                                                  Spacer(),
                                                  // const SizedBox(height: 100),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: GestureDetector(
                                                        child: const MyButton(
                                                            text: 'Checkout'),
                                                        onTap: () async {
                                                          print(
                                                              "l.value.total${controller.checkOutModel.value.total.toString()}");
                                                          var data = await Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          const PaymentScreenTree()));

                                                          if (data != null) {
                                                            if (data ==
                                                                "payment") {
                                                              openCheckout(controller
                                                                  .checkOutModel
                                                                  .value
                                                                  .total
                                                                  .toString());
                                                            } else {
                                                              controller
                                                                  .placeOrder(
                                                                      address_id
                                                                          .toString(),
                                                                      "cod")
                                                                  .then(
                                                                      (value) {
                                                                Navigator
                                                                    .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            OrderPlaced(
                                                                      isFromFuelOnTap:
                                                                          true,
                                                                      amount:
                                                                          "${controller.checkOutModel.value.total}",
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : SizedBox()

                                  /*Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colors.blackTemp)),
                          child: Center(
                              child: Text(
                            'Change or add new address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                        )*/
                                ],
                              ),
                            ),
                          ),
                          widget.isfrom ?? false
                              ? const SizedBox()
                              : Container(
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 10, right: 225),
                                        child: Text(
                                          "Price Detail",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "MRP (1 item)",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                            Text(
                                              "Rs.${controller.checkOutModel.value.subtotal.toString()}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Delivery free",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Discount",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black54),
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Divider(
                                        // thickness: 2,
                                        color: Colors.black26,
                                        indent: 15,
                                        endIndent: 10,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Total Amount",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Rs.${controller.checkOutModel.value.total.toString()}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(
                                        // thickness: 2,
                                        color: Colors.black26,
                                        indent: 15,
                                        endIndent: 10,
                                      ),
                                      const SizedBox(height: 100),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            child: const MyButton(
                                                text: 'Checkout'),
                                            onTap: () async {
                                              print(
                                                  "l.value.total${controller.checkOutModel.value.total.toString()}");
                                              var data = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PaymentScreenTree()));

                                              if (data != null) {
                                                if (data == "payment") {
                                                  openCheckout(controller
                                                      .checkOutModel.value.total
                                                      .toString());
                                                } else {
                                                  controller
                                                      .placeOrder(
                                                          address_id.toString(),
                                                          "cod")
                                                      .then((value) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return OrderPlaced(
                                                            isFromFuelOnTap:
                                                                true,
                                                            amount:
                                                                "${controller.checkOutModel.value.total}",
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  });
                                                }
                                              }
                                              // d
                                              // controller
                                              //     .placeOrder(
                                              //         address_id.toString(),"")
                                              //     .then((value) {
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //               const PaymentScreenTree()));
                                              // });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      );
              }),
            ),
          );
        });
  }
}
