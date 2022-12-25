import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/dashboard_controller.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';

import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/payment_controller.dart';
import '../models/couponlist_model.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';

class OffersListScreen extends StatefulWidget {
  const OffersListScreen({Key? key}) : super(key: key);

  @override
  State<OffersListScreen> createState() => _OffersListScreenState();
}

class _OffersListScreenState extends State<OffersListScreen> {
  PaymentController? paymentController;
  DashboardController? dashboardController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    paymentController = Get.find<PaymentController>();
    dashboardController = Get.find<DashboardController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //

      dashboardController!.refreshStreamController.stream.listen((list) {
        if (mounted) {
          hideLoader();
          if (list == 'OFFER') {
            paymentController!.getCouponCodeList();
          }
        }
      });
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
                          paymentController!.appBar(false, 'Offer List',
                              kPrimaryColorDark, context, scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Obx(() {
                          return paymentController!.couponList.isNotEmpty
                              ? GridView.builder(
                                  padding: const EdgeInsets.all(10),
                                  // separatorBuilder: (context, index) => const Divider(),
                                  itemCount:
                                      paymentController!.couponList.length,
                                  // controller: paymentController!.controller,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return itemWidget(
                                        paymentController!.couponList[index]);
                                  },
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                          childAspectRatio: 1.8),
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
                      Container(
                        height: 60,
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget itemWidget(CouponListData model) {
    return Container(
      decoration: boxDecorationRevise(kSecondaryColor, kSecondaryColor, 15),
      child: GestureDetector(
          onTap: () {
            // Get.toNamed(AppRoutes.blogdetail);
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Colors.white,
                  strokeWidth: 2,
                  dashPattern: [6],
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: Container(
                      // height: 200,
                      // width: 120,
                      color: kSecondaryColor,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                            // topLeft: Radius.circular(40.0),
                            // bottomLeft: Radius.circular(40.0)
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              // topRight: Radius.circular(40.0),
                              // bottomRight: Radius.circular(40.0),
                              topLeft: Radius.circular(40.0),
                              bottomLeft: Radius.circular(40.0)),
                        ),
                      )
                    ]),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 35, right: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            model.discountType == 1
                                ? '₹' + model.discountValue.toString()
                                : model.discountValue.toString() + '%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kPrimaryColorDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 27),
                          ),
                        )),
                    Expanded(
                        flex: 2,
                        child: Container(
                          // alignment: Alignment.centerLeft,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    model.name.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: kPrimaryColorDark,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    model.description.toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 6,
                                    style: const TextStyle(
                                        color: kPrimaryColorDark,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 8),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // paymentController!.applyCouponCodeFromOffer(
                                    //     model.code.toString());

                                    if (paymentController!.cartCount.value ==
                                            '' ||
                                        paymentController!.cartCount.value ==
                                            '0') {
                                      showFlutterToast('No items on cart');
                                    } else {
                                      getItRegister<Map<String, dynamic>>({
                                        'couponCode': model.code.toString(),
                                        'screen': 'Offer',
                                      }, name: "selected_code");

                                      final data = await Get.toNamed(
                                          AppRoutes.subscriptioncart);
                                      if (data == 'success') {}
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: 5),
                                    color: Colors.transparent,
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 20.w,
                                      width: 60.w,
                                      decoration: boxDecorationValidTill(
                                          kDarkBlueColor,
                                          kPrimaryColorDark,
                                          20),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Redeem',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ]),
                                    ),
                                  ),
                                )
                              ]),
                        ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
