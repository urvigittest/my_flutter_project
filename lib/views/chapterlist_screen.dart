import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/controllers/listing_controller.dart';
import 'package:flutter_practicekiya/models/chapter_model.dart';
import 'package:flutter_practicekiya/models/practicemcq_model.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

import '../controllers/payment_controller.dart';
import '../controllers/practicemcq_controller.dart';
import '../routes/app_routes.dart';

import '../utils/theme.dart';

class ChapterListScreen extends StatefulWidget {
  const ChapterListScreen({Key? key}) : super(key: key);

  @override
  State<ChapterListScreen> createState() => _ChapterListScreenState();
}

class _ChapterListScreenState extends State<ChapterListScreen> {
  ListingController? listingController;
  PracticeMCQController? practiceMCQController;
  PaymentController? paymentController;
  String? examId, examName, screen, subjectId, subjectName;

  ChartType? _chartType = ChartType.disc;

  int key = 0;

  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.mathjax();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListingController>();

    practiceMCQController = Get.find<PracticeMCQController>();
    paymentController = Get.find<PaymentController>();

    examId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
    examName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_exam")['examName'];
    // screen =
    //     GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['screen'];
    subjectId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectId'];
    subjectName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectName'];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listingController!.selectedSubjectTab.value = '1';
      if (listingController!.selectedTypeId.value == '1') {
        listingController!.getChapterList(true, subjectId!);
      } else if (listingController!.selectedTypeId.value == '3') {
        listingController!.getPYQChapterList(true, subjectId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'success');
        return true;
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
                      height: 120.h,
                      decoration: const BoxDecoration(
                        color: kPrimaryColorDark,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(children: [
                        paymentController!.appBar(false, 'Chapter List',
                            kPrimaryColorDark, context, scaffoldKey),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 25,
                                width: 25,
                                child: SvgPicture.asset(
                                  'assets/images/whitegate.svg',
                                  width: 25.w,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    examName!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Text(
                                    subjectName!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                                listingController!.changeSubjectType('1'.obs);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Chapters',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: listingController!
                                                        .selectedSubjectTab
                                                        .value ==
                                                    '1'
                                                ? Colors.black
                                                : kTextColor),
                                      ),
                                      listingController!
                                                  .selectedSubjectTab.value ==
                                              '1'
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              height: 3,
                                              width: 70,
                                              decoration:
                                                  boxDecorationValidTill(
                                                      kPrimaryColorLight,
                                                      kPrimaryColor,
                                                      20),
                                            )
                                          : Container()
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Obx(
                            () => GestureDetector(
                              onTap: () {
                                listingController!.changeSubjectType('2'.obs);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Analysis',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: (listingController!
                                                        .selectedSubjectTab
                                                        .value ==
                                                    '2')
                                                ? Colors.black
                                                : kTextColor),
                                      ),
                                      (listingController!
                                                  .selectedSubjectTab.value ==
                                              '2')
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.only(top: 5),
                                              height: 3,
                                              width: 70,
                                              decoration:
                                                  boxDecorationValidTill(
                                                      kPrimaryColorLight,
                                                      kPrimaryColor,
                                                      20),
                                            )
                                          : Container()
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            child: Obx(
                          () => GestureDetector(
                            onTap: () {
                              listingController!.changeSubjectType('3'.obs);
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
                                          color: listingController!
                                                      .selectedSubjectTab
                                                      .value ==
                                                  '3'
                                              ? Colors.black
                                              : kTextColor),
                                    ),
                                    listingController!
                                                .selectedSubjectTab.value ==
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
                    Expanded(
                      child: Obx(
                        () {
                          if ((listingController!.selectedSubjectTab.value ==
                              '1')) {
                            return chapterSection();
                          } else if ((listingController!
                                  .selectedSubjectTab.value ==
                              '2')) {
                            return analysisSection();
                          }
                          if ((listingController!.selectedSubjectTab.value ==
                              '3')) {
                            return savedSection();
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chapterSection() {
    return Visibility(
        replacement: Container(
          alignment: Alignment.center,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  style: TextStyle(fontSize: 16.sp, color: kTextColor),
                )
              ]),
        ),
        visible: listingController!.chapterList.isNotEmpty,
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: listingController!.chapterList.length,
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 1.05),
          itemBuilder: (context, index) {
            return itemWidgetChapter(listingController!.chapterList[index]);
          },
        ));
  }

  Widget analysisSection() {
    return Visibility(
      replacement: const Center(
        child: Text("Loading..."),
      ),
      visible: !listingController!.isLoading.value,
      child: ListView(
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
                    dataMap: listingController!.dataMapChapterwise,

                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 15,

                    chartRadius: MediaQuery.of(context).size.width / 6.5,
                    colorList: listingController!.colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,

                    // gradientList: gradientList,
                    ringStrokeWidth: 18,

                    legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: false,
                        // legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                        legendShape: BoxShape.rectangle),
                    chartValuesOptions: const ChartValuesOptions(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Chapter Breakdown',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                              width: 15,
                              // margin: const EdgeInsets.only(right: 5),

                              child: Icon(
                                Icons.circle,
                                size: 10,
                                color: kChartGreenColor,
                              ),
                            ),
                            Text(
                              'Completed',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Ongoing',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              overflow: TextOverflow.ellipsis,
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
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .chapterBreakdown!.totalTopic
                                  .toString(),
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Chapters',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .chapterBreakdown!.totalCompletedTopic
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .chapterBreakdown!.totalOngoingTopic
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .chapterBreakdown!.totalUnseenTopic
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
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
                  ),
                ),
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
                    dataMap: listingController!.dataMapQueBreakdown,

                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 15,

                    chartRadius: MediaQuery.of(context).size.width / 6.5,
                    colorList: listingController!.colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,

                    // gradientList: gradientList,
                    ringStrokeWidth: 18,

                    legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: false,
                        // legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                        legendShape: BoxShape.rectangle),
                    chartValuesOptions: const ChartValuesOptions(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Questions Breakdown',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                              width: 15,
                              // margin: const EdgeInsets.only(right: 5),

                              child: Icon(
                                Icons.circle,
                                size: 10,
                                color: kChartGreenColor,
                              ),
                            ),
                            Text(
                              'Correct',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              overflow: TextOverflow.ellipsis,
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
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .questionBreakdown!.totalQuestion
                                  .toString(),
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Questions',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .questionBreakdown!.totalCorrect
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .questionBreakdown!.totalIncorrect
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              listingController!.subjectAnalysisModel!
                                  .questionBreakdown!.totalSkip
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
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
                  ),
                ),
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
                    dataMap: listingController!.dataMapTimereakdown,

                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 15,

                    chartRadius: MediaQuery.of(context).size.width / 6.5,
                    colorList: listingController!.colorList,
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,

                    // gradientList: gradientList,
                    ringStrokeWidth: 18,

                    legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: false,
                        // legendShape: _BoxShape.circle,
                        legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                        legendShape: BoxShape.rectangle),
                    chartValuesOptions: const ChartValuesOptions(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              'Time Breakdown',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                              width: 15,
                              // margin: const EdgeInsets.only(right: 5),

                              child: Icon(
                                Icons.circle,
                                size: 10,
                                color: kChartGreenColor,
                              ),
                            ),
                            Text(
                              'Correct',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              overflow: TextOverflow.ellipsis,
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
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              practiceMCQController!
                                      .convertToHour(listingController!
                                              .subjectAnalysisModel!
                                              .questionBreakdown!
                                              .totalCorrectTime! +
                                          listingController!
                                              .subjectAnalysisModel!
                                              .questionBreakdown!
                                              .totalIncorrectTime! +
                                          listingController!
                                              .subjectAnalysisModel!
                                              .questionBreakdown!
                                              .totalSkipTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToMinutes(listingController!
                                              .subjectAnalysisModel!
                                              .questionBreakdown!
                                              .totalCorrectTime! +
                                          listingController!
                                              .subjectAnalysisModel!
                                              .questionBreakdown!
                                              .totalIncorrectTime! +
                                          listingController!
                                              .subjectAnalysisModel!
                                              .questionBreakdown!
                                              .totalSkipTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToSeconds(
                                          listingController!.subjectAnalysisModel!.questionBreakdown!.totalCorrectTime! + listingController!.subjectAnalysisModel!.questionBreakdown!.totalIncorrectTime! + listingController!.subjectAnalysisModel!.questionBreakdown!.totalSkipTime!)
                                      .value
                                      .toString(),
                              // listingController!
                              //     .subjectAnalysisModel!
                              //     .questionBreakdown!
                              //     .totalQuestion
                              //     .toString(),
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Time Spent',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              practiceMCQController!
                                      .convertToHour(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalCorrectTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToMinutes(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalCorrectTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToSeconds(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalCorrectTime!)
                                      .value
                                      .toString(),

                              // listingController!
                              //     .subjectAnalysisModel!
                              //     .questionBreakdown!
                              //     .totalCorrectTime
                              //     .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              practiceMCQController!
                                      .convertToHour(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalIncorrectTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToMinutes(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalIncorrectTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToSeconds(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalIncorrectTime!)
                                      .value
                                      .toString(),
                              // listingController!
                              //     .subjectAnalysisModel!
                              //     .questionBreakdown!
                              //     .totalIncorrectTime
                              //     .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              practiceMCQController!
                                      .convertToHour(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalSkipTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToMinutes(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalSkipTime!)
                                      .value
                                      .toString() +
                                  ':' +
                                  practiceMCQController!
                                      .convertToSeconds(listingController!
                                          .subjectAnalysisModel!
                                          .questionBreakdown!
                                          .totalSkipTime!)
                                      .value
                                      .toString(),
                              // listingController!
                              //     .subjectAnalysisModel!
                              //     .questionBreakdown!
                              //     .totalSkipTime
                              //     .toString(),
                              overflow: TextOverflow.ellipsis,
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
                  ),
                ),
              ]),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 30,
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Progress',
                            style: TextStyle(
                                color: kPrimaryColorDark,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: LinearPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            linearGradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                stops: [
                                  0.1,
                                  0.9
                                ],
                                colors: [
                                  kChartOrangeColor,
                                  kChartGreenColor,
                                ]),
                            padding: const EdgeInsets.all(0),
                            lineHeight: 12.0,
                            percent: (listingController!.subjectAnalysisModel!
                                            .questionBreakdown!.progress! /
                                        100) >
                                    1
                                ? 1
                                : (listingController!.subjectAnalysisModel!
                                        .questionBreakdown!.progress! /
                                    100),
                            center: Text(
                              (listingController!.subjectAnalysisModel!
                                      .questionBreakdown!.progress!
                                      .toStringAsFixed(2)) +
                                  '%',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.white),
                            ),

                            barRadius: const Radius.circular(15),
                            backgroundColor: kSecondaryColor,
                            // progressColor: kDarkBlueColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            'Accuracy',
                            style: TextStyle(
                                color: kPrimaryColorDark,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: LinearPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            linearGradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                stops: [
                                  0.1,
                                  0.9
                                ],
                                colors: [
                                  kChartOrangeColor,
                                  kChartGreenColor,
                                ]),
                            padding: const EdgeInsets.all(0),
                            lineHeight: 12.0,
                            percent: (listingController!.subjectAnalysisModel!
                                            .questionBreakdown!.accuracy! /
                                        100) >
                                    1
                                ? 1
                                : (listingController!.subjectAnalysisModel!
                                        .questionBreakdown!.accuracy! /
                                    100),
                            center: Text(
                              (listingController!.subjectAnalysisModel!
                                      .questionBreakdown!.accuracy!
                                      .toStringAsFixed(2)) +
                                  '%',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.white),
                            ),

                            barRadius: const Radius.circular(15),
                            backgroundColor: kSecondaryColor,
                            // progressColor: kDarkBlueColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.all(5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Speed',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  listingController!.subjectAnalysisModel!
                                          .questionBreakdown!.perhourQuestion!
                                          .toString() +
                                      ' Q/Hr',
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          )
                        ]),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget savedSection() {
    return Visibility(
      replacement: Container(
        alignment: Alignment.center,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: TextStyle(fontSize: 16.sp, color: kTextColor),
              )
            ]),
      ),
      visible: listingController!.practiceSubjectBookmarkList.isNotEmpty,
      child: Column(
        children: [
          Expanded(
              child: ListView.separated(
            padding: const EdgeInsets.all(5),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: listingController!.practiceSubjectBookmarkList.length,
            controller:
                listingController!.practiceSubjectBookmarkScrollController,
            itemBuilder: (context, index) {
              return itemWidgetSubjectBookmark(
                  listingController!.practiceSubjectBookmarkList[index], index);
            },
          )),
          (listingController!.isLoading.value &&
                  listingController!.subjectBookmarkPage != 1)
              ? Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }

  // List<PieChartSectionData> showingSections() {
  //   return List.generate(4, (i) {
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 12.0 : 12.0;
  //     final radius = isTouched ? 60.0 : 50.0;
  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: const Color(0xff0293ee),
  //           value: 40,
  //           title: '40%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: const Color(0xfff8b250),
  //           value: 30,
  //           title: '30%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 2:
  //         return PieChartSectionData(
  //           color: const Color(0xff845bef),
  //           value: 15,
  //           title: '15%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       case 3:
  //         return PieChartSectionData(
  //           color: const Color(0xff13d38e),
  //           value: 15,
  //           title: '15%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //               fontSize: fontSize,
  //               fontWeight: FontWeight.bold,
  //               color: const Color(0xffffffff)),
  //         );
  //       default:
  //         throw Error();
  //     }
  //   });
  // }

  Widget itemWidgetChapter(ChapterData model) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Container(
              // margin: const EdgeInsets.only(right: 5),
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                'assets/images/subjectback.svg',
                // width: 15,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.label.toString().toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                  child: Text(
                                model.name.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                ),
                              ))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 5.0,
                                animation: true,
                                percent: (100 *
                                                model.totalCompletedTopic! /
                                                model.totalTopic!)
                                            .isInfinite ||
                                        (100 *
                                                model.totalCompletedTopic! /
                                                model.totalTopic!)
                                            .isNaN
                                    ? 0
                                    : ((100 *
                                                        model
                                                            .totalCompletedTopic! /
                                                        model.totalTopic!)
                                                    .round() /
                                                100 >
                                            1
                                        ? 1
                                        : (100 *
                                                    model.totalCompletedTopic! /
                                                    model.totalTopic!)
                                                .round() /
                                            100),
                                center: Text(
                                  (100 *
                                                  model.totalCompletedTopic! /
                                                  model.totalTopic!)
                                              .isInfinite ||
                                          (100 *
                                                  model.totalCompletedTopic! /
                                                  model.totalTopic!)
                                              .isNaN
                                      ? '0%'
                                      : (100 *
                                                  model.totalCompletedTopic! /
                                                  model.totalTopic!)
                                              .round()
                                              .toString() +
                                          '%',
                                  style: const TextStyle(fontSize: 10.0),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: kDarkBlueColor,
                                rotateLinearGradient: true,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: IntrinsicHeight(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Topic Analysis',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12.sp, color: kPrimaryColorDark),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Completed',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 10.sp, color: kDarkBlueColor),
                                  ),
                                  Text(
                                    'On Going',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 10.sp, color: kDarkBlueColor),
                                  ),
                                  Text(
                                    'Not Started',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 10.sp, color: kDarkBlueColor),
                                  ),
                                  Text(
                                    'Total',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 10.sp, color: kDarkBlueColor),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.totalCompletedTopic!.toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        color: kDarkBlueColor),
                                  ),
                                  Text(
                                    model.totalOngoingTopic!.toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        color: kDarkBlueColor),
                                  ),
                                  Text(
                                    (model.totalTopic! -
                                            (model.totalCompletedTopic! +
                                                model.totalOngoingTopic!))
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        color: kDarkBlueColor),
                                  ),
                                  Text(
                                    model.totalTopic!.toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 10.sp,
                                        color: kDarkBlueColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                  ),
                  GestureDetector(
                    onTap: () async {
                      getItRegister<Map<String, dynamic>>({
                        'chapterId': model.id.toString(),
                        'chapterName': model.name.toString().toUpperCase(),
                        'chapterLabel': model.label.toString().toUpperCase(),
                      }, name: "selected_chapter");
                      final data = await Get.toNamed(AppRoutes.topiclist);
                      if (data == 'success') {
                        if (listingController!.selectedTypeId.value == '1') {
                          listingController!.getChapterList(true, subjectId!);
                        } else if (listingController!.selectedTypeId.value ==
                            '3') {
                          listingController!
                              .getPYQChapterList(true, subjectId!);
                        }
                      }
                    },
                    child: Container(
                      height: 25,
                      margin: const EdgeInsets.only(
                          top: 2, bottom: 2, right: 2, left: 2),
                      decoration: boxDecorationValidTill(
                          kPrimaryColorLight, kPrimaryColor, 20),
                      child: Center(
                        child: Text(
                          "Start Now",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
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
                    listingController!.convertToABCD(index),
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
