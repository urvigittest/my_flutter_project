import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/dashboard_controller.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';
import 'package:flutter_practicekiya/views/editprofile_screen.dart';
import 'package:flutter_practicekiya/views/letsgetstarted_screen.dart';
import 'package:flutter_practicekiya/views/planlist_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../controllers/listing_controller.dart';
import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/functions.dart';
import '../utils/preferences.dart';
import '../utils/theme.dart';
import 'home_screen.dart';
import 'offerslist_screen.dart';

PaymentController? paymentController;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardController? dashboardController;
  PaymentController? paymentController;
  HomeController? homeController;
  Prefs prefs = Prefs.prefs;

  @override
  void initState() {
    super.initState();
    getItRegister<Map<String, dynamic>>({
      'examId': '',
      'examName': '',
      'screen': 'Home',
    }, name: "selected_exam");
    dashboardController = Get.find<DashboardController>();
    paymentController = Get.find<PaymentController>();
    homeController = Get.find<HomeController>();
    dashboardController!.tabIndex.value = 0;
    firebaseFunctions();

    paymentController!.backController.stream.listen((list) {
      if (mounted) {
        hideLoader();

        dashboardController!.tabIndex.value = 0;
        dashboardController!.changeTabIndex(0);
      }
    });
  }

  void firebaseFunctions() async {
    String first = await prefs.getFirebaseCalled();
    print('getFirstFirebase->' + first);

    if (first == '') {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // print("message recieved onMessage");
        // print(message.notification!.body);
        // print(message.data.values);
        // print(message.data);
        // print(message);
        print("onMessage->" + message.data.toString());

        if (message.data['type'].toString() == 'rating') {
          showDialog(
            context: context,
            barrierDismissible:
                true, // set to false if you want to force a rating
            builder: (context) => RatingDialog(
              initialRating: 1.0,
              // your app's name?
              title: Text(
                'Rating',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // encourage your user to leave a high rating?
              message: Text(
                'Tap a star to set your rating for ' +
                    message.data['subscription_name'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp),
              ),
              // your app's logo?
              image: Container(
                margin: const EdgeInsets.only(top: 0, left: 0),
                width: 100.0,
                height: 100.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/placeholder.png",
                    imageErrorBuilder: (context, url, error) => const Image(
                      alignment: Alignment.center,
                      image: AssetImage('assets/images/placeholder.png'),
                    ),
                    fit: BoxFit.contain,
                    image: RemoteServices.imageMainLink +
                        message.data['subscription_image'].toString(),
//
                  ),
                ),
              ),
              submitButtonText: 'Submit',
              submitButtonTextStyle: const TextStyle(color: kPrimaryColorDark),
              enableComment: false,
              showCloseButton: true,

              starSize: 25,
              onSubmitted: (response) {
                print(
                    'rating: ${response.rating}, comment: ${response.comment}');

                dashboardController!.addSubscriptionRating(
                  message.data['subscription_id'].toString(),
                  response.rating.toString(),
                );
                // // TODO: add your own logic
                // if (response.rating < 3.0) {
                //   // send their comments to your email or anywhere you wish
                //   // ask the user to contact you instead of leaving a bad review
                // } else {
                //   // _rateAndReviewApp();
                // }
              },
            ),
          );
        } else if (message.data['type'].toString() == 'subscription_reminder') {
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
                  title: Text(
                    message.data['title'].toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor),
                    textAlign: TextAlign.left,
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                              message.data['subscription_name'].toString(),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColorDark))),
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 0),
                        width: 100.0,
                        height: 100.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/placeholder.png",
                            imageErrorBuilder: (context, url, error) =>
                                const Image(
                              alignment: Alignment.center,
                              image:
                                  AssetImage('assets/images/placeholder.png'),
                            ),
                            fit: BoxFit.contain,
                            image: RemoteServices.imageMainLink +
                                message.data['subscription_image'].toString(),
//
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                        child: Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Text(message.data['body'].toString(),
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
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 35,
                        //     width: 100,
                        //     padding:
                        //         const EdgeInsets
                        //                 .only(
                        //             left: 15,
                        //             right: 15),
                        //     decoration:
                        //         boxDecorationValidTill(
                        //             kPrimaryColorDark,
                        //             kPrimaryColorDarkLight,
                        //             10),
                        //     child: const Center(
                        //       child: Text(
                        //         "Exit",
                        //         textAlign: TextAlign
                        //             .center,
                        //         style: TextStyle(
                        //           fontSize: 12.0,
                        //           color:
                        //               Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                                "Dismiss",
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
        } else if (message.data['type'].toString() == 'admin_notification') {
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
                  title: Text(
                    message.data['title'].toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor),
                    textAlign: TextAlign.left,
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 0),
                        width: 100.0,
                        height: 100.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/placeholder.png",
                            imageErrorBuilder: (context, url, error) =>
                                const Image(
                              alignment: Alignment.center,
                              image:
                                  AssetImage('assets/images/placeholder.png'),
                            ),
                            fit: BoxFit.contain,
                            image: RemoteServices.imageMainLink +
                                message.data['image'].toString(),
//
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                        child: Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Text(message.data['body'].toString(),
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
                                "Dismiss",
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
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // print('A new onMessageOpenedApp event was published!');
        print('onMessageOpenedApp->' + message.toString());

        if (message.data['type'].toString() == 'rating') {
          showDialog(
            context: context,
            barrierDismissible:
                true, // set to false if you want to force a rating
            builder: (context) => RatingDialog(
              initialRating: 1.0,
              // your app's name?
              title: Text(
                'Rating',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // encourage your user to leave a high rating?
              message: Text(
                'Tap a star to set your rating for ' +
                    message.data['subscription_name'].toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.sp),
              ),
              // your app's logo?
              image: Container(
                margin: const EdgeInsets.only(top: 0, left: 0),
                width: 100.0,
                height: 100.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: FadeInImage.assetNetwork(
                    placeholder: "assets/images/placeholder.png",
                    imageErrorBuilder: (context, url, error) => const Image(
                      alignment: Alignment.center,
                      image: AssetImage('assets/images/placeholder.png'),
                    ),
                    fit: BoxFit.contain,
                    image: RemoteServices.imageMainLink +
                        message.data['subscription_image'].toString(),
//
                  ),
                ),
              ),
              submitButtonText: 'Submit',
              submitButtonTextStyle: const TextStyle(color: kPrimaryColorDark),
              enableComment: false,
              showCloseButton: true,

              starSize: 25,
              onSubmitted: (response) {
                print(
                    'rating: ${response.rating}, comment: ${response.comment}');

                dashboardController!.addSubscriptionRating(
                  message.data['subscription_id'].toString(),
                  response.rating.toString(),
                );
                // // TODO: add your own logic
                // if (response.rating < 3.0) {
                //   // send their comments to your email or anywhere you wish
                //   // ask the user to contact you instead of leaving a bad review
                // } else {
                //   // _rateAndReviewApp();
                // }
              },
            ),
          );
        } else if (message.data['type'].toString() == 'subscription_reminder') {
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
                  title: Text(
                    message.data['title'].toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor),
                    textAlign: TextAlign.left,
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                              message.data['subscription_name'].toString(),
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColorDark))),
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 0),
                        width: 100.0,
                        height: 100.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/placeholder.png",
                            imageErrorBuilder: (context, url, error) =>
                                const Image(
                              alignment: Alignment.center,
                              image:
                                  AssetImage('assets/images/placeholder.png'),
                            ),
                            fit: BoxFit.contain,
                            image: RemoteServices.imageMainLink +
                                message.data['subscription_image'].toString(),
//
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                        child: Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Text(message.data['body'].toString(),
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
                        // GestureDetector(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 35,
                        //     width: 100,
                        //     padding:
                        //         const EdgeInsets
                        //                 .only(
                        //             left: 15,
                        //             right: 15),
                        //     decoration:
                        //         boxDecorationValidTill(
                        //             kPrimaryColorDark,
                        //             kPrimaryColorDarkLight,
                        //             10),
                        //     child: const Center(
                        //       child: Text(
                        //         "Exit",
                        //         textAlign: TextAlign
                        //             .center,
                        //         style: TextStyle(
                        //           fontSize: 12.0,
                        //           color:
                        //               Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
                                "Dismiss",
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
        } else if (message.data['type'].toString() == 'admin_notification') {
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
                  title: Text(
                    message.data['title'].toString(),
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor),
                    textAlign: TextAlign.left,
                  ),
                  content: SingleChildScrollView(
                      child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 0, left: 0),
                        width: 100.0,
                        height: 100.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/placeholder.png",
                            imageErrorBuilder: (context, url, error) =>
                                const Image(
                              alignment: Alignment.center,
                              image:
                                  AssetImage('assets/images/placeholder.png'),
                            ),
                            fit: BoxFit.contain,
                            image: RemoteServices.imageMainLink +
                                message.data['image'].toString(),
//
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                        child: Container(
                            height: 30,
                            alignment: Alignment.centerLeft,
                            child: Text(message.data['body'].toString(),
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
                                "Dismiss",
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
      });

      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        print('getInitialMessage->' + message.toString());

        if (message != null) {
          if (message.data['type'].toString() == 'rating') {
            showDialog(
              context: context,
              barrierDismissible:
                  true, // set to false if you want to force a rating
              builder: (context) => RatingDialog(
                initialRating: 1.0,
                // your app's name?
                title: Text(
                  'Rating',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // encourage your user to leave a high rating?
                message: Text(
                  'Tap a star to set your rating for ' +
                      message.data['subscription_name'].toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp),
                ),
                // your app's logo?
                image: Container(
                  margin: const EdgeInsets.only(top: 0, left: 0),
                  width: 100.0,
                  height: 100.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/placeholder.png",
                      imageErrorBuilder: (context, url, error) => const Image(
                        alignment: Alignment.center,
                        image: AssetImage('assets/images/placeholder.png'),
                      ),
                      fit: BoxFit.contain,
                      image: RemoteServices.imageMainLink +
                          message.data['subscription_image'].toString(),
//
                    ),
                  ),
                ),
                submitButtonText: 'Submit',
                submitButtonTextStyle:
                    const TextStyle(color: kPrimaryColorDark),
                enableComment: false,
                showCloseButton: true,

                starSize: 25,
                onSubmitted: (response) {
                  print(
                      'rating: ${response.rating}, comment: ${response.comment}');

                  dashboardController!.addSubscriptionRating(
                    message.data['subscription_id'].toString(),
                    response.rating.toString(),
                  );
                  // // TODO: add your own logic
                  // if (response.rating < 3.0) {
                  //   // send their comments to your email or anywhere you wish
                  //   // ask the user to contact you instead of leaving a bad review
                  // } else {
                  //   // _rateAndReviewApp();
                  // }
                },
              ),
            );
          } else if (message.data['type'].toString() ==
              'subscription_reminder') {
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
                    title: Text(
                      message.data['title'].toString(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor),
                      textAlign: TextAlign.left,
                    ),
                    content: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: Text(
                                message.data['subscription_name'].toString(),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColorDark))),
                        Container(
                          margin: const EdgeInsets.only(top: 0, left: 0),
                          width: 100.0,
                          height: 100.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/placeholder.png",
                              imageErrorBuilder: (context, url, error) =>
                                  const Image(
                                alignment: Alignment.center,
                                image:
                                    AssetImage('assets/images/placeholder.png'),
                              ),
                              fit: BoxFit.contain,
                              image: RemoteServices.imageMainLink +
                                  message.data['subscription_image'].toString(),
//
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20),
                          child: Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Text(message.data['body'].toString(),
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
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: Container(
                          //     height: 35,
                          //     width: 100,
                          //     padding:
                          //         const EdgeInsets
                          //                 .only(
                          //             left: 15,
                          //             right: 15),
                          //     decoration:
                          //         boxDecorationValidTill(
                          //             kPrimaryColorDark,
                          //             kPrimaryColorDarkLight,
                          //             10),
                          //     child: const Center(
                          //       child: Text(
                          //         "Exit",
                          //         textAlign: TextAlign
                          //             .center,
                          //         style: TextStyle(
                          //           fontSize: 12.0,
                          //           color:
                          //               Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 35,
                              width: 100,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              decoration: boxDecorationRectBorder(
                                  Colors.white, Colors.white, kDarkBlueColor),
                              child: const Center(
                                child: Text(
                                  "Dismiss",
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
          } else if (message.data['type'].toString() == 'admin_notification') {
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
                    title: Text(
                      message.data['title'].toString(),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kPrimaryColor),
                      textAlign: TextAlign.left,
                    ),
                    content: SingleChildScrollView(
                        child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 0, left: 0),
                          width: 100.0,
                          height: 100.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/placeholder.png",
                              imageErrorBuilder: (context, url, error) =>
                                  const Image(
                                alignment: Alignment.center,
                                image:
                                    AssetImage('assets/images/placeholder.png'),
                              ),
                              fit: BoxFit.contain,
                              image: RemoteServices.imageMainLink +
                                  message.data['image'].toString(),
//
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20),
                          child: Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              child: Text(message.data['body'].toString(),
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
                              Get.back();
                            },
                            child: Container(
                              height: 35,
                              width: 100,
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              decoration: boxDecorationRectBorder(
                                  Colors.white, Colors.white, kDarkBlueColor),
                              child: const Center(
                                child: Text(
                                  "Dismiss",
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
      });

      prefs.setFirebaseCalled('1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          print('CALLLLEDDDDDDDDDDDD');
          if (dashboardController!.tabIndex.value == 0) {
            dashboardController!.exitDialog(context);
          } else {
            dashboardController!.tabIndex.value = 0;
            dashboardController!.changeTabIndex(0);
          }

          return false;
        },
        child: Scaffold(
          body: Obx(() => IndexedStack(
                index: dashboardController!.tabIndex.value,
                children: const [
                  HomeScreen(),
                  OffersListScreen(),
                  PlanListScreen(),
                  EditProfileScreen(),
                ],
              )),
          bottomNavigationBar:
              buildBottomNavigationMenu(context, dashboardController),
        ));
  }

  buildBottomNavigationMenu(context, dashboardController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          height: 60.h,
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            showSelectedLabels: false,
            type: BottomNavigationBarType.fixed,
            onTap: dashboardController.changeTabIndex,
            currentIndex: dashboardController.tabIndex.value,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.all(0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/home.png',
                      height: 20.h,
                      // color: Colors.white,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    )
                  ]),
                ),
                label: 'Home',
                activeIcon: Container(
                  decoration: boxDecorationTab(
                      kPrimaryColorDarkLight, kPrimaryColorDark),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.all(0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/home.png',
                      height: 20,
                      color: Colors.white,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    )
                  ]),
                ),
                backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/offers.png',
                      height: 20.h,
                      // color: Colors.white,
                    ),
                    Text(
                      'Offers',
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    )
                  ]),
                ),
                label: 'Offers',
                activeIcon: Container(
                  decoration: boxDecorationTab(
                      kPrimaryColorDarkLight, kPrimaryColorDark),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/offers.png',
                      height: 20.h,
                      color: Colors.white,
                    ),
                    Text(
                      'Offers',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    )
                  ]),
                ),
                backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/plans.png',
                      height: 20.h,
                      // color: Colors.white,
                    ),
                    Text(
                      'Plans',
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    )
                  ]),
                ),
                label: 'Plans',
                activeIcon: Container(
                  decoration: boxDecorationTab(
                      kPrimaryColorDarkLight, kPrimaryColorDark),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/plans.png',
                      height: 20.h,
                      color: Colors.white,
                    ),
                    Text(
                      'Plans',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    )
                  ]),
                ),
                backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              ),

              // BottomNavigationBarItem(
              //   icon: Container(
              //     padding: const EdgeInsets.only(
              //         left: 5, right: 5, top: 3, bottom: 3),
              //     margin: const EdgeInsets.only(bottom: 0),
              //     child: Column(children: [
              //       Image.asset(
              //         'assets/images/settings.png',
              //         height: 20.h,
              //         // color: Colors.white,
              //       ),
              //       Text(
              //         'Settings',
              //         style: TextStyle(
              //           fontSize: 12.sp,
              //         ),
              //       )
              //     ]),
              //   ),
              //   label: 'Settings',
              //   activeIcon: Container(
              //     decoration: boxDecorationTab(
              //         kPrimaryColorDarkLight, kPrimaryColorDark),
              //     padding: const EdgeInsets.only(
              //         left: 5, right: 5, top: 3, bottom: 3),
              //     margin: const EdgeInsets.only(bottom: 0),
              //     child: Column(children: [
              //       Image.asset(
              //         'assets/images/settings.png',
              //         height: 20.h,
              //         color: Colors.white,
              //       ),
              //       Text(
              //         'Settings',
              //         style: TextStyle(fontSize: 12.sp, color: Colors.white),
              //       )
              //     ]),
              //   ),
              //   backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              // ),

              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/profile.png',
                      height: 20.h,
                      // color: Colors.white,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    )
                  ]),
                ),
                label: 'Profile',
                activeIcon: Container(
                  decoration: boxDecorationTab(
                      kPrimaryColorDarkLight, kPrimaryColorDark),
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 3, bottom: 3),
                  margin: const EdgeInsets.only(bottom: 0),
                  child: Column(children: [
                    Image.asset(
                      'assets/images/profile.png',
                      height: 20.h,
                      color: Colors.white,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(fontSize: 12.sp, color: Colors.white),
                    )
                  ]),
                ),
                backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
              ),
            ],
          ),
        )));
  }
}
