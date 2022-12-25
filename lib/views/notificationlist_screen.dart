import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';

import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/notificationlist_model.dart';
import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  HomeController? homeController;
  PaymentController? paymentController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController notificationScrollController = ScrollController();
  int notificationPage = 1;

  @override
  void initState() {
    super.initState();

    homeController = Get.find<HomeController>();
    paymentController = Get.find<PaymentController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeController!.getNotificationList(true, 1);
      addNotificationItems();
      paymentController!.getHomeData();
    });
  }

  addNotificationItems() async {
    notificationScrollController.addListener(() {
      if (notificationScrollController.position.maxScrollExtent ==
          notificationScrollController.position.pixels) {
        notificationPage++;
        homeController!.getNotificationList(false, notificationPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                          paymentController!.appBar(false, 'Notifications',
                              kPrimaryColorDark, context, scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Obx(() {
                          return homeController!.notificationList.isNotEmpty
                              ? Column(
                                  children: [
                                    Expanded(
                                        child: ListView.builder(
                                      padding: const EdgeInsets.all(5),
                                      itemCount: homeController!
                                          .notificationList.length,
                                      controller: notificationScrollController,
                                      itemBuilder: (context, index) {
                                        return itemWidget(
                                            homeController!
                                                .notificationList[index],
                                            index);
                                      },
                                    )),
                                    (homeController!.isLoading.value &&
                                            notificationPage != 1)
                                        ? Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/bottomloader.svg',
                                                  width: 100,
                                                  height: 40,
                                                  color: kPrimaryColor,
                                                ),
                                                Text(
                                                  'Loading...',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container()
                                  ],
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

  Widget itemWidget(NotificationData model, int index) {
    return Card(
      elevation: 3,
      color: model.isRead! == 0 ? kLightBlueColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
          onTap: () {
            if (model.isRead == 0) {
              setState(() {
                if (paymentController!.unreadCount.value >= 1) {
                  paymentController!.unreadCount.value =
                      paymentController!.unreadCount.value - 1;
                }
                print(paymentController!.unreadCount.value);
                model.isRead = 1;
                homeController!.getNotificationRead(model.id.toString());
              });
            }

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
                      model.title.toString(),
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
                          width: 150.0,
                          height: 150.0,
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
                              width: 150.0,
                              height: 150.0,
                              image: RemoteServices.imageMainLink +
                                  model.image.toString(),
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
                              child: Text(model.message.toString(),
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
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              model.title!,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              model.message!,
                              style: TextStyle(color: kTextColor, fontSize: 12),
                            ),
                          )
                        ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 40.0,
                  height: 40.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/placeholder.png",
                      imageErrorBuilder: (context, url, error) => const Image(
                        alignment: Alignment.center,
                        image: AssetImage('assets/images/placeholder.png'),
                      ),
                      fit: BoxFit.cover,
                      width: 40.0,
                      height: 40.0,
                      image: RemoteServices.imageMainLink + model.image!,

                      //
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
