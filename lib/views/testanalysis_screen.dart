import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/testmcq_controller.dart';
import 'package:flutter_practicekiya/models/competitive_model.dart';
import 'package:flutter_practicekiya/models/practicetopicleaderboard_model.dart';
import 'package:flutter_practicekiya/models/questionwise_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:pie_chart/pie_chart.dart';

import '../controllers/listing_controller.dart';
import '../controllers/payment_controller.dart';

import '../models/practicemcq_model.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';

class TestAnalysisScreen extends StatefulWidget {
  const TestAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<TestAnalysisScreen> createState() => _TestAnalysisScreenState();
}

class _TestAnalysisScreenState extends State<TestAnalysisScreen> {
  TestMCQController? testMCQController;
  PaymentController? paymentController;
  ListingController? listingController;
  String? examId, examName, testId, testFrom, testName, subjectName;
  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.mathjax();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    testMCQController = Get.find<TestMCQController>();
    paymentController = Get.find<PaymentController>();
    listingController = Get.find<ListingController>();
    testMCQController!
        .addTopicLeaderBoardItems(listingController!.selectedTypeId.value);

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      testMCQController!.selectedTestAnalysisTab.value = '1';

      testMCQController!.getTopicWise(testId!);
    });
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
                Column(
                  children: [
                    Container(
                      height: 120.h,
                      decoration: const BoxDecoration(
                        color: kPrimaryColorDark,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(children: [
                        paymentController!.appBar(false, 'Topic Analysis',
                            kPrimaryColorDark, context, scaffoldKey),
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
                                      padding: const EdgeInsets.only(left: 5),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                          ],
                        )
                      ]),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Obx(
                          () => GestureDetector(
                            onTap: () {
                              testMCQController!.changeTestAnalysisType('1'.obs,
                                  listingController!.selectedTypeId.value);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Topic Wise',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: testMCQController!
                                                      .selectedTestAnalysisTab
                                                      .value ==
                                                  '1'
                                              ? Colors.black
                                              : kTextColor),
                                    ),
                                    testMCQController!.selectedTestAnalysisTab
                                                .value ==
                                            '1'
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            height: 3,
                                            width: 70,
                                            decoration: boxDecorationValidTill(
                                                kPrimaryColorLight,
                                                kPrimaryColor,
                                                20),
                                          )
                                        : Container()
                                  ]),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Obx(
                          () => GestureDetector(
                            onTap: () {
                              testMCQController!.changeTestAnalysisType('2'.obs,
                                  listingController!.selectedTypeId.value);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Question Wise',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: testMCQController!
                                                      .selectedTestAnalysisTab
                                                      .value ==
                                                  '2'
                                              ? Colors.black
                                              : kTextColor),
                                    ),
                                    testMCQController!.selectedTestAnalysisTab
                                                .value ==
                                            '2'
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            height: 3,
                                            width: 70,
                                            decoration: boxDecorationValidTill(
                                                kPrimaryColorLight,
                                                kPrimaryColor,
                                                20),
                                          )
                                        : Container()
                                  ]),
                            ),
                          ),
                        )),
                        Expanded(
                            child: Obx(
                          () => GestureDetector(
                            onTap: () {
                              testMCQController!.changeTestAnalysisType('3'.obs,
                                  listingController!.selectedTypeId.value);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Competitive',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: testMCQController!
                                                      .selectedTestAnalysisTab
                                                      .value ==
                                                  '3'
                                              ? Colors.black
                                              : kTextColor),
                                    ),
                                    testMCQController!.selectedTestAnalysisTab
                                                .value ==
                                            '3'
                                        ? Container(
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                            height: 3,
                                            width: 70,
                                            decoration: boxDecorationValidTill(
                                                kPrimaryColorLight,
                                                kPrimaryColor,
                                                20),
                                          )
                                        : Container()
                                  ]),
                            ),
                          ),
                        )),
                      ],
                    ),
                    Expanded(child: Obx(
                      () {
                        if ((testMCQController!.selectedTestAnalysisTab.value ==
                            '1')) {
                          return ListView(
                            padding: const EdgeInsets.all(5),
                            shrinkWrap: true,
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  height: 200,
                                  child: Column(children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Technical',
                                        style: TextStyle(
                                            color: kPrimaryColorDark,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Score',
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // padding: EdgeInsets.all(5),
                                              child: Text(
                                                testMCQController!
                                                    .topicWiseData!
                                                    .technicalObtainMarks!
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(5),
                                              child: Text(
                                                ' / ',
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(5),
                                              child: Text(
                                                testMCQController!
                                                    .topicWiseData!
                                                    .technicalTotalMarks!
                                                    .toString(),
                                                style: TextStyle(
                                                  color: kTextColor,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                child: Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 40.0,
                                                  lineWidth: 10.0,
                                                  animation: true,
                                                  percent: (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .technicalCorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isInfinite ||
                                                          (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .technicalCorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isNaN
                                                      ? 0
                                                      : ((100 *
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .technicalCorrectQuestion! /
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .totalQuestion!)
                                                                      .round() /
                                                                  100 >
                                                              1
                                                          ? 1
                                                          : (100 *
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .technicalCorrectQuestion! /
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .totalQuestion!)
                                                                  .round() /
                                                              100),
                                                  center: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          testMCQController!
                                                              .topicWiseData!
                                                              .technicalCorrectQuestion!
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0),
                                                        ),
                                                        const Text(
                                                          'Correct',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 10.0),
                                                        )
                                                      ]),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  progressColor: Colors.green,
                                                  rotateLinearGradient: true,
                                                ),
                                                Text(
                                                  testMCQController!
                                                          .topicWiseData!
                                                          .technicalCorrectMarks!
                                                          .toString() +
                                                      ' marks',
                                                  style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            )),
                                            Container(
                                                child: Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 40.0,
                                                  lineWidth: 10.0,
                                                  animation: true,
                                                  percent: (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .technicalIncorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isInfinite ||
                                                          (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .technicalIncorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isNaN
                                                      ? 0
                                                      : ((100 *
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .technicalIncorrectQuestion! /
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .totalQuestion!)
                                                                      .round() /
                                                                  100 >
                                                              1
                                                          ? 1
                                                          : (100 *
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .technicalIncorrectQuestion! /
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .totalQuestion!)
                                                                  .round() /
                                                              100),
                                                  center: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          testMCQController!
                                                              .topicWiseData!
                                                              .technicalIncorrectQuestion!
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                        const Text(
                                                          'Incorrect',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 10.0),
                                                        )
                                                      ]),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  progressColor: kPrimaryColor,
                                                  rotateLinearGradient: true,
                                                ),
                                                Text(
                                                  testMCQController!
                                                          .topicWiseData!
                                                          .technicalIncorrectMarks!
                                                          .toString() +
                                                      ' marks',
                                                  style: const TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            )),
                                            Container(
                                                child: Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 40.0,
                                                  lineWidth: 10.0,
                                                  animation: true,
                                                  percent: (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .technicalSkipQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isInfinite ||
                                                          (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .technicalSkipQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isNaN
                                                      ? 0
                                                      : ((100 *
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .technicalSkipQuestion! /
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .totalQuestion!)
                                                                      .round() /
                                                                  100 >
                                                              1
                                                          ? 1
                                                          : (100 *
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .technicalSkipQuestion! /
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .totalQuestion!)
                                                                  .round() /
                                                              100),
                                                  center: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          testMCQController!
                                                              .topicWiseData!
                                                              .technicalSkipQuestion!
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0),
                                                        ),
                                                        const Text(
                                                          'Skipped',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 10.0),
                                                        )
                                                      ]),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  progressColor: Colors.black45,
                                                  rotateLinearGradient: true,
                                                ),
                                                Text(
                                                  testMCQController!
                                                          .topicWiseData!
                                                          .technicalSkipMarks!
                                                          .toString() +
                                                      ' marks',
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            ))
                                          ]),
                                    )
                                  ]),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  height: 200,
                                  child: Column(children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'General Aptitude',
                                        style: TextStyle(
                                            color: kPrimaryColorDark,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                      // padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Score',
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              // padding: EdgeInsets.all(5),
                                              child: Text(
                                                testMCQController!
                                                    .topicWiseData!
                                                    .generalAptitudeObtainMarks!
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(5),
                                              child: Text(
                                                ' / ',
                                                style: TextStyle(
                                                    color: kTextColor,
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              // padding: EdgeInsets.all(5),
                                              child: Text(
                                                testMCQController!
                                                    .topicWiseData!
                                                    .generalAptitudeTotalMarks!
                                                    .toString(),
                                                style: TextStyle(
                                                  color: kTextColor,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                                child: Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 40.0,
                                                  lineWidth: 10.0,
                                                  animation: true,
                                                  percent: (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .generalAptitudeCorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isInfinite ||
                                                          (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .generalAptitudeCorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isNaN
                                                      ? 0
                                                      : ((100 *
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .generalAptitudeCorrectQuestion! /
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .totalQuestion!)
                                                                      .round() /
                                                                  100 >
                                                              1
                                                          ? 1
                                                          : (100 *
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .generalAptitudeCorrectQuestion! /
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .totalQuestion!)
                                                                  .round() /
                                                              100),
                                                  center: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          testMCQController!
                                                              .topicWiseData!
                                                              .generalAptitudeCorrectQuestion!
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0),
                                                        ),
                                                        const Text(
                                                          'Correct',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 10.0),
                                                        )
                                                      ]),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  progressColor: Colors.green,
                                                  rotateLinearGradient: true,
                                                ),
                                                Text(
                                                  testMCQController!
                                                          .topicWiseData!
                                                          .generalAptitudeCorrectMarks!
                                                          .toString() +
                                                      ' marks',
                                                  style: const TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            )),
                                            Container(
                                                child: Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 40.0,
                                                  lineWidth: 10.0,
                                                  animation: true,
                                                  percent: (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .generalAptitudeIncorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isInfinite ||
                                                          (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .generalAptitudeIncorrectQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isNaN
                                                      ? 0
                                                      : ((100 *
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .generalAptitudeIncorrectQuestion! /
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .totalQuestion!)
                                                                      .round() /
                                                                  100 >
                                                              1
                                                          ? 1
                                                          : (100 *
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .generalAptitudeIncorrectQuestion! /
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .totalQuestion!)
                                                                  .round() /
                                                              100),
                                                  center: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          testMCQController!
                                                              .topicWiseData!
                                                              .generalAptitudeIncorrectMarks!
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18.0),
                                                        ),
                                                        const Text(
                                                          'Incorrect',
                                                          style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 10.0),
                                                        )
                                                      ]),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  progressColor: kPrimaryColor,
                                                  rotateLinearGradient: true,
                                                ),
                                                Text(
                                                  testMCQController!
                                                          .topicWiseData!
                                                          .technicalIncorrectMarks!
                                                          .toString() +
                                                      ' marks',
                                                  style: const TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            )),
                                            Container(
                                                child: Column(
                                              children: [
                                                CircularPercentIndicator(
                                                  radius: 40.0,
                                                  lineWidth: 10.0,
                                                  animation: true,
                                                  percent: (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .generalAptitudeSkipQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isInfinite ||
                                                          (100 *
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .generalAptitudeSkipQuestion! /
                                                                  testMCQController!
                                                                      .topicWiseData!
                                                                      .totalQuestion!)
                                                              .isNaN
                                                      ? 0
                                                      : ((100 *
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .generalAptitudeSkipQuestion! /
                                                                          testMCQController!
                                                                              .topicWiseData!
                                                                              .totalQuestion!)
                                                                      .round() /
                                                                  100 >
                                                              1
                                                          ? 1
                                                          : (100 *
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .generalAptitudeSkipQuestion! /
                                                                      testMCQController!
                                                                          .topicWiseData!
                                                                          .totalQuestion!)
                                                                  .round() /
                                                              100),
                                                  center: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          testMCQController!
                                                              .topicWiseData!
                                                              .generalAptitudeSkipQuestion!
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      18.0),
                                                        ),
                                                        const Text(
                                                          'Skipped',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 10.0),
                                                        )
                                                      ]),
                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  progressColor: Colors.black45,
                                                  rotateLinearGradient: true,
                                                ),
                                                Text(
                                                  testMCQController!
                                                          .topicWiseData!
                                                          .generalAptitudeSkipMarks!
                                                          .toString() +
                                                      ' marks',
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            ))
                                          ]),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          );
                        } else if ((testMCQController!
                                .selectedTestAnalysisTab.value ==
                            '2')) {
                          return testMCQController!.questionWiseList.isNotEmpty
                              ? Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      child: Card(
                                        color: kDarkBlueColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                            child: Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Questions',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Mark',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Your Time',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  'Best Time',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                  ),
                                                ))
                                          ],
                                        )),
                                      ),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      padding: const EdgeInsets.only(top: 0),
                                      // separatorBuilder: (context, index) =>
                                      //     const Divider(),
                                      itemCount: testMCQController!
                                          .questionWiseList.length,
                                      itemBuilder: (context, index) {
                                        return itemWidgetQuestionWise(
                                            testMCQController!
                                                .questionWiseList[index],
                                            index);
                                      },
                                    )),
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
                        } else if ((testMCQController!
                                .selectedTestAnalysisTab.value ==
                            '3')) {
                          return testMCQController!
                                  .competitiveStudentList.isNotEmpty
                              ? Column(
                                  children: [
                                    Card(
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Topic Wise Test',
                                                        style: TextStyle(
                                                            fontSize: 14.sp,
                                                            color:
                                                                kPrimaryColorDark,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            'assets/images/gateimg.svg',
                                                            width: 35.w,
                                                          ),
                                                          Expanded(
                                                              child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                testMCQController!
                                                                    .currentUserData!
                                                                    .subjectname
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColorDark,
                                                                  fontSize:
                                                                      12.sp,
                                                                ),
                                                              ),
                                                              Text(
                                                                testMCQController!
                                                                        .currentUserData!
                                                                        .topicname
                                                                        .toString() +
                                                                    ' | ' +
                                                                    testName!,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      kPrimaryColorDark,
                                                                  fontSize:
                                                                      12.sp,
                                                                ),
                                                              )
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                      Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                // padding: EdgeInsets.all(5),
                                                                child: Text(
                                                                  testMCQController!
                                                                      .currentUserData!
                                                                      .obtainMarks
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          22.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                // padding: EdgeInsets.all(5),
                                                                child: Text(
                                                                  ' / ',
                                                                  style: TextStyle(
                                                                      color:
                                                                          kTextColor,
                                                                      fontSize:
                                                                          20.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              Container(
                                                                // padding: EdgeInsets.all(5),
                                                                child: Text(
                                                                  testMCQController!
                                                                      .currentUserData!
                                                                      .totalMarks
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        kTextColor,
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Text(
                                                        'Your Marks',
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color:
                                                                kPrimaryColorDark,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        'PracticeKiya makes perfect',
                                                        style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors.black,
                                                          fontSize: 10.sp,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(5),
                                              alignment: Alignment.bottomCenter,
                                              height: 100.h,
                                              width: 100.w,
                                              margin:
                                                  EdgeInsets.only(bottom: 10),
                                              child: const Image(
                                                image: AssetImage(
                                                  'assets/images/cup3.png',
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        height: 170,
                                        child: Column(children: [
                                          Container(
                                            height: 55,
                                            child: Stack(children: [
                                              Container(
                                                height: 43,
                                                alignment: Alignment.centerLeft,
                                                decoration: boxDecorationRevise(
                                                    kPrimaryColorDark,
                                                    kPrimaryColorDarkLight,
                                                    10),
                                                padding: EdgeInsets.only(
                                                    bottom: 5,
                                                    right: 5,
                                                    left: 80),
                                                child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                        testMCQController!
                                                            .currentUserData!
                                                            .fullname
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                        ),
                                                      )),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        margin:
                                                            EdgeInsets.all(0),
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                testMCQController!
                                                                    .currentUserData!
                                                                    .rankNo
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18.0),
                                                              ),
                                                              Text(
                                                                'Your Rank',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10.0),
                                                              )
                                                            ]),
                                                      )
                                                    ]),
                                              ),
                                              Container(
                                                child: Row(children: [
                                                  Stack(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    children: [
                                                      Container(
                                                        height: 55,
                                                        width: 55,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        margin: const EdgeInsets
                                                            .only(left: 5),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            const BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                spreadRadius:
                                                                    0.0,
                                                                color: Colors
                                                                    .black26,
                                                                offset: Offset(
                                                                    1.0, 10.0),
                                                                blurRadius:
                                                                    20.0),
                                                          ],
                                                          color: Colors.white,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      75.0),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder:
                                                                "assets/images/user_placeholder.png",
                                                            imageErrorBuilder:
                                                                (context, url,
                                                                        error) =>
                                                                    const Image(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              image: AssetImage(
                                                                  'assets/images/user_placeholder.png'),
                                                            ),
                                                            fit: BoxFit.cover,
                                                            height: 55,
                                                            width: 55,
                                                            image: RemoteServices
                                                                    .imageMainLink +
                                                                testMCQController!
                                                                    .currentUserData!
                                                                    .image!,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 25.h,
                                                        width: 25.w,
                                                        margin: EdgeInsets.only(
                                                            left: 50),
                                                        child: const Image(
                                                          image: AssetImage(
                                                            'assets/images/fire.png',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                              ),
                                            ]),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                      child: Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 40.0,
                                                        lineWidth: 10.0,
                                                        animation: true,
                                                        percent: (100 *
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalCorrectQuestion! /
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalQuestion!)
                                                                    .isInfinite ||
                                                                (100 *
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalCorrectQuestion! /
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalQuestion!)
                                                                    .isNaN
                                                            ? 0
                                                            : ((100 * testMCQController!.currentUserData!.totalCorrectQuestion! / testMCQController!.currentUserData!.totalQuestion!)
                                                                            .round() /
                                                                        100 >
                                                                    1
                                                                ? 1
                                                                : (100 *
                                                                            testMCQController!.currentUserData!.totalCorrectQuestion! /
                                                                            testMCQController!.currentUserData!.totalQuestion!)
                                                                        .round() /
                                                                    100),
                                                        center: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                testMCQController!
                                                                    .currentUserData!
                                                                    .totalCorrectQuestion!
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18.0),
                                                              ),
                                                              const Text(
                                                                'Correct',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .green,
                                                                    fontSize:
                                                                        10.0),
                                                              )
                                                            ]),
                                                        circularStrokeCap:
                                                            CircularStrokeCap
                                                                .round,
                                                        progressColor:
                                                            Colors.green,
                                                        rotateLinearGradient:
                                                            true,
                                                      ),
                                                      Text(
                                                        testMCQController!
                                                                .currentUserData!
                                                                .totalCorrectMarks!
                                                                .toString() +
                                                            ' marks',
                                                        style: const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10.0),
                                                      )
                                                    ],
                                                  )),
                                                  Container(
                                                      child: Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 40.0,
                                                        lineWidth: 10.0,
                                                        animation: true,
                                                        percent: (100 *
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalIncorrectQuestion! /
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalQuestion!)
                                                                    .isInfinite ||
                                                                (100 *
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalIncorrectQuestion! /
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalQuestion!)
                                                                    .isNaN
                                                            ? 0
                                                            : ((100 * testMCQController!.currentUserData!.totalIncorrectQuestion! / testMCQController!.currentUserData!.totalQuestion!)
                                                                            .round() /
                                                                        100 >
                                                                    1
                                                                ? 1
                                                                : (100 *
                                                                            testMCQController!.currentUserData!.totalIncorrectQuestion! /
                                                                            testMCQController!.currentUserData!.totalQuestion!)
                                                                        .round() /
                                                                    100),
                                                        center: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                testMCQController!
                                                                    .currentUserData!
                                                                    .totalIncorrectQuestion!
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18.0),
                                                              ),
                                                              const Text(
                                                                'Incorrect',
                                                                style: TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        10.0),
                                                              )
                                                            ]),
                                                        circularStrokeCap:
                                                            CircularStrokeCap
                                                                .round,
                                                        progressColor:
                                                            kPrimaryColor,
                                                        rotateLinearGradient:
                                                            true,
                                                      ),
                                                      Text(
                                                        testMCQController!
                                                                .currentUserData!
                                                                .totalIncorrectMarks!
                                                                .toString() +
                                                            ' marks',
                                                        style: const TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10.0),
                                                      )
                                                    ],
                                                  )),
                                                  Container(
                                                      child: Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 40.0,
                                                        lineWidth: 10.0,
                                                        animation: true,
                                                        percent: (100 *
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalSkipQuestion! /
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalQuestion!)
                                                                    .isInfinite ||
                                                                (100 *
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalSkipQuestion! /
                                                                        testMCQController!
                                                                            .currentUserData!
                                                                            .totalQuestion!)
                                                                    .isNaN
                                                            ? 0
                                                            : ((100 * testMCQController!.currentUserData!.totalSkipQuestion! / testMCQController!.currentUserData!.totalQuestion!)
                                                                            .round() /
                                                                        100 >
                                                                    1
                                                                ? 1
                                                                : (100 *
                                                                            testMCQController!.currentUserData!.totalSkipQuestion! /
                                                                            testMCQController!.currentUserData!.totalQuestion!)
                                                                        .round() /
                                                                    100),
                                                        center: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                testMCQController!
                                                                    .currentUserData!
                                                                    .totalSkipQuestion!
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18.0),
                                                              ),
                                                              const Text(
                                                                'Skipped',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black45,
                                                                    fontSize:
                                                                        10.0),
                                                              )
                                                            ]),
                                                        circularStrokeCap:
                                                            CircularStrokeCap
                                                                .round,
                                                        progressColor:
                                                            Colors.black45,
                                                        rotateLinearGradient:
                                                            true,
                                                      ),
                                                      Text(
                                                        testMCQController!
                                                                .currentUserData!
                                                                .totalSkipMarks!
                                                                .toString() +
                                                            ' marks',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10.0),
                                                      )
                                                    ],
                                                  ))
                                                ]),
                                          )
                                        ]),
                                      ),
                                    ),

                                    Container(
                                      height: 235,
                                      child: Obx(() {
                                        return Stack(children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            // height: 230,
                                            child: PageView.builder(
                                              controller: testMCQController!
                                                  .sliderController.value,
                                              itemCount: testMCQController!
                                                  .competitiveStudentList
                                                  .length,
                                              onPageChanged: (dynamic index) {
                                                // homeController!.ChangeColor();
                                              },
                                              itemBuilder: (_, index) {
                                                return itemWidgetCompetitive(
                                                    testMCQController!
                                                            .competitiveStudentList[
                                                        index],
                                                    index);
                                              },
                                            ),
                                          ),
                                          testMCQController!
                                                      .competitiveStudentList
                                                      .length !=
                                                  1
                                              ? Container(
                                                  height: 235,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (testMCQController!
                                                                  .sliderController
                                                                  .value
                                                                  .page!
                                                                  .round() !=
                                                              0) {
                                                            testMCQController!
                                                                .sliderController
                                                                .value
                                                                .animateToPage(
                                                                    testMCQController!
                                                                            .sliderController
                                                                            .value
                                                                            .page!
                                                                            .round() -
                                                                        1,
                                                                    duration:
                                                                        Duration(
                                                                      seconds:
                                                                          1,
                                                                    ),
                                                                    curve: Curves
                                                                        .ease);
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 25.h,
                                                          width: 25.w,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child: const Image(
                                                            image: AssetImage(
                                                              'assets/images/back.png',
                                                            ),
                                                            color:
                                                                kDarkBlueColor,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (testMCQController!
                                                                  .sliderController
                                                                  .value
                                                                  .page!
                                                                  .round() !=
                                                              testMCQController!
                                                                      .competitiveStudentList
                                                                      .length -
                                                                  1) {
                                                            testMCQController!
                                                                .sliderController
                                                                .value
                                                                .animateToPage(
                                                                    testMCQController!
                                                                            .sliderController
                                                                            .value
                                                                            .page!
                                                                            .round() +
                                                                        1,
                                                                    duration:
                                                                        Duration(
                                                                      seconds:
                                                                          1,
                                                                    ),
                                                                    curve: Curves
                                                                        .ease);
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 25.h,
                                                          width: 25.w,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          child: const Image(
                                                            image: AssetImage(
                                                              'assets/images/rightarrow.png',
                                                            ),
                                                            color:
                                                                kDarkBlueColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container()
                                        ]);
                                      }),
                                    )

                                    // Expanded(
                                    //     child: ListView.builder(
                                    //   padding: const EdgeInsets.only(top: 0),
                                    //   // separatorBuilder: (context, index) =>
                                    //   //     const Divider(),
                                    //   itemCount: testMCQController!
                                    //       .competitiveStudentList.length,
                                    //   itemBuilder: (context, index) {
                                    //     return itemWidgetCompetitive(
                                    //         testMCQController!
                                    //             .competitiveStudentList[index],
                                    //         index);
                                    //   },
                                    // )),
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
                        } else {
                          return Container();
                        }
                      },
                    ))
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget itemWidgetQuestionWise(QuestionWiseData model, int index) {
    return Container(
      height: 40,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
            child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  model.srNo.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: kTextColor,
                  ),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  model.marks.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: kTextColor,
                  ),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  testMCQController!
                          .convertToHour(model.takenTime!)
                          .value
                          .toString() +
                      ':' +
                      testMCQController!
                          .convertToMinutes(model.takenTime!)
                          .value
                          .toString() +
                      ':' +
                      testMCQController!
                          .convertToSeconds(model.takenTime!)
                          .value
                          .toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: kTextColor,
                  ),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  testMCQController!
                          .convertToHour(model.bestTakenTime!)
                          .value
                          .toString() +
                      ':' +
                      testMCQController!
                          .convertToMinutes(model.bestTakenTime!)
                          .value
                          .toString() +
                      ':' +
                      testMCQController!
                          .convertToSeconds(model.bestTakenTime!)
                          .value
                          .toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: kTextColor,
                  ),
                )),
          ],
        )),
      ),
    );
  }

  Widget itemWidgetCompetitive(CurrentUserData model, int index) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          // height: 220,
          child: Column(children: [
            Container(
              height: 55,
              child: Stack(children: [
                Container(
                  height: 43,
                  alignment: Alignment.centerLeft,
                  decoration: boxDecorationRevise(
                      kPrimaryColorDark, kPrimaryColorDarkLight, 10),
                  padding: EdgeInsets.only(bottom: 5, right: 5, left: 80),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(
                          model.fullname.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        )),
                        Container(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.all(0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  model.rankNo.toString().toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                const Text(
                                  'Rank',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10.0),
                                )
                              ]),
                        )
                      ]),
                ),
                Container(
                  child: Row(children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          padding: const EdgeInsets.all(2),
                          margin: const EdgeInsets.only(left: 5),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(75.0),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/user_placeholder.png",
                              imageErrorBuilder: (context, url, error) =>
                                  const Image(
                                alignment: Alignment.center,
                                image: AssetImage(
                                    'assets/images/user_placeholder.png'),
                              ),
                              fit: BoxFit.cover,
                              height: 55,
                              width: 55,
                              image:
                                  RemoteServices.imageMainLink + model.image!,
                            ),
                          ),
                        ),
                        Container(
                          height: 25.h,
                          width: 25.w,
                          margin: EdgeInsets.only(left: 50),
                          child: const Image(
                            image: AssetImage(
                              'assets/images/fire.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ]),
            ),
            Container(
              // padding: EdgeInsets.all(5),
              child: Text(
                'Score',
                style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Container(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // padding: EdgeInsets.all(5),
                      child: Text(
                        model.obtainMarks.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.all(5),
                      child: Text(
                        ' / ',
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.all(5),
                      child: Text(
                        model.totalMarks.toString(),
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        child: Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: (100 *
                                          model.totalCorrectQuestion! /
                                          model.totalQuestion!)
                                      .isInfinite ||
                                  (100 *
                                          model.totalCorrectQuestion! /
                                          model.totalQuestion!)
                                      .isNaN
                              ? 0
                              : ((100 *
                                                  model.totalCorrectQuestion! /
                                                  model.totalQuestion!)
                                              .round() /
                                          100 >
                                      1
                                  ? 1
                                  : (100 *
                                              model.totalCorrectQuestion! /
                                              model.totalQuestion!)
                                          .round() /
                                      100),
                          center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  model.totalCorrectQuestion!.toString(),
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                const Text(
                                  'Correct',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 10.0),
                                )
                              ]),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.green,
                          rotateLinearGradient: true,
                        ),
                        Text(
                          model.totalCorrectMarks!.toString() + ' marks',
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        )
                      ],
                    )),
                    Container(
                        child: Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: (100 *
                                          model.totalIncorrectQuestion! /
                                          model.totalQuestion!)
                                      .isInfinite ||
                                  (100 *
                                          model.totalIncorrectQuestion! /
                                          model.totalQuestion!)
                                      .isNaN
                              ? 0
                              : ((100 *
                                                  model
                                                      .totalIncorrectQuestion! /
                                                  model.totalQuestion!)
                                              .round() /
                                          100 >
                                      1
                                  ? 1
                                  : (100 *
                                              model.totalIncorrectQuestion! /
                                              model.totalQuestion!)
                                          .round() /
                                      100),
                          center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  model.totalIncorrectQuestion!.toString(),
                                  style: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                const Text(
                                  'Incorrect',
                                  style: TextStyle(
                                      color: kPrimaryColor, fontSize: 10.0),
                                )
                              ]),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: kPrimaryColor,
                          rotateLinearGradient: true,
                        ),
                        Text(
                          model.totalIncorrectMarks!.toString() + ' marks',
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        )
                      ],
                    )),
                    Container(
                        child: Column(
                      children: [
                        CircularPercentIndicator(
                          radius: 40.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: (100 *
                                          model.totalSkipQuestion! /
                                          model.totalQuestion!)
                                      .isInfinite ||
                                  (100 *
                                          model.totalSkipQuestion! /
                                          model.totalQuestion!)
                                      .isNaN
                              ? 0
                              : ((100 *
                                                  model.totalSkipQuestion! /
                                                  model.totalQuestion!)
                                              .round() /
                                          100 >
                                      1
                                  ? 1
                                  : (100 *
                                              model.totalSkipQuestion! /
                                              model.totalQuestion!)
                                          .round() /
                                      100),
                          center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  model.totalSkipQuestion!.toString(),
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                const Text(
                                  'Skipped',
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 10.0),
                                )
                              ]),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.black45,
                          rotateLinearGradient: true,
                        ),
                        Text(
                          model.totalSkipMarks!.toString() + ' marks',
                          style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0),
                        )
                      ],
                    ))
                  ]),
            )
          ]),
        ),
      ),
    );
  }
}
