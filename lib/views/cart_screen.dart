import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/models/cart_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../utils/theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  PaymentController? paymentController;

  String? subscriptionId, subscriptionName;

  String? couponCode = '', screen = '';

  // String? couponId = '', couponCode = '';
  // double? couponDiscount = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    paymentController = Get.find<PaymentController>();

    screen =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_code")['screen'];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      paymentController!.getCartDetails();

      if (screen == 'Offer') {
        // setState(() {
        // Future.delayed(const Duration(seconds: 3), () {
        couponCode = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_code")['couponCode'];
        paymentController!.applyCouponCodeFromOffer(couponCode!);
        // });
        // });
      }
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                Obx(
                  () {
                    return Column(
                      children: [
                        paymentController!.appBar(false, 'Subscription Cart',
                            kPrimaryColorDark, context, scaffoldKey),
                        paymentController!.studentCartList.isNotEmpty
                            ? Expanded(
                                child: Container(
                                padding: const EdgeInsets.all(2),
                                child: ListView(
                                  padding: const EdgeInsets.all(5),
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: paymentController!
                                          .studentCartList.length,
                                      scrollDirection: Axis.vertical,
                                      padding: const EdgeInsets.all(0),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 5,
                                              childAspectRatio: 5.5),
                                      itemBuilder: (context, index) {
                                        return itemWidgetSubjectSubscriptionCart(
                                            paymentController!
                                                .studentCartList[index],
                                            index);
                                      },
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      height: 50,
                                      // decoration: BoxDecoration(
                                      //   borderRadius: const BorderRadius.all(
                                      //       Radius.circular(10)),
                                      //   border: Border.all(
                                      //       color: kSecondaryColor, width: 0.5),
                                      // ),
                                      decoration: boxDecorationRectBorder(
                                          Colors.white,
                                          Colors.white,
                                          kSecondaryColor),

                                      child: Row(children: [
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.couponlist);
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    paymentController!
                                                                .couponIdSelected!
                                                                .value !=
                                                            ''
                                                        ? 'Coupon Applied!'
                                                        : 'Apply Coupon',
                                                    style: TextStyle(
                                                        color: paymentController!
                                                                    .couponIdSelected!
                                                                    .value !=
                                                                ''
                                                            ? Colors.green
                                                            : kPrimaryColor),
                                                  ),
                                                  const Icon(Icons
                                                      .arrow_forward_rounded)
                                                ]),
                                          ),
                                        ))
                                      ]),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      // height: 50,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white,
                                            Colors.white,
                                          ],
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            color: kPrimaryColorLightest,
                                            width: 4),
                                      ),
                                      child: Column(children: [
                                        Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Subtotal (' +
                                                      paymentController!
                                                          .studentCartList
                                                          .length
                                                          .toString() +
                                                      ' Subscription)',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                                Text(
                                                  '₹' +
                                                      paymentController!
                                                          .subtotal!.value
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                              ]),
                                        ),
                                        paymentController!.couponIdSelected !=
                                                ''
                                            ? Container(
                                                color: Colors.transparent,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Coupon Discount (' +
                                                            paymentController!
                                                                .couponCodeSelected!
                                                                .value +
                                                            ')',
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: kTextColor),
                                                      ),
                                                      Text(
                                                        '₹' +
                                                            paymentController!
                                                                .couponDiscountSelected!
                                                                .value
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: kTextColor),
                                                      ),
                                                    ]),
                                              )
                                            : Container(),
                                        paymentController!.couponIdSelected !=
                                                ''
                                            ? Container(
                                                color: Colors.transparent,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Taxable Amount',
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: kTextColor),
                                                      ),
                                                      Text(
                                                        '₹' +
                                                            paymentController!
                                                                .taxableAmt!
                                                                .value
                                                                .toStringAsFixed(
                                                                    2),
                                                        style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: kTextColor),
                                                      ),
                                                    ]),
                                              )
                                            : Container(),
                                        Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'CGST @' +
                                                      paymentController!.cgstPer
                                                          .toString() +
                                                      '%',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                                Text(
                                                  '₹' +
                                                      paymentController!
                                                          .cgstAmt!.value
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'SGST @' +
                                                      paymentController!.sgstPer
                                                          .toString() +
                                                      '%',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                                Text(
                                                  '₹' +
                                                      paymentController!
                                                          .sgstAmt!.value
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Total Tax',
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                                Text(
                                                  '₹' +
                                                      paymentController!
                                                          .totalTaxAmt!.value
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: kTextColor),
                                                ),
                                              ]),
                                        ),
                                        Container(
                                          color: kSecondaryColor,
                                          height: 1,
                                          padding: const EdgeInsets.all(10),
                                        ),
                                        Container(
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'Amount Payable',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  '₹' +
                                                      paymentController!
                                                          .grandTotal!.value
                                                          .toStringAsFixed(2),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              ]),
                                        ),
                                      ]),
                                    )
                                  ],
                                ),
                              ))
                            : Expanded(
                                child: Container(
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
                                ),
                              ),
                        paymentController!.studentCartList.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.billinginformation);
                                },
                                child: Container(
                                  height: 45,
                                  margin: const EdgeInsets.only(
                                      top: 12, bottom: 12, right: 20, left: 20),
                                  decoration: boxDecorationValidTill(
                                      kPrimaryColor, kPrimaryColorLight, 50),
                                  child: Center(
                                    child: Text(
                                      'Continue',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  },
                )
              ],
            )),
      ),
    );
  }

  Widget itemWidgetSubjectSubscriptionCart(StudentCart model, int index) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: 25,
                // margin: const EdgeInsets.all(5),
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/images/gateimg.svg',
                  width: 20.w,
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   model.name!,
                    //   overflow: TextOverflow.ellipsis,
                    //   maxLines: 1,
                    //   style: TextStyle(
                    //     color: kPrimaryColorDark,
                    //     fontSize: 10,
                    //   ),
                    // ),
                    Text(
                      model.name!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: kPrimaryColorDark,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Gate EE',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   '₹' + model.dummyPrice.toString() + '/-',
                    //   maxLines: 1,
                    //   overflow: TextOverflow.ellipsis,
                    //   textAlign: TextAlign.left,
                    //   style: (model.dummyPrice!.toDouble() !=
                    //           model.price!.toDouble())
                    //       ? TextStyle(
                    //           fontSize: 10.sp,
                    //           color: Colors.black,
                    //           decoration: TextDecoration.lineThrough)
                    //       : TextStyle(
                    //           fontSize: 10.sp,
                    //           color: Colors.black,
                    //         ),
                    // ),
                    (model.dummyPrice!.toDouble() != model.price!.toDouble())
                        ? Text(
                            '₹' + model.price.toString() + '/-',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: kPrimaryColor,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  paymentController!.removeCartItem(model.id!.toString());
                },
                child: Container(
                  height: 25.w,
                  width: 25.w,
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  // decoration: boxDecorationStep(kPrimaryColorDarkLight,
                  //     kPrimaryColorDark, kPrimaryColorDark),
                  child: const Icon(
                    Icons.cancel,
                    color: kPrimaryColorDark,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 6.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
