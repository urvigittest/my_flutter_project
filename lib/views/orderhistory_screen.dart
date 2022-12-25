import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';

import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/orderhistory_screen.dart';
import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  PaymentController? paymentController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final PermissionHandlerPlatform _permissionHandler =
      PermissionHandlerPlatform.instance;

  @override
  void initState() {
    super.initState();

    paymentController = Get.find<PaymentController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      paymentController!.getOrderHistoryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/wholeappback.jpg'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          // border: Border.all(color: kPrimaryColorDark),
                          color: kPrimaryColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(children: [
                          paymentController!.appBar(false, 'Order History',
                              kPrimaryColorDark, context, scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Obx(() {
                          return paymentController!.orderHistoryList.isNotEmpty
                              ? GridView.builder(
                                  padding: const EdgeInsets.all(10),
                                  // separatorBuilder: (context, index) => const Divider(),
                                  itemCount: paymentController!
                                      .orderHistoryList.length,
                                  // controller: paymentController!.controller,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return itemWidget(
                                        paymentController!
                                            .orderHistoryList[index],
                                        index);
                                  },
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: 4.7),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          // margin: const EdgeInsets.only(right: 5),
                                          alignment: Alignment.topRight,
                                          child: SvgPicture.asset(
                                            'assets/images/datanotfound.svg',
                                            // width: 15,
                                          ),
                                        ),
                                        Text(
                                          'Data not found',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: kTextColor),
                                        )
                                      ]),
                                );
                        }),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget itemWidget(OrderHistoryData model, int index) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Container(
                height: 25,
                width: 25,
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: boxDecorationStep(kPrimaryColorDarkLight,
                    kPrimaryColorDark, kPrimaryColorDark),
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '#' + model.id.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: kDarkBlueColor,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '₹' + model.totalAmount!.toStringAsFixed(2) + '/-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    // showFlutterToast('in progress');
                    // String fileName =
                    //               path.substring(path.lastIndexOf('/') + 1);
                    print('http://3.6.36.232/practice_kiya/api/generate_pdf/' +
                        model.orderidenc.toString());

                    // getItRegister<Map<String, dynamic>>({
                    //   'pdfUrl':
                    //       'http://3.6.36.232/practice_kiya/api/generate_pdf/' +
                    //           model.orderidenc.toString(),
                    //   'pfdTitle': 'PDF FILE',
                    // }, name: "selected_pdf");
                    // Get.toNamed(AppRoutes.pdfviewpage);

                    // launchIn(
                    //     'http://3.6.36.232/practice_kiya/api/generate_pdf/' +
                    //         model.orderidenc.toString());

                    downloadFile(
                        'http://3.6.36.232/practice_kiya/api/generate_pdf/' +
                            model.orderidenc.toString(),
                        "Practicekiya" +
                            DateTime.now()
                                .millisecondsSinceEpoch
                                .remainder(100000)
                                .toString() +
                            ".pdf");
                  },
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 2, left: 2),
                    decoration: boxDecorationValidTill(
                        kPrimaryColor, kPrimaryColor, 20),
                    child: Center(
                      child: Text(
                        'Invoice',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void downloadFile(String sourcePath, String fileName) async {
    Map<Permission, PermissionStatus> statuses =
        await _permissionHandler.requestPermissions(
      [
        Permission.storage,
      ],
    );

    if (statuses[Permission.storage]!.isGranted) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = appDocDir.path + "/$fileName";
      if (kDebugMode) {
        print("savePath = $savePath");
      }

      try {
        showLoader();
        await Dio().download(sourcePath, savePath,
            onReceiveProgress: (received, total) {
          if (total != -1) {
            //print((received / total * 100).toStringAsFixed(0) + "%");
            //you can build progressbar feature too
          }
        });
        OpenFile.open(savePath);
      } on DioError catch (e) {
        hideLoader();
        if (kDebugMode) {
          print(e.message);
        }
      } finally {
        hideLoader();
      }
    }
  }
}
