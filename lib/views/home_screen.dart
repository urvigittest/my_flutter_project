import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_practicekiya/controllers/dashboard_controller.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';
import 'package:flutter_practicekiya/controllers/listing_controller.dart';
import 'package:flutter_practicekiya/models/home_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/login_controller.dart';
import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/functions.dart';
import '../utils/notifier_helper.dart';
import '../utils/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController? homeController;
  PaymentController? paymentController;
  LoginController? loginController;
  DashboardController? dashboardController;
  ListingController? listingController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
    paymentController = Get.find<PaymentController>();
    loginController = Get.find<LoginController>();
    dashboardController = Get.find<DashboardController>();
    listingController = Get.find<ListingController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loginController!.getProfile();
      homeController!.getHomeData(true);
      paymentController!.setCartCount();
      paymentController!.getHomeData();
      dashboardController!.refreshStreamController.stream.listen((list) {
        if (mounted) {
          hideLoader();
          if (list == 'HOME') {
            print('CALED HOME');
            // homeController!.setSelected(0);

            loginController!.getProfile();
            homeController!.getHomeData(true);
            paymentController!.setCartCount();
            paymentController!.getHomeData();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: [
            Container(
                height: 150.h,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/appbar_back.png'),
                    fit: BoxFit.fill,
                  ),
                  // border: Border.all(color: kPrimaryColorDark),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Obx(
                  () {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 0.0,
                                              color: Colors.black26,
                                              offset: Offset(1.0, 10.0),
                                              blurRadius: 20.0),
                                        ],
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          loginController!
                                              .uploadProfileDialog(context);
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(75.0),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/images/user_placeholder.png",
                                            imageErrorBuilder:
                                                (context, url, error) =>
                                                    const Image(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  'assets/images/user_placeholder.png'),
                                            ),
                                            fit: BoxFit.cover,
                                            height: 70,
                                            width: 70,
                                            image: (loginController!.loginModel
                                                        .value.data ==
                                                    null)
                                                ? ""
                                                : RemoteServices.imageMainLink +
                                                    loginController!.loginModel
                                                        .value.data!.image!,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                      width: 15.w,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/editprofile.png',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.back();
                                    Get.toNamed(AppRoutes.editprofile);
                                  },
                                  child: Column(
                                    children: [
                                      Obx(
                                        () {
                                          return Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  loginController!
                                                          .loginModel
                                                          .value
                                                          .data!
                                                          .firstname! +
                                                      ' ' +
                                                      loginController!
                                                          .loginModel
                                                          .value
                                                          .data!
                                                          .lastname!,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                height: 10.h,
                                                width: 10.w,
                                                margin: const EdgeInsets.only(
                                                    left: 5),
                                                child: const Image(
                                                  color: Colors.white,
                                                  image: AssetImage(
                                                    'assets/images/edit.png',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      Obx(
                                        () {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  loginController!.loginModel
                                                      .value.data!.email!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      Obx(
                                        () {
                                          return Row(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Text(
                                                  '+91 ' +
                                                      loginController!
                                                          .loginModel
                                                          .value
                                                          .data!
                                                          .mobile!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                height: 15.h,
                                                width: 15.w,
                                                child: const Image(
                                                  image: AssetImage(
                                                    'assets/images/verified.png',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ]);
                  },
                )),
            ListView(
              shrinkWrap: true,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    dashboardController!.tabIndex.value = 2;
                    dashboardController!.changeTabIndex(2);
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/subscription.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'My Subscriptions',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.orderhistory);
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/myorder.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'My Orders',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    dashboardController!.tabIndex.value = 1;
                    dashboardController!.changeTabIndex(1);
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/offercoupon.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Offers & Coupons',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                  height: 0.5,
                  color: kSecondaryColor,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.reminder);
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/reminder.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Reminder',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.bloglist);
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/blogupdate.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Blogs & Updates',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    dashboardController!.tabIndex.value = 3;
                    dashboardController!.changeTabIndex(3);
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/userprofile.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'User Profile',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.contactform);
                  },
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/helpsupport.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Help & Support',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/notificationonoff.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Notifications',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Obx(
                      () => Switch(
                          onChanged: (val) {
                            loginController!.toggleNotification();
                          },
                          value: loginController!.onNotification.value),
                    )
                  ]),
                ),
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 20.h,
                      width: 20.w,
                      child: const Image(
                        image: AssetImage(
                          'assets/images/darklight.png',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: const Text(
                        'Dark Theme',
                        style: TextStyle(
                            color: kPrimaryColorDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Obx(
                      () => Switch(
                          onChanged: (val) {
                            loginController!.toggleDarkTheme();
                          },
                          value: loginController!.onDarkTheme.value),
                    )
                  ]),
                ),
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height / 1.085,
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
                    Expanded(
                      flex: 4,
                      child: Container(
                        // height: 150,
                        // alignment: ,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/appbar_back.png'),
                            fit: BoxFit.fill,
                          ),
                          // border: Border.all(color: kPrimaryColorDark),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          children: [
                            paymentController!.appBar(true, 'Dashboard',
                                Colors.transparent, context, scaffoldKey),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(
                                  () {
                                    return Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: 55,
                                          width: 55,
                                          padding: const EdgeInsets.all(2),
                                          margin: const EdgeInsets.all(5),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 0.0,
                                                  color: Colors.black26,
                                                  offset: Offset(1.0, 10.0),
                                                  blurRadius: 20.0),
                                            ],
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(75.0),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/images/user_placeholder.png",
                                                imageErrorBuilder:
                                                    (context, url, error) =>
                                                        const Image(
                                                  alignment: Alignment.center,
                                                  image: AssetImage(
                                                      'assets/images/user_placeholder.png'),
                                                ),
                                                fit: BoxFit.cover,
                                                height: 55,
                                                width: 55,
                                                image: (loginController!
                                                            .loginModel
                                                            .value
                                                            .data ==
                                                        null)
                                                    ? ""
                                                    : RemoteServices
                                                            .imageMainLink +
                                                        loginController!
                                                            .loginModel
                                                            .value
                                                            .data!
                                                            .image!,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   height: 15.h,
                                        //   width: 15.w,
                                        //   child: const Image(
                                        //     image: AssetImage(
                                        //       'assets/images/editprofile.png',
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    );
                                  },
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Obx(
                                        () {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${loginController!.loginModel.value.data?.firstname ?? ''} ${loginController!.loginModel.value.data?.lastname ?? ''}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              // Container(
                                              //   height: 10.h,
                                              //   width: 10.w,
                                              //   margin: const EdgeInsets.only(
                                              //       left: 5),
                                              //   child: const Image(
                                              //     color: Colors.white,
                                              //     image: AssetImage(
                                              //       'assets/images/edit.png',
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                        width: 100.w,
                                        child: Obx(
                                          () => Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: DropdownButtonFormField(
                                              value: homeController!
                                                  .selectedCourseId!.value,
                                              onChanged:
                                                  (dynamic newVal) async {
                                                // homeController!
                                                //     .setSelected(newVal);
                                                if (newVal == 111111) {
                                                  //  homeController!.getPrefs();
                                                  print('CALLED1');
                                                  // homeController!
                                                  //     .setSelected(newVal);
                                                  Get.toNamed(
                                                      AppRoutes.editcategory);
                                                } else {
                                                  print('CALLED2');
                                                  homeController!
                                                      .setSelected(newVal);
                                                }
                                              },
                                              isExpanded: true,
                                              icon: const Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.red),
                                              items: homeController!
                                                  .selectedCourseList
                                                  .map((item) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                    item.categoryName!,
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: kTextColor),
                                                  ),
                                                  value: item.categoryId,
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    tranparentBorder(),
                                                border: tranparentBorder(),
                                                focusedBorder:
                                                    tranparentBorder(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Obx(
                                      () {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                listingController!
                                                    .selectedTypeId.value = '1';
                                                dashboardController!
                                                    .changeTabIndex(4);
                                              },
                                              child: Container(
                                                height: 50.h,
                                                width: 50.w,
                                                decoration: boxDecorationRect(
                                                    Colors.white, Colors.white),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: SvgPicture.asset(
                                                        'assets/images/practice.svg',
                                                        width: 25.w,
                                                        height: 25.w,
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              left: 5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Text(
                                                              'Practice',
                                                              style: TextStyle(
                                                                color:
                                                                    kTextColor,
                                                                fontSize: 10.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Text(
                                                              homeController!
                                                                  .totalPractice!
                                                                  .value
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color:
                                                                    kDarkBlueColor,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                listingController!
                                                    .selectedTypeId.value = '2';
                                                dashboardController!
                                                    .changeTabIndex(4);
                                              },
                                              child: Container(
                                                height: 50.h,
                                                width: 50.w,
                                                decoration: boxDecorationRect(
                                                    Colors.white, Colors.white),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: SvgPicture.asset(
                                                        'assets/images/test.svg',
                                                        width: 25.w,
                                                        height: 25.w,
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              left: 5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Text(
                                                              'Tests',
                                                              style: TextStyle(
                                                                color:
                                                                    kTextColor,
                                                                fontSize: 10.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Text(
                                                              homeController!
                                                                  .totalTest!
                                                                  .value
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color:
                                                                    kDarkBlueColor,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                listingController!
                                                    .selectedTypeId.value = '3';
                                                dashboardController!
                                                    .changeTabIndex(
                                                  4,
                                                );
                                              },
                                              child: Container(
                                                height: 50.h,
                                                width: 50.w,
                                                decoration: boxDecorationRect(
                                                    Colors.white, Colors.white),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: SvgPicture.asset(
                                                        'assets/images/pyq.svg',
                                                        width: 25,
                                                        height: 25,
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              left: 5),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Text(
                                                              'PYQs',
                                                              style: TextStyle(
                                                                color:
                                                                    kTextColor,
                                                                fontSize: 10.sp,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            child: Text(
                                                              homeController!
                                                                  .totalPyq!
                                                                  .value
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color:
                                                                    kDarkBlueColor,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        color: kBackgroundColor,
                        child: Column(
                          children: [
                            Obx(
                              () => Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: PageView.builder(
                                  controller:
                                      homeController!.sliderController.value,
                                  // itemCount:homeController!.sliderData.isNotEmpty ? 5 : 0,
                                  itemCount: homeController!.sliderData.length,
                                  onPageChanged: (dynamic index) {
                                    if (kDebugMode) {
                                      print(index);
                                    }
                                    // homeController!.ChangeColor();
                                  },
                                  itemBuilder: (_, index) {
                                    return sliderView(
                                        homeController!.sliderData[index]);
                                  },
                                ),
                              ),
                            ),
                            Obx(
                              () => SmoothPageIndicator(
                                controller:
                                    homeController!.sliderController.value,
                                count: homeController!.sliderData.length,
                                effect: CustomizableEffect(
                                  activeDotDecoration: DotDecoration(
                                    width: 35,
                                    height: 8,
                                    color: kDarkBlueColor,
                                    rotationAngle: 0,
                                    verticalOffset: 0,
                                    borderRadius: BorderRadius.circular(24),
                                    // dotBorder: DotBorder(
                                    //   padding: 2,
                                    //   width: 2,
                                    //   color: Colors.indigo,
                                    // ),
                                  ),
                                  dotDecoration: DotDecoration(
                                    width: 8,
                                    height: 8,
                                    color: kSecondaryColor,
                                    borderRadius: BorderRadius.circular(16),
                                    verticalOffset: 0,
                                  ),
                                  spacing: 6.0,
                                  // activeColorOverride: (i) => colors[i],
                                  // inActiveColorOverride: (i) => colors[i],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              'We Offer',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      homeController!.changeType('1'.obs);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(5),
                                      decoration: homeController!
                                                  .selectedTypeId.value ==
                                              '1'
                                          ? boxDecorationRectBorder(
                                              kLightPurpleColor,
                                              kLightPurpleColor,
                                              kLightPurpleColor)
                                          : boxDecorationRectBorder(
                                              Colors.white,
                                              Colors.white,
                                              kSecondaryColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            alignment: Alignment.bottomRight,
                                            child: SvgPicture.asset(
                                              'assets/images/practice1.svg',
                                              width: 25.w,
                                            ),
                                          ),
                                          Text(
                                            'Practice',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: homeController!
                                                            .selectedTypeId
                                                            .value ==
                                                        '1'
                                                    ? kPurpleColor
                                                    : kTextColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      homeController!.changeType('2'.obs);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(5),
                                      decoration: homeController!
                                                  .selectedTypeId.value ==
                                              '2'
                                          ? boxDecorationRectBorder(
                                              kLightBlueColor,
                                              kLightBlueColor,
                                              kLightBlueColor)
                                          : boxDecorationRectBorder(
                                              Colors.white,
                                              Colors.white,
                                              kSecondaryColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            alignment: Alignment.bottomRight,
                                            child: SvgPicture.asset(
                                              'assets/images/test1.svg',
                                              width: 25.w,
                                            ),
                                          ),
                                          Text(
                                            'Test Series',
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: homeController!
                                                            .selectedTypeId
                                                            .value ==
                                                        '2'
                                                    ? kBlueColor
                                                    : kTextColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Obx(
                                  () => GestureDetector(
                                    onTap: () {
                                      homeController!.changeType('3'.obs);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(5),
                                      decoration: homeController!
                                                  .selectedTypeId.value ==
                                              '3'
                                          ? boxDecorationRectBorder(
                                              kLightYellowColor,
                                              kLightYellowColor,
                                              kLightYellowColor,
                                            )
                                          : boxDecorationRectBorder(
                                              Colors.white,
                                              Colors.white,
                                              kSecondaryColor),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            alignment: Alignment.bottomRight,
                                            child: SvgPicture.asset(
                                              'assets/images/pyq1.svg',
                                              width: 25.w,
                                            ),
                                          ),
                                          Text(
                                            'PYQs',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: homeController!
                                                          .selectedTypeId
                                                          .value ==
                                                      '3'
                                                  ? kYellowColor
                                                  : kTextColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        color: kBackgroundColor,
                        child: Column(
                          children: [
                            Container(
                              height: 3,
                              color: kSecondaryColor,
                            ),
                            Container(
                              height: 35,
                              margin: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // List<PendingNotificationRequest>
                                      //     pendingNotificationRequest =
                                      //     await NotifyHelper.instance
                                      //         .flutterLocalNotificationsPlugin
                                      //         .pendingNotificationRequests();
                                    },
                                    child: Text(
                                      'Your Exams',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              // flex: 1,
                              child: Obx(
                                () {
                                  return GridView.builder(
                                    padding: const EdgeInsets.all(10),
                                    // separatorBuilder: (context, index) => const Divider(),
                                    itemCount:
                                        homeController!.subCategoryList.length,
                                    // controller: homeController!.controller,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return itemWidgetSelectedGoals(
                                          homeController!
                                              .subCategoryList[index]);
                                    },
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 3,
                                      crossAxisSpacing: 3,
                                      childAspectRatio: 1.39,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.bloglist);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          color: kBackgroundColor,
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: boxDecorationRect(
                                kPrimaryColorDark, kPrimaryColorDark),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: SvgPicture.asset(
                                        'assets/images/daily.svg',
                                        width: 30,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Daily New Updates',
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  'assets/images/whitearrow.svg',
                                  width: 20.w,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemWidgetSelectedGoals(Subcategory model) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
          onTap: () {
            getItRegister<Map<String, dynamic>>({
              'examId': model.subCategoryId.toString(),
              'examName': model.subCategoryName.toString().toUpperCase(),
              'screen': 'Home',
            }, name: "selected_exam");
            Get.toNamed(AppRoutes.subjectlist);
          },
          child: Container(
            // height: 40,
            // decoration: boxDecorationRect(Colors.white, Colors.white),
            padding: const EdgeInsets.all(5),
            // margin: EdgeInsets.all(5),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: FadeInImage.assetNetwork(
                          height: 35.h,
                          width: 35.w,
                          placeholder: "assets/images/placeholder.png",
                          fit: BoxFit.contain,
                          image: RemoteServices.imageMainLink +
                              model.subCategoryImage!,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                        model.subCategoryName.toString().toUpperCase(),
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.black, fontSize: 10.sp),
                      )),
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        alignment: Alignment.bottomRight,
                        child: SvgPicture.asset(
                          'assets/images/orangearrow.svg',
                          width: 15.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget sliderView(GetSlider slider) {
    return InkWell(
      onTap: () {
        // getItRegister<Map<String, String>>(
        //     {'name': slider.title.s, 'id': slider.categoryId.s},
        //     name: AppStrings.selectedCategory);
        // Navigator.of(context).pushNamed(CategoryDetailsPage.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.35,
            // height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage.assetNetwork(
                placeholder: "assets/images/placeholder.png",
                imageErrorBuilder: (context, url, error) => const Image(
                  alignment: Alignment.center,
                  image: AssetImage('assets/images/placeholder.png'),
                ),
                fit: BoxFit.fill,
                image: RemoteServices.imageMainLink + slider.image!,
                // image:'https://www.pixinvent.com/materialize-material-design-admin-template/laravel/demo-4/images/avatar/avatar-7.png'
              ),
            )),
      ),
    );
  }
}
