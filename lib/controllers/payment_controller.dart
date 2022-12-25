import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_practicekiya/models/billinglist_model.dart';
import 'package:flutter_practicekiya/models/cart_model.dart';
import 'package:flutter_practicekiya/models/couponapply_model.dart';
import 'package:flutter_practicekiya/models/couponlist_model.dart';
import 'package:flutter_practicekiya/models/general_model.dart';
import 'package:flutter_practicekiya/models/orderhistory_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../models/home_model.dart';
import '../models/maincategory_model.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';

import '../utils/functions.dart';
import '../utils/preferences.dart';
import '../utils/theme.dart';

class PaymentController extends GetxController {
  final GlobalKey<FormState> billingFormKey = GlobalKey<FormState>();

  final Completer<InAppWebViewController> inAppWebviewController =
      Completer<InAppWebViewController>();

  StreamController<String> backController = StreamController.broadcast();

  TextEditingController? emailController,
      mobileController,
      fullnameController,
      addressoneController,
      addresstwoController,
      addressthreeController,
      pincodeController,
      couponcodeController;

  Prefs prefs = Prefs.prefs;

  var isLoading = true.obs;

  List<BillingInformationData> billingList =
      List<BillingInformationData>.empty(growable: true).obs;

  List<StudentCart> studentCartList =
      List<StudentCart>.empty(growable: true).obs;

  List<CouponListData> couponList =
      List<CouponListData>.empty(growable: true).obs;

  RxString? couponId = ''.obs;
  RxString? couponName = ''.obs;

  RxString? couponIdSelected = ''.obs;
  RxString? couponCodeSelected = ''.obs;
  RxDouble? couponDiscountSelected = 0.0.obs;

  RxDouble? subtotal = 0.0.obs,
      tempSubtotal = 0.0.obs,
      taxableAmt = 0.0.obs,
      sgstAmt = 0.0.obs,
      cgstAmt = 0.0.obs,
      totalTaxAmt = 0.0.obs,
      grandTotal = 0.0.obs;

  int sgstPer = 0, cgstPer = 0;

  RxString? paymentLink = ''.obs;

  String? examId, examName, screen, comboId, comboName;

  RxString cartCount = '0'.obs;

  List<OrderHistoryData> orderHistoryList =
      List<OrderHistoryData>.empty(growable: true).obs;

  RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();

    emailController = TextEditingController();

    fullnameController = TextEditingController();
    addressoneController = TextEditingController();
    addresstwoController = TextEditingController();
    mobileController = TextEditingController();
    addressthreeController = TextEditingController();
    pincodeController = TextEditingController();
    couponcodeController = TextEditingController();
  }

  @override
  void onClose() {
    clearData();
  }

  void setCartCount() async {
    cartCount.value = await prefs.getCartCount();
  }

  void clearData() {
    emailController!.clear();

    fullnameController!.clear();
    addressoneController!.clear();
    addresstwoController!.clear();
    mobileController!.clear();
    addressthreeController!.clear();
    pincodeController!.clear();
    couponcodeController!.clear();
  }

  void calculation() {
    subtotal!.value = 0.0;
    tempSubtotal!.value = 0.0;
    taxableAmt!.value = 0.0;
    sgstAmt!.value = 0.0;
    cgstAmt!.value = 0.0;
    totalTaxAmt!.value = 0.0;
    grandTotal!.value = 0.0;

    for (int i = 0; i < studentCartList.length; i++) {
      tempSubtotal!.value =
          tempSubtotal!.value + studentCartList[i].price!.toDouble();
    }

    print('tempSubtotal->' + tempSubtotal!.value.toString());
    print('cgstPer + sgstPer->' + (cgstPer + sgstPer).toString());

    subtotal!.value = (tempSubtotal!.value * 100) / 118;

    print('subtotal->' + subtotal!.value.toString());

    print(
        'couponDiscountSelected->' + couponDiscountSelected!.value.toString());

    if (couponIdSelected!.value != '') {
      taxableAmt!.value = subtotal!.value - couponDiscountSelected!.value;
    } else {
      taxableAmt!.value = subtotal!.value;
    }

    print('taxableAmt->' + taxableAmt!.value.toString());

    sgstAmt!.value = (taxableAmt!.value * sgstPer) / 100;
    cgstAmt!.value = (taxableAmt!.value * cgstPer) / 100;

    totalTaxAmt!.value = sgstAmt!.value + cgstAmt!.value;

    grandTotal!.value = taxableAmt!.value + totalTaxAmt!.value;
    print('grandTotal->' + grandTotal!.value.toString());
  }

  void onApplyCoupon() {
    bool isCoupon = false;
    for (int i = 0; i < couponList.length; i++) {
      if (couponId.toString() == couponList[i].id.toString()) {
        isCoupon = true;
        applyCouponCode(couponList[i].code.toString());
      }
    }

    if (!isCoupon) {
      couponIdSelected!.value = '';
      couponCodeSelected!.value = '';
      couponDiscountSelected!.value = 0.0;
      Get.back(result: 'success');
      calculation();
    }
  }

  void checkBilling(String isEdit, String billingId) {
    final isValid = billingFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (isEdit == '1') {
      editBillingInformation(
          billingId,
          fullnameController!.text,
          mobileController!.text,
          emailController!.text,
          addressoneController!.text,
          addresstwoController!.text,
          addressthreeController!.text,
          pincodeController!.text);
    } else {
      addBillingInformation(
          fullnameController!.text,
          mobileController!.text,
          emailController!.text,
          addressoneController!.text,
          addresstwoController!.text,
          addressthreeController!.text,
          pincodeController!.text);
    }
  }

  void addBillingInformation(
      String name,
      String mobile,
      String email,
      String addressone,
      String addresstwo,
      String addressthree,
      String pincode) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance
          .addBillingInformation(name, mobile, email, addressone, addresstwo,
              addressthree, pincode);

      if (model!.status!) {
        Get.back(result: 'success');
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void editBillingInformation(
      String billingid,
      String name,
      String mobile,
      String email,
      String addressone,
      String addresstwo,
      String addressthree,
      String pincode) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance
          .editBillingInformation(billingid, name, mobile, email, addressone,
              addresstwo, addressthree, pincode);

      if (model!.status!) {
        Get.back(result: 'success');
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getBillingList() async {
    try {
      showLoader();

      isLoading(true);

      billingList.clear();

      BillingListModel? model = await RemoteServices.instance.getBillingList();

      billingList.addAll(model!.data!);
      if (billingList.isEmpty) {
        hideLoader();
        clearData();
        getItRegister<Map<String, dynamic>>({
          'isEdit': '',
        }, name: "selected_billing");
        final data = await Get.toNamed(AppRoutes.addeditbillinginfo);
        if (data == 'success') {
          getBillingList();
        }
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void setDefaultBilling(
    String billingid,
  ) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.setDefaultBilling(billingid);

      if (model!.status!) {
        getBillingList();
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getCartDetails() async {
    try {
      showLoader();

      isLoading(true);

      studentCartList.clear();
      sgstPer = 0;
      cgstPer = 0;

      CartModel? model = await RemoteServices.instance.getCartDetails();

      studentCartList.addAll(model!.studentCart!);
      sgstPer = model.gst!.sgst!;
      cgstPer = model.gst!.cgst!;

      cartCount.value = studentCartList.length.toString();
      prefs.setCartCount(cartCount.value);

      calculation();
    } finally {
      hideLoader();
      isLoading(false);
    }
  }

  void addToCart(String subscriptionid, String type, String from,
      String duration, String price) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance.addToCart(
          subscriptionid,
          type == '1'
              ? 'practice'
              : type == '2'
                  ? 'test'
                  : 'pyq',
          duration,
          price);

      if (model!.status!) {
        cartCount.value = model.carttotal.toString();
        prefs.setCartCount(cartCount.value);
        print(cartCount.value);
        if (from == 'S') {
          getItRegister<Map<String, dynamic>>({
            'couponCode': '',
            'screen': 'Cart',
          }, name: "selected_code");
          final data = await Get.toNamed(AppRoutes.subscriptioncart);
          if (data == 'success') {}
        }
        showFlutterToast('Successfully added to cart');

        couponIdSelected!.value = '';
        couponCodeSelected!.value = '';
        couponDiscountSelected!.value = 0.0;

        calculation();
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void removeCartItem(
    String cartid,
  ) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.removeCartItem(cartid);

      if (model!.status!) {
        cartCount.value = model.carttotal.toString();
        prefs.setCartCount(cartCount.value);
        getCartDetails();
        couponIdSelected!.value = '';
        couponCodeSelected!.value = '';
        couponDiscountSelected!.value = 0.0;

        calculation();
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getCouponCodeList() async {
    try {
      showLoader();

      isLoading(true);

      couponList.clear();

      CouponListModel? model =
          await RemoteServices.instance.getCouponCodeList();

      couponList.addAll(model!.data!);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void applyCouponCode(
    String couponcode,
  ) async {
    try {
      showLoader();

      isLoading(true);

      CouponApplyModel? model =
          await RemoteServices.instance.applyCouponCode(couponcode);

      if (model!.status!) {
        couponIdSelected!.value = couponId.toString();
        couponCodeSelected!.value = model.data!.code!.toString();
        couponDiscountSelected!.value =
            double.parse(model.data!.discount!.toString());

        Get.back();
        calculation();
      } else {}
    } finally {
      hideLoader();
      isLoading(false);
    }
  }

  void applyCouponCodeFromOffer(
    String couponcode,
  ) async {
    try {
      showLoader();

      isLoading(true);

      print('VVVVVVV');

      CouponApplyModel? model =
          await RemoteServices.instance.applyCouponCode(couponcode);

      if (model!.status!) {
        couponId!.value = model.data!.id.toString();
        couponCodeSelected!.value = model.data!.code.toString();
        couponDiscountSelected!.value =
            double.parse(model.data!.discount!.toString());

        couponIdSelected!.value = couponId.toString();
        couponCodeSelected!.value = model.data!.code!.toString();
        couponDiscountSelected!.value =
            double.parse(model.data!.discount!.toString());

        // Get.back();
        calculation();
      } else {
        couponIdSelected!.value = '';
        couponCodeSelected!.value = '';
        couponDiscountSelected!.value = 0.0;
        // Get.back(result: 'success');
        calculation();
      }
    } finally {
      hideLoader();
      isLoading(false);
    }
  }

  void doCheckoutPayment(
    String couponcode,
  ) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.doCheckoutPayment(couponcode);

      if (model!.status!) {
        hideLoader();
        paymentLink!.value = model.link!;
        final data = await Get.toNamed(AppRoutes.paymentwebview);
        if (data == 'success') {
          // getChapterList(true, subjectId!);
        }
      }
    } finally {
      hideLoader();
      isLoading(false);
    }
  }

  void getLogout() async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance.getLogout();

      if (model!.status!) {
        hideLoader();
        prefs.getAllPrefsClear();
        Get.offAndToNamed(AppRoutes.login);
      }
    } finally {
      hideLoader();
      isLoading(false);
    }
  }

  void getHomeData() async {
    try {
      String goalid = await prefs.getDefaultGoal();

      if (goalid == '0' || goalid == '') {
        goalid = await prefs.getDefaultGoal();
      }
      HomeModel? model = await RemoteServices.instance.getHomeData(goalid);
      unreadCount.value = model!.unreadNotification!;
      print('unreadCount->' + unreadCount.value.toString());
    } finally {
      isLoading(false);
    }
  }

  Widget appBar(bool isDashboard, String title, Color barColor,
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    return Obx(
      () {
        return AppBar(
          toolbarHeight: 45,
          backgroundColor: barColor,
          elevation: 0,
          leadingWidth: 30,
          leading: isDashboard
              ? GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.all(5),
                    height: 25,
                    width: 25,
                    child: const Image(
                      color: Colors.white,
                      image: AssetImage(
                        'assets/images/menu.png',
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    if (title == 'Offer List' ||
                        title == 'Plan List' ||
                        title == 'Edit Profile') {
                      backController.sink.add("BACK");
                    } else if (title == 'Score Card') {
                      String scoreFrom = GetIt.I<Map<String, dynamic>>(
                          instanceName: "selected_score")['scoreFrom'];
                      if (scoreFrom == 'TEST') {
                        Get.back(result: 'success');
                        Get.back(result: 'success');
                      } else {
                        Get.back(result: 'success');
                      }
                    } else {
                      Get.back(result: 'success');
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.all(5),
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      'assets/images/backarrow.svg',
                      width: 25,
                    ),
                  ),
                ),
          title: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.reminder);
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                height: 20,
                width: 20,
                child: const Image(
                  color: Colors.white,
                  image: AssetImage(
                    'assets/images/alarm.png',
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notificationlist);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: 20,
                    width: 20,
                    child: const Image(
                      color: Colors.white,
                      image: AssetImage(
                        'assets/images/notification.png',
                      ),
                    ),
                  ),
                  (unreadCount.value != 0)
                      ? Container(
                          height: 25,
                          width: 25,
                          alignment: Alignment.topRight,
                          child: Container(
                              height: 12,
                              width: 20,
                              alignment: Alignment.center,
                              decoration: boxDecorationStep(
                                  kPrimaryColor, kPrimaryColor, kPrimaryColor),
                              child: Text(
                                unreadCount.value.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 8.sp, color: Colors.white),
                              )),
                        )
                      : Container(),
                ],
              ),

              //  Container(
              //   margin: const EdgeInsets.all(5),
              //   height: 20,
              //   width: 20,
              //   child: const Image(
              //     color: Colors.white,
              //     image: AssetImage(
              //       'assets/images/notification.png',
              //     ),
              //   ),
              // ),
            ),
            GestureDetector(
              onTap: () {
                getItRegister<Map<String, dynamic>>({
                  'couponCode': '',
                  'screen': 'CartIcon',
                }, name: "selected_code");
                Get.toNamed(AppRoutes.subscriptioncart);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    height: 20,
                    width: 20,
                    child: const Image(
                      color: Colors.white,
                      image: AssetImage(
                        'assets/images/cart.png',
                      ),
                    ),
                  ),
                  (cartCount.value != '0' && cartCount.value != '')
                      ? Container(
                          height: 20,
                          width: 20,
                          alignment: Alignment.topRight,
                          child: Container(
                              height: 12,
                              width: 20,
                              decoration: boxDecorationStep(
                                  kPrimaryColor, kPrimaryColor, kPrimaryColor),
                              alignment: Alignment.center,
                              child: Text(
                                cartCount.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 8.sp, color: Colors.white),
                              )),
                        )
                      : Container(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                logoutDialog(context);
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                height: 20,
                width: 20,
                child: const Image(
                  color: Colors.white,
                  image: AssetImage(
                    'assets/images/logout.png',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void getOrderHistoryList() async {
    try {
      showLoader();

      isLoading(true);

      orderHistoryList.clear();
      OrderHistoryModel? model =
          await RemoteServices.instance.getOrderHistoryList();

      orderHistoryList.addAll(model!.data!);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void addContactInfo(
    String name,
    String mobile,
    String email,
    String comment,
  ) async {
    try {
      showLoader();

      isLoading(true);

      GeneralModel? model = await RemoteServices.instance
          .addContactInfo(name, mobile, email, comment);

      if (model!.status!) {
        showFlutterToast(model.message!);
        Get.back();
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(10),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
            title: Text(
              "Logout",
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
              textAlign: TextAlign.left,
            ),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                  child: Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text('Are you sure you want to logout?',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: kTextColor))),
                ),
              ],
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      getLogout();
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationValidTill(
                          kPrimaryColorDark, kPrimaryColorDarkLight, 10),
                      child: Center(
                        child: Text(
                          "Logout",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationRectBorder(
                          Colors.white, Colors.white, kDarkBlueColor),
                      child: Center(
                        child: Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: kDarkBlueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }));
  }

  void exitDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
            title: const Text(
              "Exit",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
              textAlign: TextAlign.left,
            ),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                  child: Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text('Are you sure you want to exit PracticeKiya?',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor))),
                ),
              ],
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationValidTill(
                          kPrimaryColorDark, kPrimaryColorDarkLight, 10),
                      child: const Center(
                        child: Text(
                          "Exit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationRectBorder(
                          Colors.white, Colors.white, kDarkBlueColor),
                      child: const Center(
                        child: Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: kDarkBlueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }));
  }
}
