import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/models/practicetopicleaderboard_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:pie_chart/pie_chart.dart';

import '../controllers/listing_controller.dart';
import '../controllers/payment_controller.dart';
import '../controllers/practicemcq_controller.dart';
import '../models/practicemcq_model.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';

class TopicAnalysisScreen extends StatefulWidget {
  const TopicAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<TopicAnalysisScreen> createState() => _TopicAnalysisScreenState();
}

class _TopicAnalysisScreenState extends State<TopicAnalysisScreen> {
  PracticeMCQController? practiceMCQController;
  PaymentController? paymentController;
  ListingController? listingController;
  String? examId = '',
      examName = '',
      subjectId = '',
      subjectName = '',
      chapterId = '',
      chapterName = '',
      chapterLabel = '',
      topicId = '',
      topicName = '';
  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.mathjax();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    practiceMCQController = Get.find<PracticeMCQController>();
    paymentController = Get.find<PaymentController>();
    listingController = Get.find<ListingController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        practiceMCQController!.selectedTopicsTab.value = '1';

        examId = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_exam")['examId'];
        examName = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_exam")['examName'];

        subjectId = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_subject")['subjectId'];
        subjectName = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_subject")['subjectName'];

        chapterId = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_chapter")['chapterId'];
        chapterName = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_chapter")['chapterName'];
        chapterLabel = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_chapter")['chapterLabel'];

        topicId = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_topic")['topicId'];

        topicName = GetIt.I<Map<String, dynamic>>(
            instanceName: "selected_topic")['topicName'];

        practiceMCQController!
            .addTopicLeaderBoardItems(listingController!.selectedTypeId.value);

        if (listingController!.selectedTypeId.value == '1') {
          print('topicId->' + topicId!);

          practiceMCQController!.getTopicAnalysis(topicId!);
        } else if (listingController!.selectedTypeId.value == '3') {
          practiceMCQController!.getPYQTopicAnalysis(topicId!);
        }
      });
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
                                    'Topic: ' + topicName!,
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
                              practiceMCQController!.changeTopicType('1'.obs,
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
                                      'Analysis',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: practiceMCQController!
                                                      .selectedTopicsTab
                                                      .value ==
                                                  '1'
                                              ? Colors.black
                                              : kTextColor),
                                    ),
                                    practiceMCQController!
                                                .selectedTopicsTab.value ==
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
                              practiceMCQController!.changeTopicType('2'.obs,
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
                                      'Saved',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: practiceMCQController!
                                                      .selectedTopicsTab
                                                      .value ==
                                                  '2'
                                              ? Colors.black
                                              : kTextColor),
                                    ),
                                    practiceMCQController!
                                                .selectedTopicsTab.value ==
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
                              practiceMCQController!.changeTopicType('3'.obs,
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
                                      'Leaderboard',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: practiceMCQController!
                                                      .selectedTopicsTab
                                                      .value ==
                                                  '3'
                                              ? Colors.black
                                              : kTextColor),
                                    ),
                                    practiceMCQController!
                                                .selectedTopicsTab.value ==
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
                        if ((practiceMCQController!.selectedTopicsTab.value ==
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
                                  height: 100,
                                  child: Row(children: [
                                    Expanded(
                                      flex: 1,
                                      child: PieChart(
                                        dataMap: practiceMCQController!
                                            .dataMapChapterwise.value,

                                        animationDuration:
                                            const Duration(milliseconds: 800),
                                        chartLegendSpacing: 15,

                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                6.5,
                                        colorList:
                                            practiceMCQController!.colorList,
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.ring,

                                        // gradientList: gradientList,
                                        ringStrokeWidth: 18,

                                        legendOptions: LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: false,
                                            // legendShape: _BoxShape.circle,
                                            legendTextStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                            legendShape: BoxShape.rectangle),
                                        chartValuesOptions:
                                            const ChartValuesOptions(
                                          showChartValueBackground: false,
                                          showChartValues: false,
                                          showChartValuesInPercentage: false,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 1,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: SvgPicture.asset(
                                                      'assets/images/chapterwise.svg',
                                                      // height: 20,
                                                      width: 25,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Progress',
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kDarkBlueColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Correct',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kChartOrangeColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Incorrect',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kSecondaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Unseen',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                        .topicAnalysisModel!
                                                        .data!
                                                        .totalQuestion
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Questions',
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                        .topicAnalysisModel!
                                                        .data!
                                                        .totalCorrect
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                        .topicAnalysisModel!
                                                        .data!
                                                        .totalIncorrect
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    (practiceMCQController!
                                                                .topicAnalysisModel!
                                                                .data!
                                                                .totalQuestion! -
                                                            practiceMCQController!
                                                                .topicAnalysisModel!
                                                                .data!
                                                                .totalCorrect! -
                                                            practiceMCQController!
                                                                .topicAnalysisModel!
                                                                .data!
                                                                .totalIncorrect! -
                                                            practiceMCQController!
                                                                .topicAnalysisModel!
                                                                .data!
                                                                .totalSkip!)
                                                        .toString(),
                                                    // practiceMCQController!
                                                    //     .topicAnalysisModel!
                                                    //     .data!
                                                    //     .totalSkip
                                                    //     .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ]),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  height: 100,
                                  child: Row(children: [
                                    Expanded(
                                      flex: 1,
                                      child: PieChart(
                                        dataMap: practiceMCQController!
                                            .dataMapQueBreakdown.value,

                                        animationDuration:
                                            const Duration(milliseconds: 800),
                                        chartLegendSpacing: 15,

                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                6.5,
                                        colorList:
                                            practiceMCQController!.colorList,
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.ring,

                                        // gradientList: gradientList,
                                        ringStrokeWidth: 18,

                                        legendOptions: LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: false,
                                            // legendShape: _BoxShape.circle,
                                            legendTextStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                            legendShape: BoxShape.rectangle),
                                        chartValuesOptions:
                                            const ChartValuesOptions(
                                          showChartValueBackground: false,
                                          showChartValues: false,
                                          showChartValuesInPercentage: false,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 1,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: SvgPicture.asset(
                                                      'assets/images/quebreakdown.svg',
                                                      // height: 20,
                                                      width: 25,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Accuracy',
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kDarkBlueColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Correct',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kChartOrangeColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Incorrect',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.center,
                                              //   children: [
                                              //     Container(
                                              //       height: 15,
                                              //       width: 15,
                                              //       // margin: const EdgeInsets.only(right: 5),

                                              //       child: const Icon(
                                              //         Icons.circle,
                                              //         size: 10,
                                              //         color: kSecondaryColor,
                                              //       ),
                                              //     ),
                                              //     const Text(
                                              //       'Skipped',
                                              //       overflow:
                                              //           TextOverflow.ellipsis,
                                              //       maxLines: 2,
                                              //       style: TextStyle(
                                              //         color: kSecondaryColor,
                                              //         fontSize: 10,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    (practiceMCQController!
                                                                .topicAnalysisModel!
                                                                .data!
                                                                .totalCorrect! +
                                                            practiceMCQController!
                                                                .topicAnalysisModel!
                                                                .data!
                                                                .totalIncorrect!)
                                                        .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Completed',
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                        .topicAnalysisModel!
                                                        .data!
                                                        .totalCorrect
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                        .topicAnalysisModel!
                                                        .data!
                                                        .totalIncorrect
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.center,
                                              //   children: [
                                              //     Text(
                                              //       practiceMCQController!
                                              //           .topicAnalysisModel!
                                              //           .data!
                                              //           .totalSkip
                                              //           .toString(),
                                              //       overflow:
                                              //           TextOverflow.ellipsis,
                                              //       maxLines: 2,
                                              //       style: const TextStyle(
                                              //         color: kSecondaryColor,
                                              //         fontSize: 10,
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        )),
                                  ]),
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  height: 100,
                                  child: Row(children: [
                                    Expanded(
                                      flex: 1,
                                      child: PieChart(
                                        dataMap: practiceMCQController!
                                            .dataMapTimereakdown.value,

                                        animationDuration:
                                            const Duration(milliseconds: 800),
                                        chartLegendSpacing: 15,

                                        chartRadius:
                                            MediaQuery.of(context).size.width /
                                                6.5,
                                        colorList:
                                            practiceMCQController!.colorList,
                                        initialAngleInDegree: 0,
                                        chartType: ChartType.ring,

                                        // gradientList: gradientList,
                                        ringStrokeWidth: 18,

                                        legendOptions: LegendOptions(
                                            showLegendsInRow: false,
                                            legendPosition:
                                                LegendPosition.right,
                                            showLegends: false,
                                            // legendShape: _BoxShape.circle,
                                            legendTextStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                            legendShape: BoxShape.rectangle),
                                        chartValuesOptions:
                                            const ChartValuesOptions(
                                          showChartValueBackground: false,
                                          showChartValues: false,
                                          showChartValuesInPercentage: false,
                                          showChartValuesOutside: false,
                                          decimalPlaces: 1,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 25,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: SvgPicture.asset(
                                                      'assets/images/timebreakdown.svg',
                                                      // height: 20,
                                                      width: 25,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Speed (Question/Hr)',
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kDarkBlueColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Correct',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kChartOrangeColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Incorrect',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    // margin: const EdgeInsets.only(right: 5),

                                                    child: Icon(
                                                      Icons.circle,
                                                      size: 10,
                                                      color: kSecondaryColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Skipped',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                            .convertToHour(practiceMCQController!.topicAnalysisModel!.data!.totalCorrectTime! +
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalIncorrectTime! +
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalSkipTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToMinutes(practiceMCQController!.topicAnalysisModel!.data!.totalCorrectTime! +
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalIncorrectTime! +
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalSkipTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToSeconds(practiceMCQController!.topicAnalysisModel!.data!.totalCorrectTime! +
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalIncorrectTime! +
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalSkipTime!)
                                                            .value
                                                            .toString(),
                                                    // practiceMCQController!
                                                    //     .subjectAnalysisModel!
                                                    //     .questionBreakdown!
                                                    //     .totalQuestion
                                                    //     .toString(),
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 11.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Time Spent',
                                                    style: TextStyle(
                                                        color:
                                                            kPrimaryColorDark,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                            .convertToHour(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalCorrectTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToMinutes(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalCorrectTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToSeconds(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalCorrectTime!)
                                                            .value
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                            .convertToHour(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalIncorrectTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToMinutes(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalIncorrectTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToSeconds(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalIncorrectTime!)
                                                            .value
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    practiceMCQController!
                                                            .convertToHour(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalSkipTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToMinutes(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalSkipTime!)
                                                            .value
                                                            .toString() +
                                                        ':' +
                                                        practiceMCQController!
                                                            .convertToSeconds(
                                                                practiceMCQController!
                                                                    .topicAnalysisModel!
                                                                    .data!
                                                                    .totalSkipTime!)
                                                            .value
                                                            .toString(),
                                                    // practiceMCQController!
                                                    //     .subjectAnalysisModel!
                                                    //     .questionBreakdown!
                                                    //     .totalSkipTime
                                                    //     .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: kSecondaryColor,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ]),
                                ),
                              ),
                              // Card(
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(10.0),
                              //   ),
                              //   child: Container(
                              //     padding: const EdgeInsets.only(left: 10),
                              //     height: 150,
                              //     child: Column(
                              //       mainAxisAlignment:
                              //           MainAxisAlignment.spaceEvenly,
                              //       children: [
                              //         Container(
                              //           height: 30,
                              //           padding: EdgeInsets.all(5),
                              //           child: Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 Expanded(
                              //                     flex: 1,
                              //                     child: Text(
                              //                       'Progress',
                              //                       style: const TextStyle(
                              //                           color:
                              //                               kPrimaryColorDark,
                              //                           fontSize: 12,
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     )),
                              //                 Expanded(
                              //                   flex: 4,
                              //                   child: LinearPercentIndicator(
                              //                     linearGradient:
                              //                         LinearGradient(
                              //                             begin: Alignment
                              //                                 .centerLeft,
                              //                             stops: [
                              //                           0.1,
                              //                           0.9
                              //                         ],
                              //                             colors: [
                              //                           kChartOrangeColor,
                              //                           kDarkBlueColor,
                              //                         ]),
                              //                     padding:
                              //                         const EdgeInsets.all(0),
                              //                     lineHeight: 12.0,
                              //                     percent:
                              //                         practiceMCQController!
                              //                             .subjectAnalysisModel!
                              //                             .questionBreakdown!
                              //                             .progress!,
                              //                     center: Text(
                              //                       (100 *
                              //                                   (practiceMCQController!
                              //                                       .subjectAnalysisModel!
                              //                                       .questionBreakdown!
                              //                                       .progress!))
                              //                               .round()
                              //                               .toString() +
                              //                           '%',
                              //                       textAlign: TextAlign.left,
                              //                       style: const TextStyle(
                              //                           fontSize: 10.0,
                              //                           color: Colors.white),
                              //                     ),

                              //                     barRadius:
                              //                         const Radius.circular(15),
                              //                     backgroundColor:
                              //                         kSecondaryColor,
                              //                     // progressColor: kDarkBlueColor,
                              //                   ),
                              //                 )
                              //               ]),
                              //         ),
                              //         Container(
                              //           height: 30,
                              //           padding: const EdgeInsets.all(5),
                              //           child: Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 const Expanded(
                              //                     flex: 1,
                              //                     child: Text(
                              //                       'Accuracy',
                              //                       style: TextStyle(
                              //                           color:
                              //                               kPrimaryColorDark,
                              //                           fontSize: 12,
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     )),
                              //                 Expanded(
                              //                   flex: 4,
                              //                   child: LinearPercentIndicator(
                              //                     linearGradient:
                              //                         const LinearGradient(
                              //                             begin: Alignment
                              //                                 .centerLeft,
                              //                             stops: [
                              //                           0.1,
                              //                           0.9
                              //                         ],
                              //                             colors: [
                              //                           kChartOrangeColor,
                              //                           kDarkBlueColor,
                              //                         ]),
                              //                     padding:
                              //                         const EdgeInsets.all(0),
                              //                     lineHeight: 12.0,
                              //                     percent:
                              //                         practiceMCQController!
                              //                             .subjectAnalysisModel!
                              //                             .questionBreakdown!
                              //                             .accuracy!
                              //                             .toDouble(),
                              //                     center: Text(
                              //                       (100 *
                              //                                   (practiceMCQController!
                              //                                       .subjectAnalysisModel!
                              //                                       .questionBreakdown!
                              //                                       .accuracy!
                              //                                       .toDouble()))
                              //                               .round()
                              //                               .toString() +
                              //                           '%',
                              //                       textAlign: TextAlign.left,
                              //                       style: const TextStyle(
                              //                           fontSize: 10.0,
                              //                           color: Colors.white),
                              //                     ),

                              //                     barRadius:
                              //                         const Radius.circular(15),
                              //                     backgroundColor:
                              //                         kSecondaryColor,
                              //                     // progressColor: kDarkBlueColor,
                              //                   ),
                              //                 )
                              //               ]),
                              //         ),
                              //         Container(
                              //           height: 30,
                              //           padding: const EdgeInsets.all(5),
                              //           child: Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 const Expanded(
                              //                     flex: 1,
                              //                     child: Text(
                              //                       'Speed',
                              //                       style: TextStyle(
                              //                           color:
                              //                               kPrimaryColorDark,
                              //                           fontSize: 12,
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     )),
                              //                 Expanded(
                              //                     flex: 4,
                              //                     child: Row(
                              //                       mainAxisAlignment:
                              //                           MainAxisAlignment.end,
                              //                       children: [
                              //                         Text(
                              //                             practiceMCQController!
                              //                                     .subjectAnalysisModel!
                              //                                     .questionBreakdown!
                              //                                     .perhourQuestion!
                              //                                     .toString() +
                              //                                 ' Q/Hr',
                              //                             style: TextStyle(
                              //                                 color: kTextColor,
                              //                                 fontSize: 12,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .w500))
                              //                       ],
                              //                     ))
                              //               ]),
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          );
                        } else if ((practiceMCQController!
                                .selectedTopicsTab.value ==
                            '2')) {
                          return practiceMCQController!
                                  .practiceTopicBookmarkList.isNotEmpty
                              ? Column(
                                  children: [
                                    Expanded(
                                        child: ListView.separated(
                                      padding: const EdgeInsets.all(5),
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                      itemCount: practiceMCQController!
                                          .practiceTopicBookmarkList.length,
                                      controller: practiceMCQController!
                                          .practiceTopicBookmarkScrollController,
                                      itemBuilder: (context, index) {
                                        return itemWidgetSubjectBookmark(
                                            practiceMCQController!
                                                    .practiceTopicBookmarkList[
                                                index],
                                            index);
                                      },
                                    )),
                                    (practiceMCQController!.isLoading.value &&
                                            practiceMCQController!
                                                    .topicBookmarkPage !=
                                                1)
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
                        } else if ((practiceMCQController!
                                .selectedTopicsTab.value ==
                            '3')) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 150,
                                child: Stack(children: [
                                  Container(
                                    // margin: const EdgeInsets.only(right: 5),
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/images/leaderback.svg',
                                      // width: 15,
                                      color: kLightBlueColor,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                      color: Colors.grey,
                                                      offset: Offset(2.0, 2.0),
                                                      blurRadius: 10.0),
                                                ],
                                                color: Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    // SelectedPopUp(from);
                                                  },
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                              Alignment.center,
                                                          image: AssetImage(
                                                              'assets/images/user_placeholder.png'),
                                                        ),
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        width: 70,
                                                        image: (practiceMCQController!
                                                                    .top3TopicLeaderBoardList
                                                                    .length >=
                                                                2)
                                                            ? RemoteServices
                                                                    .imageMainLink +
                                                                practiceMCQController!
                                                                    .top3TopicLeaderBoardList[
                                                                        1]
                                                                    .image!
                                                            : '',
                                                      ))),
                                            ),
                                            Container(
                                              height: 25,
                                              width: 25,
                                              alignment: Alignment.center,
                                              decoration: boxDecorationStep(
                                                  Colors.grey,
                                                  Colors.grey,
                                                  Colors.grey),
                                              child: Text(
                                                '2',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Column(
                                              children: [
                                                Container(
                                                  // margin: const EdgeInsets.only(right: 5),
                                                  alignment: Alignment.center,
                                                  child: SvgPicture.asset(
                                                    'assets/images/yellowcrown.svg',
                                                    width: 15,
                                                    color: kPrimaryColor,
                                                  ),
                                                ),
                                                Container(
                                                  height: 100,
                                                  width: 100,
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  alignment: Alignment.center,
                                                  decoration:
                                                      const BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          spreadRadius: 0.0,
                                                          color: Colors.amber,
                                                          offset:
                                                              Offset(2.0, 2.0),
                                                          blurRadius: 10.0),
                                                    ],
                                                    color: Colors.amber,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        // SelectedPopUp(from);
                                                      },
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
                                                            image: (practiceMCQController!
                                                                    .top3TopicLeaderBoardList
                                                                    .isNotEmpty)
                                                                ? RemoteServices
                                                                        .imageMainLink +
                                                                    practiceMCQController!
                                                                        .top3TopicLeaderBoardList[
                                                                            0]
                                                                        .image!
                                                                : '',
                                                          ))),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 25,
                                              width: 25,
                                              alignment: Alignment.center,
                                              decoration: boxDecorationStep(
                                                  Colors.amber,
                                                  Colors.amber,
                                                  Colors.amber),
                                              child: Text(
                                                '1',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                                      color: Color.fromARGB(
                                                          255, 192, 125, 101),
                                                      offset: Offset(2.0, 2.0),
                                                      blurRadius: 10.0),
                                                ],
                                                color: Color.fromARGB(
                                                    255, 192, 125, 101),
                                                shape: BoxShape.circle,
                                              ),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    // SelectedPopUp(from);
                                                  },
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                              Alignment.center,
                                                          image: AssetImage(
                                                              'assets/images/user_placeholder.png'),
                                                        ),
                                                        fit: BoxFit.cover,
                                                        height: 70,
                                                        width: 70,
                                                        image: (practiceMCQController!
                                                                    .top3TopicLeaderBoardList
                                                                    .length >=
                                                                3)
                                                            ? RemoteServices
                                                                    .imageMainLink +
                                                                practiceMCQController!
                                                                    .top3TopicLeaderBoardList[
                                                                        2]
                                                                    .image!
                                                            : '',
                                                      ))),
                                            ),
                                            Container(
                                              height: 25,
                                              width: 25,
                                              alignment: Alignment.center,
                                              decoration: boxDecorationStep(
                                                  const Color.fromARGB(
                                                      255, 192, 125, 101),
                                                  const Color.fromARGB(
                                                      255, 192, 125, 101),
                                                  const Color.fromARGB(
                                                      255, 192, 125, 101)),
                                              child: Text(
                                                '3',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                            (practiceMCQController!
                                                        .top3TopicLeaderBoardList
                                                        .length >=
                                                    2)
                                                ? practiceMCQController!
                                                    .top3TopicLeaderBoardList[1]
                                                    .fullname!
                                                : 'N/A',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500)),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                          (practiceMCQController!
                                                  .top3TopicLeaderBoardList
                                                  .isNotEmpty)
                                              ? practiceMCQController!
                                                  .top3TopicLeaderBoardList[0]
                                                  .fullname!
                                              : 'N/A',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        child: Text(
                                            (practiceMCQController!
                                                        .top3TopicLeaderBoardList
                                                        .length >=
                                                    3)
                                                ? practiceMCQController!
                                                    .top3TopicLeaderBoardList[2]
                                                    .fullname!
                                                : 'N/A',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500)),
                                      )),
                                ],
                              ),
                              Expanded(
                                  child: practiceMCQController!
                                          .practiceTopicLeaderBoardList
                                          .isNotEmpty
                                      ? ListView.builder(
                                          padding: const EdgeInsets.all(5),
                                          // separatorBuilder: (context, index) => const Divider(),
                                          itemCount: practiceMCQController!
                                              .practiceTopicLeaderBoardList
                                              .length,
                                          controller: practiceMCQController!
                                              .practiceTopicLeaderBoardScrollController,
                                          itemBuilder: (context, index) {
                                            return itemWidgetLeaderBoard(
                                                practiceMCQController!
                                                        .practiceTopicLeaderBoardList[
                                                    index],
                                                index);
                                          },
                                        )
                                      : Container()),
                              (practiceMCQController!.isLoading.value &&
                                      practiceMCQController!.leaderPage != 1)
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

  Widget itemWidgetLeaderBoard(CurrentUser model, int index) {
    if (model.id.toString() == practiceMCQController!.userID) {
      return Card(
          elevation: 3,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  kPurpleColor,
                  Colors.greenAccent,
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 0.25))
              ],
              // color: color
            ),
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  alignment: Alignment.center,
                  child: Text(
                    (model.rankNo).toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  height: 35,
                  width: 35,
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(right: 5),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(75.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: "assets/images/user_placeholder.png",
                        imageErrorBuilder: (context, url, error) => const Image(
                          alignment: Alignment.center,
                          image:
                              AssetImage('assets/images/user_placeholder.png'),
                        ),
                        fit: BoxFit.cover,
                        image: RemoteServices.imageMainLink + model.image!,
                      )),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    'You',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    model.percentage!.toStringAsFixed(2) + '%',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ));
    } else {
      return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  alignment: Alignment.center,
                  child: Text(
                    (model.rankNo).toString(),
                    style: TextStyle(
                        color: kDarkBlueColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  height: 35.h,
                  width: 35.w,
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.only(right: 5),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                      onTap: () {
                        // SelectedPopUp(from);
                      },
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
                            image: RemoteServices.imageMainLink + model.image!,
                          ))),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    model.fullname!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: kPurpleColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    model.percentage!.toStringAsFixed(2) + '%',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ));
    }
  }

  Widget itemWidgetSubjectBookmark(PracticeMCQData model, int index) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        child: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 25,
                  alignment: Alignment.center,
                  width: 25,
                  decoration: boxDecorationStep(
                      kDarkBlueColor, kDarkBlueColor, kDarkBlueColor),
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 25,
                  width: 25,
                  child: SvgPicture.asset(
                    (model.isAnswerTrue == 1)
                        ? 'assets/images/greensmile.svg'
                        : (model.isAnswerTrue == 0 &&
                                model.userSelectedAnswerApp!.isNotEmpty)
                            ? 'assets/images/redsmile.svg'
                            : 'assets/images/greysmile.svg',
                    width: 25,
                    height: 25,
                    alignment: Alignment.topRight,
                  ),
                ),
              ]),
          const SizedBox(
            height: 5,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  alignment: Alignment.centerLeft,
                  child: TeXView(
                    loadingWidgetBuilder: ((context) {
                      return const Text("Loading...");
                    }),
                    child: TeXViewDocument(model.question.toString(),
                        style: TeXViewStyle(
                            contentColor: Colors.black,
                            fontStyle: TeXViewFontStyle(fontSize: 12),
                            textAlign: TeXViewTextAlign.left)),
                  ),
                )),
                GestureDetector(
                  onTap: () {
                    model.isOpen = !(model.isOpen!);

                    setState(() {});
                  },
                  child: Container(
                    height: 20,
                    width: 20,
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      model.isOpen!
                          ? 'assets/images/blueup.svg'
                          : 'assets/images/bluedown.svg',
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ]),
          ((model.type == 1 || model.type == 2) && model.isOpen!)
              ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: model.getOption!.length,
                  itemBuilder: (context, optionindex) {
                    return itemWidgetOptions(
                        model.getOption![optionindex], optionindex, model);
                  },
                )
              : Container(),
          (model.type == 3 &&
                  model.isOpen! &&
                  model.userSelectedAnswerApp!.isNotEmpty)
              ?
              // practiceMCQList[selectedIndex.value].userSelectedAnswerApp![0]
              Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    Text('Answer : ',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500)),
                    Text(
                      model.userSelectedAnswerApp![0],
                      style: (model.userSelectedAnswerApp!.isNotEmpty &&
                              (double.parse(model.userSelectedAnswerApp![0].toString()) >=
                                  double.parse(model.getOption![0].optionMin
                                      .toString())) &&
                              (double.parse(model.userSelectedAnswerApp![0].toString()) <=
                                  double.parse(model.getOption![0].optionMax
                                      .toString())))
                          ? const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.w500)
                          : (model.userSelectedAnswerApp!.isNotEmpty &&
                                  ((double.parse(model.userSelectedAnswerApp![0].toString()) <
                                          double.parse(model
                                              .getOption![0].optionMin
                                              .toString())) ||
                                      (double.parse(model.userSelectedAnswerApp![0].toString()) >
                                          double.parse(model
                                              .getOption![0].optionMax
                                              .toString()))))
                              ? const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500)
                              : const TextStyle(fontSize: 14),
                    )
                  ],
                )
              : Container(),
          (model.isOpen! && model.userSelectedAnswerApp!.isNotEmpty)
              ? Container(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Solution',
                        style: TextStyle(
                            color: kDarkBlueColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: TeXView(
                          loadingWidgetBuilder: ((context) {
                            return const Text("Loading...");
                          }),
                          renderingEngine: renderingEngine,
                          child: TeXViewDocument(model.solution.toString(),
                              style: TeXViewStyle(
                                  contentColor: Colors.black,
                                  fontStyle: TeXViewFontStyle(fontSize: 12),
                                  textAlign: TeXViewTextAlign.left)),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
        ]));
  }

  Widget itemWidgetOptions(
      GetPracticeOption options, int index, PracticeMCQData data) {
    return Container(
        decoration: ((data.userSelectedAnswerApp!
                        .contains(options.id.toString()) &&
                    options.isTrue == 1) ||
                (data.userSelectedAnswerApp!.isNotEmpty && options.isTrue == 1))
            ? boxDecorationRectBorder(
                Colors.lightGreen[100]!, Colors.lightGreen[100]!, Colors.green)
            : ((data.userSelectedAnswerApp!.contains(options.id.toString()) &&
                    options.isTrue == 0))
                ? boxDecorationRectBorder(
                    const Color.fromARGB(255, 255, 181, 174),
                    const Color.fromARGB(255, 255, 181, 174),
                    Colors.red)
                : boxDecorationRectBorder(
                    Colors.transparent, Colors.transparent, kSecondaryColor),
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
                    practiceMCQController!.convertToABCD(index),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
          (data.userTempAnswer!.contains(options.id.toString())) &&
                  data.type == 1
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
          (data.userTempAnswer!.contains(options.id.toString())) &&
                  data.type == 2
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
          (data.userSelectedAnswerApp!.contains(options.id.toString()) &&
                      options.isTrue == 1) ||
                  (data.userSelectedAnswerApp!.isNotEmpty &&
                      options.isTrue == 1)
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
          (data.userSelectedAnswerApp!.contains(options.id.toString()) &&
                  options.isTrue == 0)
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: SvgPicture.asset(
                    'assets/images/wrong.svg',
                    width: 25,
                    color: Colors.red,
                  ),
                )
              : Container(),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.centerLeft,
            child: TeXView(
              loadingWidgetBuilder: ((context) {
                return const Text("Loading...");
              }),
              child: TeXViewDocument(options.option.toString(),
                  style: TeXViewStyle(
                      contentColor: Colors.black,
                      fontStyle: TeXViewFontStyle(fontSize: 12),
                      textAlign: TeXViewTextAlign.left)),
            ),
          ))
        ]));
  }
}
