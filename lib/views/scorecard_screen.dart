import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';

import 'package:flutter_practicekiya/controllers/listing_controller.dart';
import 'package:flutter_practicekiya/controllers/testmcq_controller.dart';
import 'package:flutter_practicekiya/models/subject_model.dart';
import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../utils/theme.dart';

class ScoreCardScreen extends StatefulWidget {
  const ScoreCardScreen({Key? key}) : super(key: key);

  @override
  State<ScoreCardScreen> createState() => _ScoreCardScreenState();
}

class _ScoreCardScreenState extends State<ScoreCardScreen> {
  ListingController? listingController;
  PaymentController? paymentController;
  TestMCQController? testMCQController;

  String? examId,
      examName,
      screen,
      comboId,
      comboName,
      testId,
      testFrom,
      testName,
      scoreFrom;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListingController>();
    paymentController = Get.find<PaymentController>();
    testMCQController = Get.find<TestMCQController>();

    examId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
    examName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_exam")['examName'];
    // screen =
    //     GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['screen'];

    testId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_test")['testId'];

    testName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_test")['testName'];

    testFrom = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_test")['testFrom'];

    scoreFrom = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_score")['scoreFrom'];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      testMCQController!.getScoreCard(testId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (scoreFrom == 'TEST') {
          Get.back(result: 'success');
          Get.back(result: 'success');
        } else {
          Get.back(result: 'success');
        }

        return false;
      },
      child: Scaffold(
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
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/appbar_back.png'),
                            fit: BoxFit.fill,
                          ),
                          // border: Border.all(color: kPrimaryColorDark),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(children: [
                          paymentController!.appBar(false, 'Score Card',
                              Colors.transparent, context, scaffoldKey),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Obx(
                                () {
                                  return Container(
                                    height: 120,
                                    width: 120,
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 0.0,
                                            color: Colors.black26,
                                            offset: Offset(1.0, 10.0),
                                            blurRadius: 20.0),
                                      ],
                                      color: Color.fromARGB(255, 184, 205, 242),
                                      shape: BoxShape.circle,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        // SelectedPopUp(from);
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(75.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          color: Colors.white,
                                          child: Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        // '',
                                                        testMCQController!
                                                            .scoreCardModel
                                                            .value
                                                            .data!
                                                            .rankNo
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColorDark,
                                                            fontSize: 26.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        'Your Rank',
                                                        style: TextStyle(
                                                          color:
                                                              kPrimaryColorDark,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 50.h,
                                                  width: 50.w,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: const Image(
                                                    image: AssetImage(
                                                      'assets/images/cup1.png',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  testMCQController!.getScoreCard(testId!);
                                },
                                child: Container(
                                  height: 25.h,
                                  width: 25.w,
                                  margin: EdgeInsets.only(left: 50),
                                  child: const Image(
                                    image: AssetImage(
                                      'assets/images/reload.png',
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ]),
                      ),
                    ],
                  ),
                  Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
                      padding: EdgeInsets.all(10),
                      child: Obx(
                        () {
                          return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Test Score Card',
                                        style: TextStyle(
                                            fontSize: 16.sp, color: kTextColor),
                                      ),
                                      Container(
                                        height: 15.h,
                                        width: 100.w,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        margin: const EdgeInsets.only(
                                            right: 5, top: 5),
                                        decoration: boxDecorationValidTill(
                                            kSecondaryColor,
                                            kSecondaryColor,
                                            10),
                                        child: Center(
                                          child: Text(
                                            testMCQController!
                                                        .scoreCardModel
                                                        .value
                                                        .data!
                                                        .completiondate
                                                        .toString() !=
                                                    ''
                                                ? Jiffy(
                                                        testMCQController!
                                                            .scoreCardModel
                                                            .value
                                                            .data!
                                                            .completiondate,
                                                        "yyyy-MM-dd HH:mm:ss")
                                                    .format("dd-MM-yyyy")
                                                : 'NA',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5, top: 25, bottom: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Total Marks',
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      testMCQController!
                                                          .scoreCardModel
                                                          .value
                                                          .data!
                                                          .totalMarks
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      height: 15.h,
                                                      width: 15.w,
                                                      child: SvgPicture.asset(
                                                        'assets/images/topics.svg',
                                                        width: 30.w,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Total Questions',
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      testMCQController!
                                                          .scoreCardModel
                                                          .value
                                                          .data!
                                                          .totalQuestion
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      height: 15.h,
                                                      width: 15.w,
                                                      child: SvgPicture.asset(
                                                        'assets/images/topics.svg',
                                                        width: 30.w,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Duration in Min',
                                                  style: TextStyle(
                                                      color: kTextColor,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      double.parse(
                                                              testMCQController!
                                                                  .scoreCardModel
                                                                  .value
                                                                  .data!
                                                                  .totalTime
                                                                  .toString())
                                                          .toStringAsFixed(2),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      height: 15.h,
                                                      width: 15.w,
                                                      child: SvgPicture.asset(
                                                        'assets/images/topics.svg',
                                                        width: 30.w,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          testMCQController!
                                                                  .scoreCardModel
                                                                  .value
                                                                  .data!
                                                                  .totalStudentAttempted
                                                                  .toString() +
                                                              ' Students',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        const SizedBox(
                                                          height: 40,
                                                        ),
                                                        Text(
                                                          ' Attempted the Test',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 10.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      'PracticeKiya makes perfect',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontSize: 10.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  height: 65.h,
                                                  width: 65.w,
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: const Image(
                                                    image: AssetImage(
                                                      'assets/images/cup2.png',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ));
                        },
                      )),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.testanalysis);
                            },
                            child: Container(
                              height: 30.h,
                              width: 100.w,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              margin: const EdgeInsets.only(right: 5, top: 5),
                              decoration: boxDecorationValidTill(
                                  kPurpleColor, kPurpleColor, 20),
                              child: Center(
                                child: Text(
                                  "Analysis",
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
                              getItRegister<Map<String, dynamic>>({
                                'testId': testId!,
                                'testName': testName!.toUpperCase(),
                                'testFrom': 'Solution',
                                'testIntro': '',
                              }, name: "selected_test");
                              Get.toNamed(AppRoutes.testmcq);
                            },
                            child: Container(
                              height: 30.h,
                              width: 100.w,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              margin: const EdgeInsets.only(right: 5, top: 5),
                              decoration: boxDecorationValidTill(
                                  kPrimaryColor, kPrimaryColor, 20),
                              child: Center(
                                child: Text(
                                  "Solution",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
