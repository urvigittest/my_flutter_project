import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/controllers/payment_controller.dart';
import 'package:flutter_practicekiya/models/billinglist_model.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/theme.dart';

class BillingInformationScreen extends StatefulWidget {
  const BillingInformationScreen({Key? key}) : super(key: key);

  @override
  State<BillingInformationScreen> createState() =>
      _BillingInformationScreenState();
}

class _BillingInformationScreenState extends State<BillingInformationScreen> {
  PaymentController? paymentController;
  String? subscriptionId, subscriptionName, screen;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    paymentController = Get.find<PaymentController>();

    // subscriptionId = GetIt.I<Map<String, dynamic>>(
    //     instanceName: "selected_subscription")['subscriptionId'];
    // subscriptionName = GetIt.I<Map<String, dynamic>>(
    //     instanceName: "selected_subscription")['subscriptionName'];
    // screen = GetIt.I<Map<String, dynamic>>(
    //     instanceName: "selected_subscription")['screen'];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      paymentController!.getBillingList();
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
                          paymentController!.appBar(
                              false,
                              'Billing Information',
                              kPrimaryColorDark,
                              context,
                              scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Obx(() {
                          return GridView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: paymentController!.billingList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return itemWidget(
                                  paymentController!.billingList[index]);
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
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                paymentController!.clearData();

                                getItRegister<Map<String, dynamic>>({
                                  'isEdit': '',
                                }, name: "selected_billing");

                                final data = await Get.toNamed(
                                    AppRoutes.addeditbillinginfo);
                                if (data == 'success') {
                                  paymentController!.getBillingList();
                                }
                              },
                              child: Container(
                                height: 45,
                                margin: const EdgeInsets.only(
                                    top: 12, bottom: 12, right: 20, left: 20),
                                decoration: boxDecorationValidTill(
                                    kPrimaryColorDark,
                                    kPrimaryColorDarkLight,
                                    50),
                                child: Center(
                                  child: Text(
                                    "Add New",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                paymentController!.doCheckoutPayment(
                                    paymentController!
                                        .couponCodeSelected!.value);
                              },
                              child: Container(
                                height: 45,
                                margin: const EdgeInsets.only(
                                    top: 12, bottom: 12, right: 20, left: 20),
                                decoration: boxDecorationValidTill(
                                    kPrimaryColor, kPrimaryColorLight, 50),
                                child: Center(
                                  child: Text(
                                    "Checkout",
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

  Widget itemWidget(BillingInformationData model) {
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
                                    if (model.isDefaultAddress != 1) {
                                      paymentController!.setDefaultBilling(
                                          model.id!.toString());
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 15,
                                    width: 15,
                                    child: SvgPicture.asset(
                                      'assets/images/radio_button.svg',
                                      width: 15,
                                      color: model.isDefaultAddress == 1
                                          ? kPrimaryColorDark
                                          : kSecondaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    model.fullname!,
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
                      GestureDetector(
                        onTap: () async {
                          paymentController!.clearData();
                          getItRegister<Map<String, dynamic>>({
                            'isEdit': '1',
                            'billingData': model,
                          }, name: "selected_billing");
                          final data =
                              await Get.toNamed(AppRoutes.addeditbillinginfo);
                          if (data == 'success') {
                            paymentController!.getBillingList();
                          }
                        },
                        child: const SizedBox(
                          height: 15,
                          width: 15,
                          child: Image(
                            color: kPrimaryColorDark,
                            image: AssetImage(
                              'assets/images/edit.png',
                            ),
                          ),
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
                        child: const Icon(
                          Icons.call,
                          size: 15,
                          color: kDarkBlueColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '+91 ' + model.mobile!,
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
                        child: const Icon(
                          Icons.email,
                          size: 15,
                          color: kDarkBlueColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          model.email!,
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
                        child: const Icon(
                          Icons.location_pin,
                          size: 15,
                          color: kDarkBlueColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          model.addressOne! +
                              ', ' +
                              model.addressTwo! +
                              ', ' +
                              model.addressThree! +
                              ', ' +
                              model.pincode!,
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
              )
            ],
          )),
    );
  }
}
