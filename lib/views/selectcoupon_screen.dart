import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/models/couponlist_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/payment_controller.dart';
import '../utils/theme.dart';

class SelectCouponScreen extends StatefulWidget {
  const SelectCouponScreen({Key? key}) : super(key: key);

  @override
  State<SelectCouponScreen> createState() => _SelectCouponScreenState();
}

class _SelectCouponScreenState extends State<SelectCouponScreen> {
  PaymentController? paymentController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    paymentController = Get.find<PaymentController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      paymentController!.getCouponCodeList();
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
                          paymentController!.appBar(false, 'Select Coupon',
                              kPrimaryColorDark, context, scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Obx(() {
                          return GridView.builder(
                            padding: const EdgeInsets.all(10),
                            // separatorBuilder: (context, index) => const Divider(),
                            itemCount: paymentController!.couponList.length,
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
                                    childAspectRatio: 2.2),
                          );
                        }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Expanded(
                          //   child: GestureDetector(
                          //     onTap: () async {
                          //       paymentController!.clearData();
                          //       getItRegister<Map<String, dynamic>>({
                          //         'isEdit': '',
                          //       }, name: "selected_billing");
                          //       final data = await Get.toNamed(
                          //           AppRoutes.addeditbillinginfo);
                          //       if (data == 'success') {
                          //         paymentController!.getBillingList();
                          //       }
                          //     },
                          //     child: Container(
                          //       height: 45,
                          //       margin: const EdgeInsets.only(
                          //           top: 12, bottom: 12, right: 20, left: 20),
                          //       decoration: boxDecorationValidTill(
                          //           kPrimaryColorDark,
                          //           kPrimaryColorDarkLight,
                          //           50),
                          //       child: const Center(
                          //         child: const Text(
                          //           "Add New",
                          //           style: const TextStyle(
                          //             fontSize: 14.0,
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                paymentController!.onApplyCoupon();
                              },
                              child: Container(
                                height: 45,
                                margin: const EdgeInsets.only(
                                    top: 12, bottom: 12, right: 20, left: 20),
                                decoration: boxDecorationValidTill(
                                    kPrimaryColor, kPrimaryColorLight, 50),
                                child: Center(
                                  child: Text(
                                    "Apply Coupon",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
          onTap: () {
            // Get.toNamed(AppRoutes.blogdetail);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 10,
                  top: 10,
                ),
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (paymentController!.couponId!.value ==
                                          model.id!.toString()) {
                                        paymentController!.couponId!.value = '';
                                        paymentController!.couponName!.value =
                                            '';
                                      } else {
                                        paymentController!.couponId!.value =
                                            model.id!.toString();
                                        paymentController!.couponName!.value =
                                            model.name.toString();
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 15,
                                    width: 15,
                                    child: SvgPicture.asset(
                                      model.id.toString() ==
                                              paymentController!.couponId!.value
                                          ? 'assets/images/squaretick.svg'
                                          : 'assets/images/squareborder.svg',
                                      width: 15,
                                      color: model.id.toString() ==
                                              paymentController!.couponId!.value
                                          ? kPrimaryColor
                                          : kSecondaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    model.code!,
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        margin: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: Text(
                          model.name!,
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: kDarkBlueColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        margin: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: Text(
                          model.description!,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: kTextColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                ),
                alignment: Alignment.center,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        margin: const EdgeInsets.only(right: 10),
                      ),
                      Expanded(
                        child: Text(
                          'Expires by : ' +
                              Jiffy(model.endDate, "yyyy-MM-dd HH:mm:ss")
                                  .format("dd-MM-yyyy h:mm a"),
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: kTextColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ]),
              ),
            ],
          )),
    );
  }
}
