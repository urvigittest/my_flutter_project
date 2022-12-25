// ignore_for_file: unnecessary_string_escapes

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practicekiya/controllers/testmcq_controller.dart';
import 'package:flutter_practicekiya/models/practicemcq_model.dart';
import 'package:flutter_practicekiya/services/remote_services.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:gif_view/gif_view.dart';

import '../calculator/scientificCalculator.dart';
import '../controllers/listing_controller.dart';
import '../controllers/payment_controller.dart';

import '../models/idstringname_model.dart';
import '../models/testmcq_model.dart';
import '../routes/app_routes.dart';
import '../utils/staticarrays.dart';
import '../utils/theme.dart';

class TestMCQScreen extends StatefulWidget {
  const TestMCQScreen({Key? key}) : super(key: key);

  @override
  State<TestMCQScreen> createState() => _TestMCQScreenState();
}

class _TestMCQScreenState extends State<TestMCQScreen> {
  TestMCQController? testMCQController;
  PaymentController? paymentController;
  ListingController? listingController;
  String? examId = '',
      examName = '',
      // subjectId,
      subjectName = '',
      // chapterId,
      // chapterName,
      // chapterLabel,
      // topicId,
      // topicName,
      testId = '',
      testFrom = '',
      testName = '',
      testIntro = '';

  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.mathjax();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String? from = '';

  @override
  void initState() {
    super.initState();

    testMCQController = Get.find<TestMCQController>();
    paymentController = Get.find<PaymentController>();
    listingController = Get.find<ListingController>();

    examId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
    examName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_exam")['examName'];

    subjectName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectName'];

    testId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_test")['testId'];

    testName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_test")['testName'];

    testFrom = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_test")['testFrom'];

    testIntro = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_test")['testIntro'];

    testMCQController!.resetStopWatch();
    testMCQController!.stopWatchStream();

    testMCQController!.selectedIndex.value = 0;

    testMCQController!.clearFilter();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      testMCQController!.refreshStreamController.stream.listen((list) {
        from = list;
        if (mounted) {
//////
          hideLoader();
          beforeDialog();

/////

        }
      });

      testMCQController!.startStopWatch();

      if (testFrom == 'Test') {
        testMCQController!.getTestMCQList(true, testId!);
      } else {
        testMCQController!.getTestMCQSolutionList(true, testId!);
      }

      if (testIntro != '') {
        instructionsDialog();
      } else {
        testMCQController!.startTimer();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    testMCQController!.resetStopWatch();
    testMCQController!.timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'success');
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        onEndDrawerChanged: (isDrawerOpen) {
          if (isDrawerOpen) {
            testMCQController!.openDrawer();
          } else {
            //drawer is close
          }
        },
        endDrawer: Drawer(child: Obx(
          () {
            return Container(
                padding: const EdgeInsets.all(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: const EdgeInsets.all(5),
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (testMCQController!
                                            .testTypeSelected.value ==
                                        1) {
                                      testMCQController!
                                          .changeTestTypeFilter(2);
                                      testMCQController!.clearFilter();
                                      testMCQController!.drawerController.sink
                                          .add('N/A');
                                    }
                                  },
                                  child: Container(
                                    height: 25.h,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: testMCQController!
                                                .testTypeSelected.value ==
                                            2
                                        ? boxDecorationValidTill(
                                            kBlueColor, kBlueColor, 10)
                                        : boxDecorationValidTill(
                                            Colors.white, Colors.white, 10),
                                    child: Center(
                                      child: Text(
                                        "General Aptitude",
                                        textAlign: TextAlign.center,
                                        style: testMCQController!
                                                    .testTypeSelected.value ==
                                                2
                                            ? TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                              )
                                            : TextStyle(
                                                fontSize: 10.sp,
                                                color: kTextColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (testMCQController!
                                            .testTypeSelected.value ==
                                        2) {
                                      testMCQController!
                                          .changeTestTypeFilter(1);

                                      testMCQController!.clearFilter();
                                      testMCQController!.drawerController.sink
                                          .add('N/A');
                                    }
                                  },
                                  child: Container(
                                    height: 25.h,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: testMCQController!
                                                .testTypeSelected.value ==
                                            1
                                        ? boxDecorationValidTill(
                                            kBlueColor, kBlueColor, 10)
                                        : boxDecorationValidTill(
                                            Colors.white, Colors.white, 10),
                                    child: Center(
                                      child: Text(
                                        "Technical",
                                        textAlign: TextAlign.center,
                                        style: testMCQController!
                                                    .testTypeSelected.value ==
                                                1
                                            ? TextStyle(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                              )
                                            : TextStyle(
                                                fontSize: 10.sp,
                                                color: kTextColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (testMCQController!.isList.value) {
                                testMCQController!.isList.value = false;
                              } else {
                                testMCQController!.isList.value = true;
                              }
                            },
                            child: Container(
                              height: 20.h,
                              width: 20.w,
                              child: Image(
                                image: AssetImage(
                                  testMCQController!.isList.value
                                      ? 'assets/images/grid.png'
                                      : 'assets/images/list.png',
                                ),
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    StreamBuilder(
                      stream: testMCQController!.drawerController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return testMCQController!.isList.value
                              ? Expanded(
                                  child: ListView(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, top: 5),
                                      shrinkWrap: true,
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          itemCount: testMCQController!
                                              .testMCQList.length,
                                          itemBuilder: (context, index) {
                                            return itemWidgetQuestionFilter(
                                                testMCQController!
                                                    .testMCQList[index],
                                                index);
                                          },
                                        ),
                                      ]),
                                )
                              : Container();
                        } else {
                          return testMCQController!.isList.value
                              ? Expanded(
                                  child: ListView(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, top: 5),
                                      shrinkWrap: true,
                                      children: [
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          itemCount: testMCQController!
                                              .testMCQList.length,
                                          itemBuilder: (context, index) {
                                            return itemWidgetQuestionFilter(
                                                testMCQController!
                                                    .testMCQList[index],
                                                index);
                                          },
                                        ),
                                      ]),
                                )
                              : Container();
                        }
                      },
                    ),

                    !testMCQController!.isList.value
                        ? Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    testMCQController!.clearFilter();
                                    testMCQController!.drawerController.sink
                                        .add('N/A');
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    height: 30,
                                    decoration: boxDecorationRevise(
                                        kSecondaryColor, kSecondaryColor, 5),
                                    child: Row(children: [
                                      Text(
                                        'ALL',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]),
                                  ),
                                ),

                                //correct
                                testFrom == 'Solution'
                                    ? InkWell(
                                        onTap: () {
                                          testMCQController!.correct.value =
                                              true;

                                          testMCQController!.saved.value =
                                              false;
                                          testMCQController!.incorrect.value =
                                              false;
                                          testMCQController!.unattempted.value =
                                              false;

                                          testMCQController!.answered.value =
                                              false;
                                          testMCQController!
                                              .markReviewNoAnswer.value = false;
                                          testMCQController!
                                              .markReviewWithAnswer
                                              .value = false;
                                          testMCQController!.applyFilter();
                                          testMCQController!
                                              .drawerController.sink
                                              .add('N/A');
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: testMCQController!
                                                      .correct.value
                                                  ? boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.black)
                                                  : boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.white),
                                            ),
                                            Container(
                                              height: 25,
                                              alignment: Alignment.center,
                                              width: 25,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: boxDecorationStep(
                                                  Colors.lightGreen[100]!,
                                                  Colors.lightGreen[100]!,
                                                  Colors.green),
                                              child: Text(
                                                '',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                //incorrect
                                testFrom == 'Solution'
                                    ? InkWell(
                                        onTap: () {
                                          testMCQController!.correct.value =
                                              false;

                                          testMCQController!.saved.value =
                                              false;
                                          testMCQController!.incorrect.value =
                                              true;
                                          testMCQController!.unattempted.value =
                                              false;

                                          testMCQController!.answered.value =
                                              false;
                                          testMCQController!
                                              .markReviewNoAnswer.value = false;
                                          testMCQController!
                                              .markReviewWithAnswer
                                              .value = false;
                                          testMCQController!.applyFilter();
                                          testMCQController!
                                              .drawerController.sink
                                              .add('N/A');
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: testMCQController!
                                                      .incorrect.value
                                                  ? boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.black)
                                                  : boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.white),
                                            ),
                                            Container(
                                              height: 25,
                                              alignment: Alignment.center,
                                              width: 25,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: boxDecorationStep(
                                                  const Color.fromARGB(
                                                      255, 255, 181, 174),
                                                  const Color.fromARGB(
                                                      255, 255, 181, 174),
                                                  Colors.red),
                                              child: Text(
                                                '',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                //unattempted
                                InkWell(
                                  onTap: () {
                                    testMCQController!.correct.value = false;

                                    testMCQController!.saved.value = false;
                                    testMCQController!.incorrect.value = false;
                                    testMCQController!.unattempted.value = true;

                                    testMCQController!.answered.value = false;
                                    testMCQController!
                                        .markReviewNoAnswer.value = false;
                                    testMCQController!
                                        .markReviewWithAnswer.value = false;
                                    testMCQController!.applyFilter();
                                    testMCQController!.drawerController.sink
                                        .add('N/A');
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        decoration:
                                            testMCQController!.unattempted.value
                                                ? boxDecorationStep(
                                                    Colors.white,
                                                    Colors.white,
                                                    Colors.black)
                                                : boxDecorationStep(
                                                    Colors.white,
                                                    Colors.white,
                                                    Colors.white),
                                      ),
                                      Container(
                                        height: 25,
                                        alignment: Alignment.center,
                                        width: 25,
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        decoration: boxDecorationStep(
                                            Colors.white,
                                            Colors.white,
                                            kTextColor),
                                        child: Text(
                                          '',
                                          style: const TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //markreviewnoanswer
                                testFrom == 'Test'
                                    ? InkWell(
                                        onTap: () {
                                          testMCQController!.correct.value =
                                              false;

                                          testMCQController!.saved.value =
                                              false;
                                          testMCQController!.incorrect.value =
                                              false;
                                          testMCQController!.unattempted.value =
                                              false;

                                          testMCQController!.answered.value =
                                              false;
                                          testMCQController!
                                              .markReviewNoAnswer.value = true;
                                          testMCQController!
                                              .markReviewWithAnswer
                                              .value = false;
                                          testMCQController!.applyFilter();
                                          testMCQController!
                                              .drawerController.sink
                                              .add('N/A');
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: testMCQController!
                                                      .markReviewNoAnswer.value
                                                  ? boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.black)
                                                  : boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.white),
                                            ),
                                            Container(
                                              height: 25,
                                              alignment: Alignment.center,
                                              width: 25,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: boxDecorationStep(
                                                  Colors.white,
                                                  Colors.white,
                                                  kTextColor),
                                              child: Text(
                                                '',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              width: 25,
                                              height: 25,
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: SvgPicture.asset(
                                                  'assets/images/checkbox_button.svg',
                                                  width: 10,
                                                  height: 10,
                                                  color: kPurpleColor,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                //markreviewwithanswer
                                testFrom == 'Test'
                                    ? InkWell(
                                        onTap: () {
                                          testMCQController!.correct.value =
                                              false;

                                          testMCQController!.saved.value =
                                              false;
                                          testMCQController!.incorrect.value =
                                              false;
                                          testMCQController!.unattempted.value =
                                              false;

                                          testMCQController!.answered.value =
                                              false;
                                          testMCQController!
                                              .markReviewNoAnswer.value = false;
                                          testMCQController!
                                              .markReviewWithAnswer
                                              .value = true;
                                          testMCQController!.applyFilter();
                                          testMCQController!
                                              .drawerController.sink
                                              .add('N/A');
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: testMCQController!
                                                      .markReviewWithAnswer
                                                      .value
                                                  ? boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.black)
                                                  : boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.white),
                                            ),
                                            Container(
                                              height: 25,
                                              alignment: Alignment.center,
                                              width: 25,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: boxDecorationStep(
                                                  kLightBlueColor,
                                                  kLightBlueColor,
                                                  kTextColor),
                                              child: Text(
                                                '',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              width: 25,
                                              height: 25,
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: SvgPicture.asset(
                                                  'assets/images/checkbox_button.svg',
                                                  width: 10,
                                                  height: 10,
                                                  color: kPurpleColor,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                                //answered
                                testFrom == 'Test'
                                    ? InkWell(
                                        onTap: () {
                                          testMCQController!.correct.value =
                                              false;

                                          testMCQController!.saved.value =
                                              false;
                                          testMCQController!.incorrect.value =
                                              false;
                                          testMCQController!.unattempted.value =
                                              false;

                                          testMCQController!.answered.value =
                                              true;
                                          testMCQController!
                                              .markReviewNoAnswer.value = false;
                                          testMCQController!
                                              .markReviewWithAnswer
                                              .value = false;
                                          testMCQController!.applyFilter();
                                          testMCQController!
                                              .drawerController.sink
                                              .add('N/A');
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: testMCQController!
                                                      .answered.value
                                                  ? boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.black)
                                                  : boxDecorationStep(
                                                      Colors.white,
                                                      Colors.white,
                                                      Colors.white),
                                            ),
                                            Container(
                                              height: 25,
                                              alignment: Alignment.center,
                                              width: 25,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: boxDecorationStep(
                                                  kLightBlueColor,
                                                  kLightBlueColor,
                                                  kTextColor),
                                              child: Text(
                                                '',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                //bookmarked
                                testFrom == 'Test'
                                    ? InkWell(
                                        onTap: () {
                                          testMCQController!.correct.value =
                                              false;

                                          testMCQController!.saved.value = true;
                                          testMCQController!.incorrect.value =
                                              false;
                                          testMCQController!.unattempted.value =
                                              false;

                                          testMCQController!.answered.value =
                                              false;
                                          testMCQController!
                                              .markReviewNoAnswer.value = false;
                                          testMCQController!
                                              .markReviewWithAnswer
                                              .value = false;
                                          testMCQController!.applyFilter();
                                          testMCQController!
                                              .drawerController.sink
                                              .add('N/A');
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 30,
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration:
                                                  testMCQController!.saved.value
                                                      ? boxDecorationStep(
                                                          Colors.white,
                                                          Colors.white,
                                                          Colors.black)
                                                      : boxDecorationStep(
                                                          Colors.white,
                                                          Colors.white,
                                                          Colors.white),
                                            ),
                                            Container(
                                              height: 25,
                                              alignment: Alignment.center,
                                              width: 25,
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              decoration: boxDecorationStep(
                                                  Colors.white,
                                                  Colors.white,
                                                  kTextColor),
                                              child: Text(
                                                '',
                                                style: const TextStyle(
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Container(
                                              width: 25,
                                              height: 25,
                                              color: Colors.transparent,
                                              alignment: Alignment.center,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: SvgPicture.asset(
                                                  'assets/images/bookmark_solid.svg',
                                                  width: 10,
                                                  height: 10,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        : Container(),
                    !testMCQController!.isList.value
                        ? StreamBuilder(
                            stream: testMCQController!.drawerController.stream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(

                                      // We changed from Row to Wrap
                                      direction: Axis
                                          .horizontal, // we need to specify the direction
                                      children: List.generate(
                                          testMCQController!.testMCQList.length,
                                          (index) {
                                        return itemWidgetQuestionNumbers(
                                            testMCQController!
                                                .testMCQList[index],
                                            index);
                                      })),
                                );
                              } else {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(

                                      // We changed from Row to Wrap
                                      direction: Axis
                                          .horizontal, // we need to specify the direction
                                      children: List.generate(
                                          testMCQController!.testMCQList.length,
                                          (index) {
                                        return itemWidgetQuestionNumbers(
                                            testMCQController!
                                                .testMCQList[index],
                                            index);
                                      })),
                                );
                              }
                            },
                          )
                        : Container(),
                    // Obx(
                    //   () {
                    //     return Container(
                    //       padding: const EdgeInsets.all(5),
                    //       height: 100,
                    //       child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Expanded(
                    //                     flex: 1,
                    //                     child: Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         GestureDetector(
                    //                           onTap: () {
                    //                             if (testMCQController!
                    //                                 .correct.value) {
                    //                               testMCQController!
                    //                                   .correct.value = false;
                    //                             } else {
                    //                               testMCQController!
                    //                                   .correct.value = true;
                    //                             }
                    //                           },
                    //                           child: Container(
                    //                             color: Colors.transparent,
                    //                             margin: const EdgeInsets.all(5),
                    //                             height: 15,
                    //                             width: 15,
                    //                             child: SvgPicture.asset(
                    //                               testMCQController!.correct.value
                    //                                   ? 'assets/images/squaretick.svg'
                    //                                   : 'assets/images/squareborder.svg',
                    //                               width: 15,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           margin: const EdgeInsets.all(5),
                    //                           height: 15,
                    //                           width: 15,
                    //                           child: const Icon(
                    //                             Icons.circle,
                    //                             size: 15,
                    //                             color: Colors.green,
                    //                           ),
                    //                         ),
                    //                         const Text(
                    //                           'Correct',
                    //                           style: TextStyle(
                    //                               color: kTextColor,
                    //                               fontSize: 12),
                    //                         )
                    //                       ],
                    //                     )),
                    //                 Expanded(
                    //                     flex: 1,
                    //                     child: Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         GestureDetector(
                    //                           onTap: () {
                    //                             if (testMCQController!
                    //                                 .saved.value) {
                    //                               testMCQController!.saved.value =
                    //                                   false;
                    //                             } else {
                    //                               testMCQController!.saved.value =
                    //                                   true;
                    //                             }
                    //                           },
                    //                           child: Container(
                    //                             color: Colors.transparent,
                    //                             margin: const EdgeInsets.all(5),
                    //                             height: 15,
                    //                             width: 15,
                    //                             child: SvgPicture.asset(
                    //                               testMCQController!.saved.value
                    //                                   ? 'assets/images/squaretick.svg'
                    //                                   : 'assets/images/squareborder.svg',
                    //                               width: 15,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           margin: const EdgeInsets.all(5),
                    //                           height: 15,
                    //                           width: 15,
                    //                           child: const Icon(
                    //                             Icons.circle,
                    //                             size: 15,
                    //                             color: kDarkBlueColor,
                    //                           ),
                    //                         ),
                    //                         const Text(
                    //                           'Saved',
                    //                           style: TextStyle(
                    //                               color: kTextColor,
                    //                               fontSize: 12),
                    //                         )
                    //                       ],
                    //                     )),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 Expanded(
                    //                     flex: 1,
                    //                     child: Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         GestureDetector(
                    //                           onTap: () {
                    //                             if (testMCQController!
                    //                                 .incorrect.value) {
                    //                               testMCQController!
                    //                                   .incorrect.value = false;
                    //                             } else {
                    //                               testMCQController!
                    //                                   .incorrect.value = true;
                    //                             }
                    //                           },
                    //                           child: Container(
                    //                             color: Colors.transparent,
                    //                             margin: const EdgeInsets.all(5),
                    //                             height: 15,
                    //                             width: 15,
                    //                             child: SvgPicture.asset(
                    //                               testMCQController!
                    //                                       .incorrect.value
                    //                                   ? 'assets/images/squaretick.svg'
                    //                                   : 'assets/images/squareborder.svg',
                    //                               width: 15,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           margin: const EdgeInsets.all(5),
                    //                           height: 15,
                    //                           width: 15,
                    //                           child: const Icon(
                    //                             Icons.circle,
                    //                             size: 15,
                    //                             color: Colors.red,
                    //                           ),
                    //                         ),
                    //                         const Text(
                    //                           'InCorrect',
                    //                           style: TextStyle(
                    //                               color: kTextColor,
                    //                               fontSize: 12),
                    //                         )
                    //                       ],
                    //                     )),
                    //                 Expanded(
                    //                     flex: 1,
                    //                     child: Row(
                    //                       crossAxisAlignment:
                    //                           CrossAxisAlignment.center,
                    //                       children: [
                    //                         GestureDetector(
                    //                           onTap: () {
                    //                             if (testMCQController!
                    //                                 .unattempted.value) {
                    //                               testMCQController!
                    //                                   .unattempted.value = false;
                    //                             } else {
                    //                               testMCQController!
                    //                                   .unattempted.value = true;
                    //                             }
                    //                           },
                    //                           child: Container(
                    //                             color: Colors.transparent,
                    //                             margin: const EdgeInsets.all(5),
                    //                             height: 15,
                    //                             width: 15,
                    //                             child: SvgPicture.asset(
                    //                               testMCQController!
                    //                                       .unattempted.value
                    //                                   ? 'assets/images/squaretick.svg'
                    //                                   : 'assets/images/squareborder.svg',
                    //                               width: 15,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         Container(
                    //                           margin: const EdgeInsets.all(5),
                    //                           height: 15,
                    //                           width: 15,
                    //                           child: const Icon(
                    //                             Icons.circle,
                    //                             size: 15,
                    //                             color: kSecondaryColor,
                    //                           ),
                    //                         ),
                    //                         const Text(
                    //                           'Unattempted',
                    //                           style: TextStyle(
                    //                               color: kTextColor,
                    //                               fontSize: 12),
                    //                         )
                    //                       ],
                    //                     )),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 GestureDetector(
                    //                   onTap: () {
                    //                     testMCQController!.resetStopWatch();
                    //                     testMCQController!.applyFilter();

                    //                     Get.back();

                    //                     Future.delayed(const Duration(seconds: 1),
                    //                         () {
                    //                       setState(() {});
                    //                     });
                    //                   },
                    //                   child: Container(
                    //                     height: 30,
                    //                     width: 100,
                    //                     padding: const EdgeInsets.only(
                    //                         left: 15, right: 15),
                    //                     decoration: boxDecorationValidTill(
                    //                         kDarkBlueColor, kDarkBlueColor, 10),
                    //                     child: const Center(
                    //                       child: Text(
                    //                         "Apply Filter",
                    //                         textAlign: TextAlign.center,
                    //                         style: TextStyle(
                    //                           fontSize: 12.0,
                    //                           color: Colors.white,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 10,
                    //                 ),
                    //                 GestureDetector(
                    //                   onTap: () {
                    //                     testMCQController!.resetStopWatch();
                    //                     testMCQController!.clearFilter();
                    //                     Get.back();
                    //                     setState(() {});
                    //                   },
                    //                   child: Container(
                    //                     height: 30,
                    //                     width: 100,
                    //                     padding: const EdgeInsets.only(
                    //                         left: 15, right: 15),
                    //                     decoration: boxDecorationRectBorder(
                    //                         Colors.white,
                    //                         Colors.white,
                    //                         kDarkBlueColor),
                    //                     child: const Center(
                    //                       child: Text(
                    //                         "Clear",
                    //                         textAlign: TextAlign.center,
                    //                         style: TextStyle(
                    //                           fontSize: 12.0,
                    //                           color: kDarkBlueColor,
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             )
                    //           ]),
                    //     );
                    //   },
                    // )
                  ],
                ));
          },
        )),
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
                        height: 130.h,
                        decoration: const BoxDecoration(
                          // border: Border.all(color: kPrimaryColorDark),
                          color: kPrimaryColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              paymentController!.appBar(
                                  false,
                                  testFrom == 'Test'
                                      ? 'MCQ Test'
                                      : 'View Solution',
                                  kPrimaryColorDark,
                                  context,
                                  scaffoldKey),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 25,
                                            width: 25,
                                            child: SvgPicture.asset(
                                              'assets/images/whitegate.svg',
                                              width: 25.w,
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              examName!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8.sp,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subjectName!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                        Text(
                                          testName!,
                                          // 'Topic: ' + topicName!,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     showModalBottomSheet<void>(
                                  //       // context and builder are
                                  //       // required properties in this widget
                                  //       context: context,
                                  //       builder: (BuildContext context) {
                                  //         // we set up a container inside which
                                  //         // we create center column and display text

                                  //         // Returning SizedBox instead of a Container
                                  //         return SingleChildScrollView(
                                  //           child: Container(
                                  //             height: 400,
                                  //             child: ScientificCalculator(),
                                  //           ),
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  //   child: Container(
                                  //     height: 30.h,
                                  //     // width: 15.w,
                                  //     child: const Image(
                                  //       image: AssetImage(
                                  //         'assets/images/calculator.png',
                                  //       ),
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              testFrom == 'Test'
                                  ? Container(
                                      alignment: Alignment.centerRight,
                                      height: 15.h,
                                      width: 90.w,
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: boxDecorationValidTill(
                                          kPrimaryColor, kPrimaryColor, 10),
                                      child: Obx(
                                        () {
                                          return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  height: 10,
                                                  width: 10,
                                                  child: SvgPicture.asset(
                                                    'assets/images/orangeclock.svg',
                                                    width: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Center(
                                                  child: Text(
                                                    testMCQController!
                                                            .convertToHour(
                                                                testMCQController!
                                                                    .start!.value)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        testMCQController!
                                                            .convertToMinutes(
                                                                testMCQController!
                                                                    .start!
                                                                    .value)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        testMCQController!
                                                            .convertToSeconds(
                                                                testMCQController!
                                                                    .start!
                                                                    .value)
                                                            .value
                                                            .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ]);
                                        },
                                      ))
                                  : Container(),
                            ]),
                      ),
                      Expanded(
                        child: Obx(
                          () {
                            testMCQController!.setNumericAnswer();
                            return Container(
                              padding: const EdgeInsets.all(2),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(5),
                                    height: 40,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.all(0),
                                      itemCount:
                                          testMCQController!.testMCQList.length,
                                      itemBuilder: (context, index) {
                                        return itemWidgetQuestionNumbers(
                                            testMCQController!
                                                .testMCQList[index],
                                            index);
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (testMCQController!
                                                        .testTypeSelected
                                                        .value ==
                                                    1) {
                                                  testMCQController!
                                                      .changeTestTypeFilter(2);
                                                }
                                              },
                                              child: Container(
                                                height: 25.h,
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                decoration: testMCQController!
                                                            .testTypeSelected
                                                            .value ==
                                                        2
                                                    ? boxDecorationValidTill(
                                                        kBlueColor,
                                                        kBlueColor,
                                                        10)
                                                    : boxDecorationValidTill(
                                                        Colors.white,
                                                        Colors.white,
                                                        10),
                                                child: Center(
                                                  child: Text(
                                                    "General Aptitude",
                                                    textAlign: TextAlign.center,
                                                    style: testMCQController!
                                                                .testTypeSelected
                                                                .value ==
                                                            2
                                                        ? TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.white,
                                                          )
                                                        : TextStyle(
                                                            fontSize: 10.sp,
                                                            color: kTextColor,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (testMCQController!
                                                        .testTypeSelected
                                                        .value ==
                                                    2) {
                                                  testMCQController!
                                                      .changeTestTypeFilter(1);
                                                }
                                              },
                                              child: Container(
                                                height: 25.h,
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                margin: const EdgeInsets.only(
                                                    right: 5),
                                                decoration: testMCQController!
                                                            .testTypeSelected
                                                            .value ==
                                                        1
                                                    ? boxDecorationValidTill(
                                                        kBlueColor,
                                                        kBlueColor,
                                                        10)
                                                    : boxDecorationValidTill(
                                                        Colors.white,
                                                        Colors.white,
                                                        10),
                                                child: Center(
                                                  child: Text(
                                                    "Technical",
                                                    textAlign: TextAlign.center,
                                                    style: testMCQController!
                                                                .testTypeSelected
                                                                .value ==
                                                            1
                                                        ? TextStyle(
                                                            fontSize: 10.sp,
                                                            color: Colors.white,
                                                          )
                                                        : TextStyle(
                                                            fontSize: 10.sp,
                                                            color: kTextColor,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        testFrom == 'Test'
                                            ? GestureDetector(
                                                onTap: () {
                                                  testMCQController!
                                                      .getWholeTestSubmittedBefore(
                                                          testId!, 'SUBMIT');
                                                },
                                                child: Container(
                                                  height: 25.h,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  decoration:
                                                      boxDecorationValidTill(
                                                          Colors.green,
                                                          Colors.green,
                                                          10),
                                                  child: Center(
                                                    child: Text(
                                                      "SUBMIT",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Visibility(
                                      replacement: Container(),
                                      visible: testMCQController!
                                              .testMCQList[testMCQController!
                                                  .selectedIndex.value]
                                              .isVisible! &&
                                          testMCQController!
                                              .testMCQList.isNotEmpty,

                                      // visible: (testMCQController!
                                      //     .showQuestion
                                      //     .value) //testMCQController!.testMCQList.isNotEmpty

                                      child: ListView(
                                          padding: const EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          shrinkWrap: true,
                                          children: [
                                            Container(
                                                decoration: boxDecorationRect(
                                                    Colors.white, Colors.white),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 20,
                                                          width: 20,
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5,
                                                                  top: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              boxDecorationStep(
                                                                  kPrimaryColorLight,
                                                                  kPrimaryColor,
                                                                  kPrimaryColor),
                                                          child: Text(
                                                            (testMCQController!
                                                                        .selectedIndex
                                                                        .value +
                                                                    1)
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: TeXView(
                                                            loadingWidgetBuilder:
                                                                ((context) {
                                                              return const Text(
                                                                  "Loading...");
                                                            }),
                                                            renderingEngine:
                                                                renderingEngine,
                                                            child:
                                                                TeXViewColumn(
                                                                    children: [
                                                                  TeXViewDocument(
                                                                      (testMCQController!
                                                                              .testMCQList
                                                                              .isNotEmpty)
                                                                          ? testMCQController!
                                                                              .testMCQList[testMCQController!
                                                                                  .selectedIndex.value]
                                                                              .question!
                                                                          : "",
                                                                      style: const TeXViewStyle(
                                                                          textAlign:
                                                                              TeXViewTextAlign.left)),
                                                                ]),
                                                            style: TeXViewStyle(
                                                              // margin:
                                                              //     const TeXViewMargin
                                                              //         .all(5),
                                                              fontStyle:
                                                                  TeXViewFontStyle(
                                                                      fontSize:
                                                                          14),
                                                              padding:
                                                                  const TeXViewPadding
                                                                          .only(
                                                                      left: 5,
                                                                      top: 5),
                                                              backgroundColor:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Question ' +
                                                                (testMCQController!
                                                                            .selectedIndex
                                                                            .value +
                                                                        1)
                                                                    .toString() +
                                                                ' out of ' +
                                                                (testMCQController!
                                                                        .testMCQList
                                                                        .length)
                                                                    .toString(),
                                                            style: const TextStyle(
                                                                fontSize: 10,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color:
                                                                    kSecondaryColor),
                                                          ),
                                                          Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                                children: [
                                                                  // testMCQController!
                                                                  //             .testMCQList
                                                                  //             .isNotEmpty &&
                                                                  //         testMCQController!
                                                                  //             .testMCQList[testMCQController!
                                                                  //                 .selectedIndex.value]
                                                                  //             .userSelectedAnswerApp!
                                                                  //             .isEmpty &&
                                                                  //         testFrom ==
                                                                  //             'Test'
                                                                  //     ? Obx(
                                                                  //         () {
                                                                  //           return Text(
                                                                  //             testMCQController!.hoursStr.value + ':' + testMCQController!.minutesStr.value + ':' + testMCQController!.secondsStr.value,
                                                                  //             textAlign: TextAlign.center,
                                                                  //             style: const TextStyle(fontSize: 10.0, color: kPrimaryColorDark),
                                                                  //           );
                                                                  //         },
                                                                  //       )
                                                                  //     : Container(),
                                                                  // const SizedBox(
                                                                  //   width: 10,
                                                                  // ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Row(
                                                                        children: [
                                                                          const Text(
                                                                            'Marks:',
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                            '+' +
                                                                                testMCQController!.testMCQList[testMCQController!.selectedIndex.value].positiveMark.toString(),
                                                                            style: const TextStyle(
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.green),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            '-' +
                                                                                testMCQController!.testMCQList[testMCQController!.selectedIndex.value].negetiveMark.toString(),
                                                                            style: const TextStyle(
                                                                                fontSize: 10,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.red),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              testMCQController!.getTestBookmarked(
                                                                                testMCQController!.testMCQList[testMCQController!.selectedIndex.value].id.toString(),
                                                                                false,
                                                                                0,
                                                                              );
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: const EdgeInsets.all(5),
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: SvgPicture.asset(
                                                                                (testMCQController!.testMCQList.isNotEmpty && testMCQController!.testMCQList[testMCQController!.selectedIndex.value].isBookmark == 1) ? 'assets/images/bookmark_solid.svg' : 'assets/images/bookmark_border.svg',
                                                                                width: 20,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              showDialog(

                                                                                  // useSafeArea:
                                                                                  //     true,
                                                                                  context: context,
                                                                                  builder: ((BuildContext context) {
                                                                                    testMCQController!.alertList = StaticArrays.getAlertList().obs;
                                                                                    testMCQController!.isOtherSelected.value = false;
                                                                                    testMCQController!.reportCommentController!.text = '';
                                                                                    return AlertDialog(
                                                                                      // insetPadding: EdgeInsets.zero,
                                                                                      contentPadding: EdgeInsets.zero,
                                                                                      shape: const RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.all(
                                                                                        Radius.circular(15),
                                                                                      )),
                                                                                      title: const Text(
                                                                                        "Report this question !",
                                                                                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: kPrimaryColor),
                                                                                        textAlign: TextAlign.left,
                                                                                      ),
                                                                                      content: SingleChildScrollView(
                                                                                          physics: AlwaysScrollableScrollPhysics(),
                                                                                          child: Form(
                                                                                            key: testMCQController!.reportFormKey,
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                              children: <Widget>[
                                                                                                StreamBuilder(
                                                                                                  stream: testMCQController!.drawerControllerAlert.stream,
                                                                                                  builder: (context, snapshot) {
                                                                                                    if (snapshot.hasData) {
                                                                                                      return Column(
                                                                                                        children: [
                                                                                                          ListView.builder(
                                                                                                            shrinkWrap: true,
                                                                                                            physics: const AlwaysScrollableScrollPhysics(),
                                                                                                            itemCount: testMCQController!.alertList.length,
                                                                                                            itemBuilder: (context, index) {
                                                                                                              return itemWidgetAlert(testMCQController!.alertList[index], index);
                                                                                                            },
                                                                                                          ),
                                                                                                          testMCQController!.isOtherSelected.value
                                                                                                              ? Padding(
                                                                                                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                                                                                  child: SizedBox(
                                                                                                                    width: MediaQuery.of(context).size.width / 1.2,
                                                                                                                    // height: MediaQuery.of(context).size.height / 3.5,
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextFormField(
                                                                                                                        textAlign: TextAlign.start,
                                                                                                                        controller: testMCQController!.reportCommentController,
                                                                                                                        keyboardType: TextInputType.multiline,
                                                                                                                        minLines: 5,
                                                                                                                        maxLines: 15,
                                                                                                                        textCapitalization: TextCapitalization.sentences,
                                                                                                                        onChanged: (value) {},
                                                                                                                        validator: (value) {
                                                                                                                          return validateReportComment(value!);
                                                                                                                        },
                                                                                                                        style: const TextStyle(fontSize: 14),
                                                                                                                        decoration: const InputDecoration(contentPadding: EdgeInsets.all(5), hintText: 'Leave your comments here', hintStyle: TextStyle(color: kSecondaryColor)),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                )
                                                                                                              : Container(),
                                                                                                        ],
                                                                                                      );
                                                                                                    } else {
                                                                                                      return Column(
                                                                                                        children: [
                                                                                                          ListView.builder(
                                                                                                            shrinkWrap: true,
                                                                                                            physics: const AlwaysScrollableScrollPhysics(),
                                                                                                            itemCount: testMCQController!.alertList.length,
                                                                                                            itemBuilder: (context, index) {
                                                                                                              return itemWidgetAlert(testMCQController!.alertList[index], index);
                                                                                                            },
                                                                                                          ),
                                                                                                          testMCQController!.isOtherSelected.value
                                                                                                              ? Padding(
                                                                                                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                                                                                  child: SizedBox(
                                                                                                                    width: MediaQuery.of(context).size.width / 1.2,
                                                                                                                    // height: MediaQuery.of(context).size.height / 3.5,
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextFormField(
                                                                                                                        textAlign: TextAlign.start,
                                                                                                                        controller: testMCQController!.reportCommentController,
                                                                                                                        keyboardType: TextInputType.multiline,
                                                                                                                        minLines: 5,
                                                                                                                        maxLines: 15,
                                                                                                                        textCapitalization: TextCapitalization.sentences,
                                                                                                                        onChanged: (value) {},
                                                                                                                        validator: (value) {
                                                                                                                          return validateReportComment(value!);
                                                                                                                        },
                                                                                                                        style: const TextStyle(fontSize: 14),
                                                                                                                        decoration: const InputDecoration(contentPadding: EdgeInsets.all(5), hintText: 'Leave your comments here', hintStyle: TextStyle(color: kSecondaryColor)),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                )
                                                                                                              : Container(),
                                                                                                        ],
                                                                                                      );
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          )),
                                                                                      actions: <Widget>[
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            GestureDetector(
                                                                                              onTap: () {
                                                                                                bool isOne = false;
                                                                                                String? comments = '';
                                                                                                for (int i = 0; i < testMCQController!.alertList.length; i++) {
                                                                                                  if (testMCQController!.alertList[i].isSelected!) {
                                                                                                    isOne = true;
                                                                                                    if (comments == '') {
                                                                                                      comments = testMCQController!.alertList[i].name!;
                                                                                                    } else {
                                                                                                      comments = comments! + ', ' + testMCQController!.alertList[i].name!;
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                                if (!isOne) {
                                                                                                  showFlutterToast('Select atleast on issue');
                                                                                                } else {
                                                                                                  testMCQController!.checkReport(listingController!.selectedTypeId.value, comments!);
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 35,
                                                                                                width: 100,
                                                                                                padding: const EdgeInsets.only(left: 15, right: 15),
                                                                                                decoration: boxDecorationValidTill(kPrimaryColorDark, kPrimaryColorDarkLight, 10),
                                                                                                child: const Center(
                                                                                                  child: Text(
                                                                                                    "Report",
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
                                                                                                decoration: boxDecorationRectBorder(Colors.white, Colors.white, kDarkBlueColor),
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
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: const EdgeInsets.all(5),
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: SvgPicture.asset(
                                                                                'assets/images/report.svg',
                                                                                width: 20,
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ]),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            testFrom == 'Test'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet<
                                                              void>(
                                                            // context and builder are
                                                            // required properties in this widget
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              // we set up a container inside which
                                                              // we create center column and display text

                                                              // Returning SizedBox instead of a Container
                                                              return SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                  height: 400,
                                                                  child:
                                                                      ScientificCalculator(),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  10),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          // width: 120,
                                                          decoration:
                                                              boxDecorationRevise(
                                                                  kSecondaryColor,
                                                                  kSecondaryColor,
                                                                  10),
                                                          child: Row(children: [
                                                            SizedBox(
                                                              height: 20,
                                                              width: 20,
                                                              child: Image(
                                                                color:
                                                                    kPrimaryColorDark,
                                                                image:
                                                                    AssetImage(
                                                                  'assets/images/calculator.png',
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              'Use Calculator',
                                                              // maxLines: 1,
                                                              // overflow: TextOverflow
                                                              //     .ellipsis,
                                                              style: TextStyle(
                                                                  color:
                                                                      kPrimaryColorDark,
                                                                  fontSize: 12),
                                                            ),
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                            (testMCQController!.testMCQList
                                                        .isNotEmpty) &&
                                                    (testMCQController!
                                                                .testMCQList[
                                                                    testMCQController!
                                                                        .selectedIndex
                                                                        .value]
                                                                .type ==
                                                            1 ||
                                                        testMCQController!
                                                                .testMCQList[
                                                                    testMCQController!
                                                                        .selectedIndex
                                                                        .value]
                                                                .type ==
                                                            2)
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    itemCount: testMCQController!
                                                        .testMCQList[
                                                            testMCQController!
                                                                .selectedIndex
                                                                .value]
                                                        .getOption!
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return itemWidgetOptions(
                                                          testMCQController!
                                                                  .testMCQList[
                                                                      testMCQController!
                                                                          .selectedIndex
                                                                          .value]
                                                                  .getOption![
                                                              index],
                                                          index,
                                                          testMCQController!
                                                                  .testMCQList[
                                                              testMCQController!
                                                                  .selectedIndex
                                                                  .value]);
                                                    },
                                                  )
                                                : Container(),
                                            ((testMCQController!.testMCQList
                                                            .isNotEmpty &&
                                                        testMCQController!
                                                                .testMCQList[
                                                                    testMCQController!
                                                                        .selectedIndex
                                                                        .value]
                                                                .type ==
                                                            3 &&
                                                        testFrom == 'Test') ||
                                                    (testMCQController!
                                                            .testMCQList[
                                                                testMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .userSelectedAnswerApp!
                                                            .isNotEmpty &&
                                                        testMCQController!
                                                                .testMCQList[
                                                                    testMCQController!
                                                                        .selectedIndex
                                                                        .value]
                                                                .type ==
                                                            3 &&
                                                        testFrom == 'Solution'))
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextFormField(
                                                      readOnly:
                                                          testFrom == 'Solution'
                                                              ? true
                                                              : false,
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller: testMCQController!
                                                          .numericAnswerController,
                                                      keyboardType:
                                                          const TextInputType
                                                                  .numberWithOptions(
                                                              decimal: true),
                                                      onChanged: (value) {
                                                        testMCQController!
                                                            .testMCQList[
                                                                testMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .userTempAnswer!
                                                            .clear();
                                                        testMCQController!
                                                            .testMCQList[
                                                                testMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .userSelectedAnswerApp!
                                                            .clear();

                                                        if (testMCQController!
                                                            .testMCQList[
                                                                testMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .userTempAnswer!
                                                            .isEmpty) {
                                                          testMCQController!
                                                              .testMCQList[
                                                                  testMCQController!
                                                                      .selectedIndex
                                                                      .value]
                                                              .userTempAnswer!
                                                              .add(value
                                                                  .toString());
                                                        } else {
                                                          testMCQController!
                                                                  .testMCQList[
                                                                      testMCQController!
                                                                          .selectedIndex
                                                                          .value]
                                                                  .userTempAnswer![0] =
                                                              value.toString();
                                                        }
                                                      },
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .deny(
                                                                RegExp('[ ]')),
                                                        // FilteringTextInputFormatter
                                                        //     .allow(RegExp(
                                                        //         r'^\d+\.?\d*')),
                                                      ],
                                                      style: (testMCQController!.testMCQList[testMCQController!.selectedIndex.value].userSelectedAnswerApp!.isNotEmpty && (double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) >= double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getOption![0].optionMin.toString())) && (double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) <= double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getOption![0].optionMax.toString()))) &&
                                                              testFrom ==
                                                                  'Solution'
                                                          ? const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)
                                                          : (testMCQController!.testMCQList[testMCQController!.selectedIndex.value].userSelectedAnswerApp!.isNotEmpty && ((double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) < double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getOption![0].optionMin.toString())) || (double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) > double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getOption![0].optionMax.toString())))) &&
                                                                  testFrom ==
                                                                      'Solution'
                                                              ? const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)
                                                              : (testMCQController!.testMCQList[testMCQController!.selectedIndex.value].userSelectedAnswerApp!.isNotEmpty &&
                                                                      testFrom ==
                                                                          'Test')
                                                                  ? const TextStyle(
                                                                      fontSize: 14,
                                                                      color: kBlueColor,
                                                                      fontWeight: FontWeight.w500)
                                                                  : const TextStyle(fontSize: 14),
                                                      decoration: const InputDecoration(
                                                          hintText:
                                                              'Enter numeric answer',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  kSecondaryColor)),
                                                    ),
                                                  )
                                                : Container(),
                                            testFrom == 'Solution' &&
                                                    testMCQController!
                                                            .testMCQList[
                                                                testMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .type ==
                                                        3
                                                ? Container(
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(children: [
                                                      const Text(
                                                        'Range : ',
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColorDark,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        testMCQController!
                                                                .testMCQList[
                                                                    testMCQController!
                                                                        .selectedIndex
                                                                        .value]
                                                                .getOption![0]
                                                                .optionMin!
                                                                .toString() +
                                                            " - ",
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColorDark,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        testMCQController!
                                                            .testMCQList[
                                                                testMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .getOption![0]
                                                            .optionMax
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                kPrimaryColorDark,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ]),
                                                  )
                                                : Container(),
                                            testFrom == 'Solution'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                        Card(
                                                          elevation: 3,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .all(5),
                                                                    height: 15,
                                                                    width: 15,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/images/orangeclock.svg',
                                                                      width: 15,
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      const Text(
                                                                        'Your Time',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                10.0,
                                                                            color:
                                                                                kPrimaryColor,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          testMCQController!.convertToHour(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].takenTime!).value.toString() +
                                                                              ':' +
                                                                              testMCQController!.convertToMinutes(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].takenTime!).value.toString() +
                                                                              ':' +
                                                                              testMCQController!.convertToSeconds(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].takenTime!).value.toString(),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: const TextStyle(
                                                                              fontSize: 10.0,
                                                                              color: kPrimaryColor,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              )),
                                                        ),
                                                        Card(
                                                          elevation: 3,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets
                                                                        .all(5),
                                                                    height: 15,
                                                                    width: 15,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/images/blueclock.svg',
                                                                      width: 15,
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        'Avg. Time',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontSize: 10
                                                                                .sp,
                                                                            color:
                                                                                kPrimaryColorDark,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getTestAnswer != null
                                                                              ? (testMCQController!.convertToHour(double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getTestAnswer!.averageTime!).round()).value.toString() + ':' + testMCQController!.convertToMinutes(double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getTestAnswer!.averageTime!).round()).value.toString() + ':' + testMCQController!.convertToSeconds(double.parse(testMCQController!.testMCQList[testMCQController!.selectedIndex.value].getTestAnswer!.averageTime!).round()).value.toString())
                                                                              : '00:00:00',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: const TextStyle(
                                                                              fontSize: 10.0,
                                                                              color: kPrimaryColorDark,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              )),
                                                        )
                                                      ])
                                                : Container(),
                                            Visibility(
                                              visible: testFrom == 'Solution'
                                                  ? true
                                                  : false,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Solution',
                                                      style: TextStyle(
                                                          color: kDarkBlueColor,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: TeXView(
                                                        loadingWidgetBuilder:
                                                            ((context) {
                                                          return const Text(
                                                              "Loading...");
                                                        }),
                                                        renderingEngine:
                                                            renderingEngine,
                                                        child: TeXViewDocument(
                                                            (testMCQController!
                                                                    .testMCQList
                                                                    .isNotEmpty)
                                                                ? testMCQController!
                                                                    .testMCQList[
                                                                        testMCQController!
                                                                            .selectedIndex
                                                                            .value]
                                                                    .solution
                                                                    .toString()
                                                                : "",
                                                            style: TeXViewStyle(
                                                                contentColor:
                                                                    Colors
                                                                        .black,
                                                                fontStyle:
                                                                    TeXViewFontStyle(
                                                                        fontSize:
                                                                            12),
                                                                textAlign:
                                                                    TeXViewTextAlign
                                                                        .left)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 45,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            testMCQController!
                                                .previousQuestion();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            height: 25,
                                            width: 25,
                                            child: SvgPicture.asset(
                                              'assets/images/leftarrow.svg',
                                              width: 25,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              testFrom == 'Test' ? true : false,
                                          child: GestureDetector(
                                            onTap: () {
                                              testMCQController!
                                                  .markReviewAnswer();
                                            },
                                            child: Container(
                                              height: 35.h,
                                              width: 110.w,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration:
                                                  boxDecorationValidTill(
                                                      kPurpleColor,
                                                      kPurpleColor,
                                                      10),
                                              child: Center(
                                                child: Text(
                                                  "Mark & Review",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              testFrom == 'Test' ? true : false,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                testMCQController!
                                                    .clearAnswer();
                                              });
                                            },
                                            child: Container(
                                              height: 35.h,
                                              width: 60.w,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              decoration:
                                                  boxDecorationRectBorder(
                                                      Colors.white,
                                                      Colors.white,
                                                      kBlueColor),
                                              child: Center(
                                                child: Text(
                                                  "Clear",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: kBlueColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              testFrom == 'Test' ? true : false,
                                          child: GestureDetector(
                                            onTap: () {
                                              // if (testMCQController!
                                              //         .selectedIndex.value ==
                                              //     testMCQController!
                                              //             .testMCQList.length -
                                              //         1) {
                                              //   showLoader();

                                              // }

                                              testMCQController!.submitAnswer(
                                                  listingController!
                                                      .selectedTypeId.value);
                                            },
                                            child: Container(
                                              height: 35.h,
                                              width: 100.w,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              decoration:
                                                  boxDecorationValidTill(
                                                      kPrimaryColorDark,
                                                      kPrimaryColorDarkLight,
                                                      10),
                                              child: Center(
                                                child: Text(
                                                  "Save & Next",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        testFrom == 'Solution'
                                            ? GestureDetector(
                                                onTap: () {
                                                  testMCQController!
                                                      .nextQuestion(
                                                          listingController!
                                                              .selectedTypeId
                                                              .value);
                                                },
                                                child: SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: SvgPicture.asset(
                                                    'assets/images/rightarrow.svg',
                                                    width: 25,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  // Obx(
                  //   () {
                  //     return Visibility(
                  //       maintainState: false,
                  //       maintainAnimation: false,
                  //       maintainInteractivity: false,
                  //       maintainSemantics: false,
                  //       maintainSize: false,
                  //       visible: (testMCQController!.testMCQList.isNotEmpty &&
                  //           testMCQController!.showGif.value),
                  //       child: Container(
                  //         height: MediaQuery.of(context).size.height,
                  //         decoration: BoxDecoration(
                  //           color: kPrimaryColorDark.withOpacity(0.5),
                  //         ),
                  //         child: GifView.asset(
                  //           (testMCQController!.testMCQList.isNotEmpty &&
                  //                   testMCQController!
                  //                           .testMCQList[testMCQController!
                  //                               .selectedIndex.value]
                  //                           .isAnswerTrue ==
                  //                       1)
                  //               ? 'assets/images/correctanswer.gif'
                  //               : 'assets/images/wronganswer.gif',
                  //           loop: false,
                  //           onFinish: () {
                  //             testMCQController!.showGif.value = false;
                  //           },
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openEndDrawer();
                      },
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: SvgPicture.asset(
                          'assets/images/blackarrow.svg',
                          width: 25,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget itemWidgetOptions(GetOption options, int index, TestMcqData data) {
    return InkWell(
      onTap: () {
        if (testFrom == 'Test') {
          testMCQController!.onSelectionOfOption(
              data,
              index,
              options,
              options.id.toString(),
              options.isUserSelected!,
              listingController!.selectedTypeId.value);
        }
      },
      child: Container(
          decoration: ((data.userSelectedAnswerApp!
                              .contains(options.id.toString()) &&
                          options.isTrue == 1) ||
                      (data.userSelectedAnswerApp!.isNotEmpty &&
                          options.isTrue == 1)) &&
                  testFrom == 'Solution'
              ? boxDecorationRectBorder(Colors.lightGreen[100]!,
                  Colors.lightGreen[100]!, Colors.green)
              : ((data.userSelectedAnswerApp!.contains(options.id.toString()) &&
                          options.isTrue == 0)) &&
                      testFrom == 'Solution'
                  ? boxDecorationRectBorder(
                      const Color.fromARGB(255, 255, 181, 174),
                      const Color.fromARGB(255, 255, 181, 174),
                      Colors.red)
                  : (data.userSelectedAnswerApp!.isNotEmpty &&
                          data.userSelectedAnswerApp!
                              .contains(options.id.toString()) &&
                          testFrom == 'Test')
                      ? boxDecorationRectBorder(
                          kLightBlueColor, kLightBlueColor, kTextColor)
                      : ((options.isTrue == 1) || (options.isTrue == 1)) &&
                              testFrom == 'Solution'
                          ? boxDecorationRectBorder(
                              kLightBlueColor, kLightBlueColor, kLightBlueColor)
                          : (data.userTempAnswer!.isNotEmpty &&
                                  data.userTempAnswer!
                                      .contains(options.id.toString()) &&
                                  testFrom == 'Test')
                              ? boxDecorationRectBorder(
                                  kLightBlueColor, kLightBlueColor, kTextColor)
                              : boxDecorationRectBorder(Colors.transparent, Colors.transparent, kBlueColor),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          child: Row(children: [
            (data.userSelectedAnswerApp!.contains(options.id.toString()) ||
                        data.userTempAnswer!.contains(options.id.toString())) ||
                    (data.userSelectedAnswerApp!.isNotEmpty &&
                        !data.userSelectedAnswerApp!
                            .contains(options.id.toString()) &&
                        options.isTrue == 1)
                ? Container()
                : Container(
                    height: 25,
                    alignment: Alignment.center,
                    width: 25,
                    decoration: boxDecorationStep(
                        Colors.white, Colors.white, kSecondaryColor),
                    child: Text(
                      testMCQController!.convertToABCD(index),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
            (data.userTempAnswer!.contains(options.id.toString()) ||
                        data.userSelectedAnswerApp!
                            .contains(options.id.toString())) &&
                    data.type == 1 &&
                    testFrom == 'Test'
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      'assets/images/radio_button.svg',
                      width: 25,
                      color: kPrimaryColorDark,
                    ),
                  )
                : Container(),
            (data.userTempAnswer!.contains(options.id.toString()) ||
                        data.userSelectedAnswerApp!
                            .contains(options.id.toString())) &&
                    data.type == 2 &&
                    testFrom == 'Test'
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      'assets/images/checkbox_button.svg',
                      width: 25,
                      color: kPrimaryColorDark,
                    ),
                  )
                : Container(),
            ((data.userSelectedAnswerApp!.contains(options.id.toString()) &&
                            options.isTrue == 1) ||
                        (data.userSelectedAnswerApp!.isNotEmpty &&
                            options.isTrue == 1)) &&
                    testFrom == 'Solution'
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      'assets/images/checkbox_button.svg',
                      width: 25,
                      color: Colors.green,
                    ),
                  )
                : Container(),
            ((data.userSelectedAnswerApp!.contains(options.id.toString()) &&
                        options.isTrue == 0)) &&
                    testFrom == 'Solution'
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      'assets/images/wrong.svg',
                      width: 25,
                      color: Colors.red,
                    ),
                  )
                // : (data.userSelectedAnswerApp!
                //                 .contains(options.id.toString()) &&
                //             data.type == 1) &&
                //         testFrom == 'Test'
                //     ? SizedBox(
                //         height: 25,
                //         width: 25,
                //         child: SvgPicture.asset(
                //           'assets/images/radio_button.svg',
                //           width: 25,
                //           color: kPrimaryColorDark,
                //         ),
                //       )
                //     : (data.userSelectedAnswerApp!
                //                     .contains(options.id.toString()) &&
                //                 data.type == 2) &&
                //             testFrom == 'Test'
                //         ? SizedBox(
                //             height: 25,
                //             width: 25,
                //             child: SvgPicture.asset(
                //               'assets/images/checkbox_button.svg',
                //               width: 25,
                //               color: kPrimaryColorDark,
                //             ),
                //           )
                : Container(),
            Expanded(
                child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              alignment: Alignment.centerLeft,
              child: TeXView(
                  loadingWidgetBuilder: ((context) {
                    return const Text("Loading...");
                  }),
                  renderingEngine: renderingEngine,
                  child: TeXViewInkWell(
                    onTap: (value) {
                      if (testFrom == 'Test') {
                        testMCQController!.onSelectionOfOption(
                            data,
                            index,
                            options,
                            options.id.toString(),
                            options.isUserSelected!,
                            listingController!.selectedTypeId.value);
                      }
                    },
                    child: TeXViewDocument(options.option.toString(),
                        style: TeXViewStyle(
                            contentColor: Colors.black,
                            fontStyle: TeXViewFontStyle(fontSize: 14),
                            textAlign: TeXViewTextAlign.left)),
                    id: options.id.toString(),
                  )),
            ))
          ])),
    );
  }

  Widget itemWidgetQuestionNumbers(TestMcqData model, int index) {
    print(model.isAnswerTrue);
    print(model.userSelectedAnswerApp);
    print(model.isSkip);
    print(model.isBookmark);

    if (testMCQController!.isCorrect.value ||
        testMCQController!.isSaved.value ||
        testMCQController!.isInCorrect.value ||
        testMCQController!.isUnattempted.value ||
        testMCQController!.isAnswered.value ||
        testMCQController!.isMarkReviewNoAnswer.value ||
        testMCQController!.isMarkReviewWithAnswer.value) {
      if (testMCQController!.isCorrect.value && model.isAnswerTrue == 1) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      } else if ((testFrom == 'Test') &&
          testMCQController!.isSaved.value &&
          (model.isBookmark == 1)) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      } else if (testMCQController!.isInCorrect.value &&
          (model.isAnswerTrue == 0 &&
              model.userSelectedAnswerApp!.isNotEmpty)) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      } else if ((testFrom == 'Test') &&
          testMCQController!.isUnattempted.value &&
          (model.userSelectedAnswerApp!.isEmpty &&
              model.markReview == 0 &&
              model.isBookmark == 0)) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      } else if ((testFrom == 'Test') &&
          testMCQController!.isAnswered.value &&
          (model.userSelectedAnswerApp!.isNotEmpty && model.markReview == 0)) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      } else if ((testFrom == 'Test') &&
          testMCQController!.isMarkReviewNoAnswer.value &&
          (model.userSelectedAnswerApp!.isEmpty && model.markReview == 1)) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      } else if ((testFrom == 'Test') &&
          testMCQController!.isMarkReviewWithAnswer.value &&
          (model.userSelectedAnswerApp!.isNotEmpty && model.markReview == 1)) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      } else if ((testFrom == 'Solution') &&
          testMCQController!.isUnattempted.value &&
          (model.userSelectedAnswerApp!.isEmpty)) {
        testMCQController!.testMCQList[index].isVisible = true;

        return itemWidgetQuestionNumbersLayout(model, index);
      }

      testMCQController!.testMCQList[index].isVisible = false;

      return SizedBox();
    } else {
      testMCQController!.testMCQList[index].isVisible = true;

      return itemWidgetQuestionNumbersLayout(model, index);
    }
  }

  Widget itemWidgetQuestionNumbersLayout(TestMcqData model, int index) {
    // testMCQController!.commentWidgets
    //     .add(itemWidgetQuestionNumbersLayout(model, index));
    return Container(
      height: 40,
      width: 40,
      child: InkWell(
        onTap: () {
          testMCQController!.drawerController.sink.add('N/A');
          testMCQController!.resetStopWatch();
          testMCQController!.startStopWatch();
          testMCQController!.selectedIndex.value = index;
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 30,
              width: 30,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: index == testMCQController!.selectedIndex.value
                  ? boxDecorationStep(Colors.white, Colors.white, Colors.black)
                  : boxDecorationStep(Colors.white, Colors.white, Colors.white),
            ),
            Container(
              height: 25,
              alignment: Alignment.center,
              width: 25,
              margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: (model.isAnswerTrue == 1 && testFrom == 'Solution')
                  ? boxDecorationStep(Colors.lightGreen[100]!,
                      Colors.lightGreen[100]!, Colors.green)
                  : (model.isAnswerTrue == 0 &&
                          model.userSelectedAnswerApp!.isNotEmpty &&
                          testFrom == 'Solution')
                      ? boxDecorationStep(
                          const Color.fromARGB(255, 255, 181, 174),
                          const Color.fromARGB(255, 255, 181, 174),
                          Colors.red)
                      : (model.isSkip == 1 && testFrom == 'Test') //ADDEDTEST
                          ? boxDecorationStep(
                              kSecondaryColor, kSecondaryColor, kTextColor)
                          : (model.userSelectedAnswerApp!.isNotEmpty &&
                                  testFrom == 'Test')
                              ? boxDecorationStep(
                                  kLightBlueColor, kLightBlueColor, kTextColor)
                              : boxDecorationStep(
                                  Colors.white, Colors.white, kTextColor),
              child: Text(
                (index + 1).toString(),
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.w500),
              ),
            ),
            (model.isBookmark == 1 && testFrom == 'Test') //ADDEDTEST
                ? Container(
                    width: 25,
                    height: 25,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(
                        'assets/images/bookmark_solid.svg',
                        width: 10,
                        height: 10,
                      ),
                    ),
                  )
                : Container(),
            (model.markReview == 1 && testFrom == 'Test') //ADDEDTEST
                ? Container(
                    width: 25,
                    height: 25,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: SvgPicture.asset(
                        'assets/images/checkbox_button.svg',
                        width: 10,
                        height: 10,
                        color: kPurpleColor,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget itemWidgetQuestionFilter(TestMcqData model, int index) {
    return Container(
        // boxDecorationRectBorder
        // decoration: (model.isAnswerTrue == 1 && testFrom == 'Solution')
        //     ? boxDecorationRectBorder(
        //         Colors.lightGreen[100]!, Colors.lightGreen[100]!, Colors.green)
        //     : (model.isAnswerTrue == 0 &&
        //             model.userSelectedAnswerApp!.isNotEmpty &&
        //             testFrom == 'Solution')
        //         ? boxDecorationRectBorder(
        //             const Color.fromARGB(255, 255, 181, 174),
        //             const Color.fromARGB(255, 255, 181, 174),
        //             Colors.red)
        //         : (model.isSkip == 1)
        //             ? boxDecorationRectBorder(
        //                 kSecondaryColor, kSecondaryColor, kTextColor)
        //             // : (model.markReview == 1)
        //             //     ? boxDecorationRectBorder(
        //             //         kLightPurpleColor, kLightPurpleColor, kTextColor)
        //             : (model.userSelectedAnswerApp!.isNotEmpty &&
        //                     testFrom == 'Test')
        //                 ? boxDecorationRectBorder(
        //                     kLightBlueColor, kLightBlueColor, kTextColor)
        //                 : boxDecorationRectBorder(
        //                     Colors.white, Colors.white, kTextColor),

        decoration:
            boxDecorationRectBorder(Colors.white, Colors.white, kTextColor),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        child: Container(
          color: Colors.transparent,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   height: 25,
                //   alignment: Alignment.center,
                //   width: 25,
                //   decoration: boxDecorationStep(
                //       Colors.white, Colors.white, kSecondaryColor),
                //   child: Text(
                //     (index + 1).toString(),
                //     style: const TextStyle(
                //         color: Colors.black, fontWeight: FontWeight.w500),
                //   ),
                // ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration:
                          index == testMCQController!.selectedIndex.value
                              ? boxDecorationStep(
                                  Colors.white, Colors.white, Colors.black)
                              : boxDecorationStep(
                                  Colors.white, Colors.white, Colors.white),
                    ),
                    Container(
                      height: 20,
                      alignment: Alignment.center,
                      width: 20,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration: (model.isAnswerTrue == 1 &&
                              testFrom == 'Solution')
                          ? boxDecorationStep(Colors.lightGreen[100]!,
                              Colors.lightGreen[100]!, Colors.green)
                          : (model.isAnswerTrue == 0 &&
                                  model.userSelectedAnswerApp!.isNotEmpty &&
                                  testFrom == 'Solution')
                              ? boxDecorationStep(
                                  const Color.fromARGB(255, 255, 181, 174),
                                  const Color.fromARGB(255, 255, 181, 174),
                                  Colors.red)
                              : (model.isSkip == 1 &&
                                      testFrom == 'Test') //ADDEDTEST
                                  ? boxDecorationStep(kSecondaryColor,
                                      kSecondaryColor, kTextColor)
                                  : (model.userSelectedAnswerApp!.isNotEmpty &&
                                          testFrom == 'Test')
                                      ? boxDecorationStep(kLightBlueColor,
                                          kLightBlueColor, kTextColor)
                                      : boxDecorationStep(Colors.white,
                                          Colors.white, kTextColor),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  alignment: Alignment.centerLeft,
                  child: TeXView(
                      loadingWidgetBuilder: ((context) {
                        return const Text("Loading...");
                      }),
                      renderingEngine: renderingEngine,
                      child: TeXViewInkWell(
                        onTap: (value) {
                          Get.back();
                          testMCQController!.resetStopWatch();
                          testMCQController!.startStopWatch();
                          testMCQController!.selectedIndex.value = index;
                        },
                        child: TeXViewDocument(model.question.toString(),
                            style: TeXViewStyle(
                                contentColor: Colors.black,
                                fontStyle: TeXViewFontStyle(fontSize: 12),
                                textAlign: TeXViewTextAlign.left)),
                        id: (index + 1).toString(),
                      )),
                )),
                model.markReview == 1 && testFrom == 'Test' //ADDEDTEST
                    ? Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(
                          'assets/images/checkbox_button.svg',
                          width: 20,
                          height: 20,
                          color: kPurpleColor,
                        ),
                      )
                    : Container(),

                testFrom == 'Test'
                    ? //ADDEDTEST
                    Container(
                        height: 20,
                        width: 20,
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            testMCQController!.getTestBookmarked(
                                model.id.toString(), true, index);
                          },
                          child: SvgPicture.asset(
                            (model.isBookmark == 1)
                                ? 'assets/images/bookmark_solid.svg'
                                : 'assets/images/bookmark_border.svg',
                            width: 20,
                            height: 20,
                            alignment: Alignment.topRight,
                          ),
                        ),
                      )
                    : Container(),
              ]),
        ));
  }

  void beforeDialog() {
    showDialog(
        // useSafeArea:
        //     true,
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
              "Test Submission",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
              textAlign: TextAlign.left,
            ),
            content: SingleChildScrollView(
                child: Form(
              // key: testMCQController!.reportFormKey,
              child: Column(
                children: <Widget>[
                  Text(
                    "Summary",
                    style: TextStyle(fontSize: 14.0, color: kTextColor),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 5, bottom: 5),
                  //   child: SizedBox(
                  //     // width: MediaQuery.of(context).size.width / 1.2,
                  //     // height: MediaQuery.of(context).size.height / 3.5,
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(10),
                  //     ),
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: boxDecorationDialog(
                            kLightBlueColor, kLightBlueColor, Colors.white),
                        height: 60,
                        width: 120,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 15.h,
                                width: 15.w,
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/testtimeleft.png',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Time Left",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        color: kPrimaryColorDark),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "00:00:00",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: kPrimaryColorDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ]),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: boxDecorationDialog(Colors.green[100]!,
                            Colors.green[100]!, Colors.white),
                        height: 60,
                        width: 120,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 15.h,
                                width: 15.w,
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/testattempt.png',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Attempted",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.green),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    // '0',
                                    testMCQController!
                                        .beforeSubmitData!.totalAttempted
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ]),
                      )
                    ],
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: boxDecorationDialog(
                            Colors.red[100]!, Colors.red[100]!, Colors.white),
                        height: 60,
                        width: 120,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 15.h,
                                width: 15.w,
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/testunattempted.png',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Unattempted",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.red),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    // '0',
                                    (testMCQController!.beforeSubmitData!
                                                .totalQuestion! -
                                            testMCQController!.beforeSubmitData!
                                                .totalAttempted!)
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ]),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: boxDecorationDialog(Colors.amber[100]!,
                            Colors.amber[100]!, Colors.white),
                        height: 60,
                        width: 120,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 15.h,
                                width: 15.w,
                                child: const Image(
                                  image: AssetImage(
                                    'assets/images/testbookmark.png',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Revised",
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.amber),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    // '0',
                                    testMCQController!
                                        .beforeSubmitData!.totalReviewed
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              )
                            ]),
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    color: kSecondaryColor,
                    height: 0.5,
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Are you sure you want to submit the  test?",
                      style: TextStyle(fontSize: 12.0, color: kTextColor),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get.toNamed(AppRoutes.scorecard);
                      Get.back(result: 'success');
                      testMCQController!.getWholeTestSubmittedFinal(testId!);
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationValidTill(
                          kPrimaryColorDark, kPrimaryColorDarkLight, 10),
                      child: const Center(
                        child: Text(
                          "Submit",
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
                          "Resume",
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

  void instructionsDialog() {
    showDialog(
        barrierColor: Colors.black54,
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SingleChildScrollView(
                  child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.2,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Test Instructions",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          TeXView(
                            loadingWidgetBuilder: ((context) {
                              return const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Loading..."),
                              );
                            }),
                            renderingEngine: renderingEngine,
                            child: TeXViewColumn(children: [
                              TeXViewDocument(testIntro.toString(),
                                  style: const TeXViewStyle(
                                      textAlign: TeXViewTextAlign.left)),
                            ]),
                            style: TeXViewStyle(
                              contentColor: kTextColor,
                              margin: const TeXViewMargin.all(5),
                              fontStyle: TeXViewFontStyle(fontSize: 12),
                              padding: const TeXViewPadding.all(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      testMCQController!.startTimer();
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  )
                ],
              )),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      testMCQController!.startTimer();
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationRectBorder(
                          kDarkBlueColor, kDarkBlueColor, kDarkBlueColor),
                      child: const Center(
                        child: Text(
                          "Dismiss",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
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

  Widget itemWidgetAlert(IdStringNameModel model, int index) {
    return InkWell(
      onTap: () {
        if (model.isSelected!) {
          model.isSelected = false;
        } else {
          model.isSelected = true;
        }

        if (model.id == 1 && model.isSelected!) {
          testMCQController!.isOtherSelected.value = true;
        } else if (model.id == 1 && !model.isSelected!) {
          testMCQController!.isOtherSelected.value = false;
        }

        testMCQController!.drawerControllerAlert.sink.add('N/A');
      },
      child: Container(
          decoration: model.isSelected!
              ? boxDecorationRectBorder(
                  kDarkBlueColor, kDarkBlueColor, kDarkBlueColor)
              : boxDecorationRectBorder(
                  Colors.transparent, Colors.transparent, kTextColor),
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              alignment: Alignment.centerLeft,
              child: Text(
                model.name.toString(),
                style: model.isSelected!
                    ? TextStyle(fontSize: 12, color: Colors.white)
                    : TextStyle(fontSize: 12, color: kTextColor),
              ),
            )
          ])),
    );
  }
}
