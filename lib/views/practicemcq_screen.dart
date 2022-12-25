// ignore_for_file: unnecessary_string_escapes

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practicekiya/models/idstringname_model.dart';
import 'package:flutter_practicekiya/models/practicemcq_model.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_practicekiya/utils/staticarrays.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:gif_view/gif_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/listing_controller.dart';
import '../controllers/payment_controller.dart';
import '../controllers/practicemcq_controller.dart';

import '../routes/app_routes.dart';
import '../utils/theme.dart';

class PracticeMCQScreen extends StatefulWidget {
  const PracticeMCQScreen({Key? key}) : super(key: key);

  @override
  State<PracticeMCQScreen> createState() => _PracticeMCQScreenState();
}

class _PracticeMCQScreenState extends State<PracticeMCQScreen> {
  PracticeMCQController? practiceMCQController;
  PaymentController? paymentController;
  ListingController? listingController;
  String? examId,
      examName,
      subjectId,
      subjectName,
      chapterId,
      chapterName,
      chapterLabel,
      topicId,
      topicName;

  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.mathjax();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    practiceMCQController = Get.find<PracticeMCQController>();
    paymentController = Get.find<PaymentController>();
    listingController = Get.find<ListingController>();

    practiceMCQController!.selectedIndex.value = 0;

    practiceMCQController!.clearFilter();

    examId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      practiceMCQController!.startStopWatch();
      if (listingController!.selectedTypeId.value == '1') {
        practiceMCQController!.getPracticeMCQList(true, topicId!);
      } else if (listingController!.selectedTypeId.value == '3') {
        practiceMCQController!.getPYQMCQList(true, topicId!);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    practiceMCQController!.resetStopWatch();
    // practiceMCQController!.drawerController.close();
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
            practiceMCQController!.openDrawer();
          } else {
            //drawer is close
          }
        },
        endDrawer: Drawer(
          child: Obx(
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
                            Text(
                              'Practice Questions Filter',
                              style: TextStyle(
                                  color: kDarkBlueColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp),
                            ),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: SvgPicture.asset(
                                'assets/images/filter.svg',
                                width: 20,
                                color: kDarkBlueColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: practiceMCQController!
                            .drawerControllerPractice.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  shrinkWrap: true,
                                  children: [
                                    Obx(
                                      () {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          itemCount: practiceMCQController!
                                              .practiceMCQList.length,
                                          itemBuilder: (context, index) {
                                            return itemWidgetQuestionFilter(
                                                practiceMCQController!
                                                    .practiceMCQList[index],
                                                index);
                                          },
                                        );
                                      },
                                    )
                                  ]),
                            );
                          } else {
                            return Expanded(
                              child: ListView(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 5),
                                  shrinkWrap: true,
                                  children: [
                                    Obx(
                                      () {
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          itemCount: practiceMCQController!
                                              .practiceMCQList.length,
                                          itemBuilder: (context, index) {
                                            return itemWidgetQuestionFilter(
                                                practiceMCQController!
                                                    .practiceMCQList[index],
                                                index);
                                          },
                                        );
                                      },
                                    )
                                  ]),
                            );
                          }
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 100,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (practiceMCQController!
                                                  .correct.value) {
                                                practiceMCQController!
                                                    .correct.value = false;
                                              } else {
                                                practiceMCQController!
                                                    .correct.value = true;
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              margin: const EdgeInsets.all(5),
                                              height: 15,
                                              width: 15,
                                              child: SvgPicture.asset(
                                                practiceMCQController!
                                                        .correct.value
                                                    ? 'assets/images/squaretick.svg'
                                                    : 'assets/images/squareborder.svg',
                                                width: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 15,
                                            width: 15,
                                            child: const Icon(
                                              Icons.circle,
                                              size: 15,
                                              color: Colors.green,
                                            ),
                                          ),
                                          const Text(
                                            'Correct',
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 12),
                                          )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (practiceMCQController!
                                                  .saved.value) {
                                                practiceMCQController!
                                                    .saved.value = false;
                                              } else {
                                                practiceMCQController!
                                                    .saved.value = true;
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              margin: const EdgeInsets.all(5),
                                              height: 15,
                                              width: 15,
                                              child: SvgPicture.asset(
                                                practiceMCQController!
                                                        .saved.value
                                                    ? 'assets/images/squaretick.svg'
                                                    : 'assets/images/squareborder.svg',
                                                width: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 15,
                                            width: 15,
                                            child: const Icon(
                                              Icons.circle,
                                              size: 15,
                                              color: kDarkBlueColor,
                                            ),
                                          ),
                                          const Text(
                                            'Saved',
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 12),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (practiceMCQController!
                                                  .incorrect.value) {
                                                practiceMCQController!
                                                    .incorrect.value = false;
                                              } else {
                                                practiceMCQController!
                                                    .incorrect.value = true;
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              margin: const EdgeInsets.all(5),
                                              height: 15,
                                              width: 15,
                                              child: SvgPicture.asset(
                                                practiceMCQController!
                                                        .incorrect.value
                                                    ? 'assets/images/squaretick.svg'
                                                    : 'assets/images/squareborder.svg',
                                                width: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 15,
                                            width: 15,
                                            child: const Icon(
                                              Icons.circle,
                                              size: 15,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const Text(
                                            'InCorrect',
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 12),
                                          )
                                        ],
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (practiceMCQController!
                                                  .unattempted.value) {
                                                practiceMCQController!
                                                    .unattempted.value = false;
                                              } else {
                                                practiceMCQController!
                                                    .unattempted.value = true;
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              margin: const EdgeInsets.all(5),
                                              height: 15,
                                              width: 15,
                                              child: SvgPicture.asset(
                                                practiceMCQController!
                                                        .unattempted.value
                                                    ? 'assets/images/squaretick.svg'
                                                    : 'assets/images/squareborder.svg',
                                                width: 15,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.all(5),
                                            height: 15,
                                            width: 15,
                                            child: const Icon(
                                              Icons.circle,
                                              size: 15,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                          const Text(
                                            'Unattempted',
                                            style: TextStyle(
                                                color: kTextColor,
                                                fontSize: 12),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      practiceMCQController!.resetStopWatch();
                                      practiceMCQController!.applyFilter();

                                      Get.back();

                                      Future.delayed(const Duration(seconds: 1),
                                          () {
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      decoration: boxDecorationValidTill(
                                          kDarkBlueColor, kDarkBlueColor, 10),
                                      child: const Center(
                                        child: Text(
                                          "Apply Filter",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      practiceMCQController!.resetStopWatch();
                                      practiceMCQController!.clearFilter();
                                      Get.back();
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      decoration: boxDecorationRectBorder(
                                          Colors.white,
                                          Colors.white,
                                          kDarkBlueColor),
                                      child: const Center(
                                        child: Text(
                                          "Clear",
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
                            ]),
                      ),
                    ],
                  ));
            },
          ),
        ),
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
                          // border: Border.all(color: kPrimaryColorDark),
                          color: kPrimaryColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(children: [
                          paymentController!.appBar(
                              false,
                              listingController!.selectedTypeId.value == '1'
                                  ? 'Practice MCQ Test'
                                  : 'PYQs MCQ Test',
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
                      Expanded(
                        child: Obx(
                          () {
                            practiceMCQController!.setNumericAnswer();
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
                                      itemCount: practiceMCQController!
                                          .practiceMCQList.length,
                                      itemBuilder: (context, index) {
                                        return itemWidgetQuestionNumbers(
                                            practiceMCQController!
                                                .practiceMCQList[index],
                                            index);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Visibility(
                                      replacement: Container(),
                                      visible: practiceMCQController!
                                              .practiceMCQList[
                                                  practiceMCQController!
                                                      .selectedIndex.value]
                                              .isVisible! &&
                                          practiceMCQController!
                                              .practiceMCQList.isNotEmpty,
                                      // visible: (practiceMCQController!
                                      //     .showQuestion
                                      //     .value) //practiceMCQController!.practiceMCQList.isNotEmpty

                                      child: ListView(
                                          padding: const EdgeInsets.only(
                                              bottom: 5, top: 5),
                                          shrinkWrap: true,
                                          children: [
                                            Container(
                                                decoration: boxDecorationRect(
                                                    Colors.white, Colors.white),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            (practiceMCQController!
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
                                                                      (practiceMCQController!
                                                                              .practiceMCQList
                                                                              .isNotEmpty)
                                                                          ? practiceMCQController!
                                                                              .practiceMCQList[practiceMCQController!
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
                                                          const EdgeInsets.only(
                                                              left: 5,
                                                              right: 5,
                                                              bottom: 5),
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
                                                                (practiceMCQController!
                                                                            .selectedIndex
                                                                            .value +
                                                                        1)
                                                                    .toString() +
                                                                ' out of ' +
                                                                (practiceMCQController!
                                                                        .practiceMCQList
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
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    padding: EdgeInsets.only(
                                                                        left: 5,
                                                                        right:
                                                                            5),
                                                                    height: 20,
                                                                    decoration: boxDecorationRectBorder(
                                                                        Colors
                                                                            .white,
                                                                        Colors
                                                                            .white,
                                                                        kPrimaryColorDark),
                                                                    child: Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                            width:
                                                                                10,
                                                                            child:
                                                                                Image(
                                                                              color: kPrimaryColorDark,
                                                                              image: AssetImage(
                                                                                'assets/images/userimg.png',
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].totalsolved.toString(),
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(color: kPrimaryColorDark, fontSize: 10),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  practiceMCQController!
                                                                              .practiceMCQList
                                                                              .isNotEmpty &&
                                                                          practiceMCQController!
                                                                              .practiceMCQList[practiceMCQController!.selectedIndex.value]
                                                                              .userSelectedAnswerApp!
                                                                              .isEmpty
                                                                      ? Obx(
                                                                          () {
                                                                            return Text(
                                                                              practiceMCQController!.hoursStr.value + ':' + practiceMCQController!.minutesStr.value + ':' + practiceMCQController!.secondsStr.value,
                                                                              textAlign: TextAlign.center,
                                                                              style: const TextStyle(fontSize: 10.0, color: kPrimaryColorDark),
                                                                            );
                                                                          },
                                                                        )
                                                                      : Container(),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Row(
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              if (listingController!.selectedTypeId.value == '1') {
                                                                                practiceMCQController!.getPracticeBookmarked(
                                                                                  practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].id.toString(),
                                                                                  false,
                                                                                  0,
                                                                                );
                                                                              } else if (listingController!.selectedTypeId.value == '3') {
                                                                                practiceMCQController!.getPYQBookmarked(
                                                                                  practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].id.toString(),
                                                                                  false,
                                                                                  0,
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              margin: const EdgeInsets.all(5),
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: SvgPicture.asset(
                                                                                (practiceMCQController!.practiceMCQList.isNotEmpty && practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].isBookmark == 1) ? 'assets/images/bookmark_solid.svg' : 'assets/images/bookmark_border.svg',
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
                                                                                    practiceMCQController!.alertList = StaticArrays.getAlertList().obs;
                                                                                    practiceMCQController!.isOtherSelected.value = false;
                                                                                    practiceMCQController!.reportCommentController!.text = '';
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
                                                                                            key: practiceMCQController!.reportFormKey,
                                                                                            child: Column(
                                                                                              mainAxisSize: MainAxisSize.min,
                                                                                              children: <Widget>[
                                                                                                StreamBuilder(
                                                                                                  stream: practiceMCQController!.drawerControllerAlert.stream,
                                                                                                  builder: (context, snapshot) {
                                                                                                    if (snapshot.hasData) {
                                                                                                      return Column(
                                                                                                        children: [
                                                                                                          ListView.builder(
                                                                                                            shrinkWrap: true,
                                                                                                            physics: const AlwaysScrollableScrollPhysics(),
                                                                                                            itemCount: practiceMCQController!.alertList.length,
                                                                                                            itemBuilder: (context, index) {
                                                                                                              return itemWidgetAlert(practiceMCQController!.alertList[index], index);
                                                                                                            },
                                                                                                          ),
                                                                                                          practiceMCQController!.isOtherSelected.value
                                                                                                              ? Padding(
                                                                                                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                                                                                  child: SizedBox(
                                                                                                                    width: MediaQuery.of(context).size.width / 1.2,
                                                                                                                    // height: MediaQuery.of(context).size.height / 3.5,
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextFormField(
                                                                                                                        textAlign: TextAlign.start,
                                                                                                                        controller: practiceMCQController!.reportCommentController,
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
                                                                                                            itemCount: practiceMCQController!.alertList.length,
                                                                                                            itemBuilder: (context, index) {
                                                                                                              return itemWidgetAlert(practiceMCQController!.alertList[index], index);
                                                                                                            },
                                                                                                          ),
                                                                                                          practiceMCQController!.isOtherSelected.value
                                                                                                              ? Padding(
                                                                                                                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                                                                                                                  child: SizedBox(
                                                                                                                    width: MediaQuery.of(context).size.width / 1.2,
                                                                                                                    // height: MediaQuery.of(context).size.height / 3.5,
                                                                                                                    child: Padding(
                                                                                                                      padding: const EdgeInsets.all(10),
                                                                                                                      child: TextFormField(
                                                                                                                        textAlign: TextAlign.start,
                                                                                                                        controller: practiceMCQController!.reportCommentController,
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
                                                                                                for (int i = 0; i < practiceMCQController!.alertList.length; i++) {
                                                                                                  if (practiceMCQController!.alertList[i].isSelected!) {
                                                                                                    isOne = true;
                                                                                                    if (comments == '') {
                                                                                                      comments = practiceMCQController!.alertList[i].name!;
                                                                                                    } else {
                                                                                                      comments = comments! + ', ' + practiceMCQController!.alertList[i].name!;
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                                if (!isOne) {
                                                                                                  showFlutterToast('Select atleast on issue');
                                                                                                } else {
                                                                                                  practiceMCQController!.checkReport(listingController!.selectedTypeId.value, comments!);
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

                                                                  // const Text(
                                                                  //   'Marks:',
                                                                  //   style: TextStyle(
                                                                  //       fontSize:
                                                                  //           10,
                                                                  //       fontWeight:
                                                                  //           FontWeight
                                                                  //               .bold,
                                                                  //       color: Colors
                                                                  //           .black),
                                                                  // ),
                                                                  // const SizedBox(
                                                                  //   width: 2,
                                                                  // ),
                                                                  // Text(
                                                                  //   '+' +
                                                                  //       practiceMCQController!
                                                                  //           .practiceMCQList[practiceMCQController!.selectedIndex.value]
                                                                  //           .positiveMark
                                                                  //           .toString(),
                                                                  //   style: const TextStyle(
                                                                  //       fontSize:
                                                                  //           10,
                                                                  //       fontWeight:
                                                                  //           FontWeight
                                                                  //               .bold,
                                                                  //       color: Colors
                                                                  //           .green),
                                                                  // ),
                                                                  // const SizedBox(
                                                                  //   width: 5,
                                                                  // ),
                                                                  // Text(
                                                                  //   '-' +
                                                                  //       practiceMCQController!
                                                                  //           .practiceMCQList[practiceMCQController!.selectedIndex.value]
                                                                  //           .negetiveMark
                                                                  //           .toString(),
                                                                  //   style: const TextStyle(
                                                                  //       fontSize:
                                                                  //           10,
                                                                  //       fontWeight:
                                                                  //           FontWeight
                                                                  //               .bold,
                                                                  //       color: Colors
                                                                  //           .red),
                                                                  // ),
                                                                ]),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            (practiceMCQController!
                                                        .practiceMCQList
                                                        .isNotEmpty) &&
                                                    (practiceMCQController!
                                                                .practiceMCQList[
                                                                    practiceMCQController!
                                                                        .selectedIndex
                                                                        .value]
                                                                .type ==
                                                            1 ||
                                                        practiceMCQController!
                                                                .practiceMCQList[
                                                                    practiceMCQController!
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
                                                    itemCount: practiceMCQController!
                                                        .practiceMCQList[
                                                            practiceMCQController!
                                                                .selectedIndex
                                                                .value]
                                                        .getOption!
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return itemWidgetOptions(
                                                          practiceMCQController!
                                                                  .practiceMCQList[
                                                                      practiceMCQController!
                                                                          .selectedIndex
                                                                          .value]
                                                                  .getOption![
                                                              index],
                                                          index,
                                                          practiceMCQController!
                                                                  .practiceMCQList[
                                                              practiceMCQController!
                                                                  .selectedIndex
                                                                  .value]);
                                                    },
                                                  )
                                                : Container(),
                                            (practiceMCQController!
                                                        .practiceMCQList
                                                        .isNotEmpty &&
                                                    practiceMCQController!
                                                            .practiceMCQList[
                                                                practiceMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .type ==
                                                        3)
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: TextFormField(
                                                      readOnly: practiceMCQController!
                                                              .practiceMCQList[
                                                                  practiceMCQController!
                                                                      .selectedIndex
                                                                      .value]
                                                              .userSelectedAnswerApp!
                                                              .isNotEmpty
                                                          ? true
                                                          : false,
                                                      textAlign:
                                                          TextAlign.center,
                                                      controller:
                                                          practiceMCQController!
                                                              .numericAnswerController,
                                                      keyboardType:
                                                          const TextInputType
                                                                  .numberWithOptions(
                                                              decimal: true),
                                                      onChanged: (value) {
                                                        // practiceMCQController!
                                                        //     .practiceMCQList[
                                                        //         practiceMCQController!
                                                        //             .selectedIndex
                                                        //             .value]
                                                        //     .userTempAnswer!
                                                        //     .clear();

//CHANGED
                                                        // practiceMCQController!
                                                        //     .practiceMCQList[
                                                        //         practiceMCQController!
                                                        //             .selectedIndex
                                                        //             .value]
                                                        //     .userTempAnswer!
                                                        //     .add(value
                                                        //         .toString());

                                                        if (practiceMCQController!
                                                            .practiceMCQList[
                                                                practiceMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .userTempAnswer!
                                                            .isEmpty) {
                                                          practiceMCQController!
                                                              .practiceMCQList[
                                                                  practiceMCQController!
                                                                      .selectedIndex
                                                                      .value]
                                                              .userTempAnswer!
                                                              .add(value
                                                                  .toString());
                                                        } else {
                                                          practiceMCQController!
                                                                  .practiceMCQList[
                                                                      practiceMCQController!
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
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'^\d+\.?\d*')), //r'^\d+\.?\d*'
                                                      ],
                                                      // inputFormatters: [
                                                      //   WhitelistingTextInputFormatter(
                                                      //       RegExp(
                                                      //           r'[\d+\-\.]')),
                                                      //   NumberTextInputFormatter(
                                                      //       decimalRange: this
                                                      //           .decimalRange),
                                                      // ],
                                                      style: (practiceMCQController!
                                                                  .practiceMCQList[
                                                                      practiceMCQController!
                                                                          .selectedIndex
                                                                          .value]
                                                                  .userSelectedAnswerApp!
                                                                  .isNotEmpty &&
                                                              (double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) >=
                                                                  double.parse(
                                                                      practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getOption![0].optionMin
                                                                          .toString())) &&
                                                              (double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) <=
                                                                  double.parse(
                                                                      practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getOption![0].optionMax
                                                                          .toString())))
                                                          ? const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.green,
                                                              fontWeight: FontWeight.w500)
                                                          : (practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].userSelectedAnswerApp!.isNotEmpty && ((double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) < double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getOption![0].optionMin.toString())) || (double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].userSelectedAnswerApp![0].toString()) > double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getOption![0].optionMax.toString()))))
                                                              ? const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w500)
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
                                            practiceMCQController!
                                                        .practiceMCQList
                                                        .isNotEmpty &&
                                                    practiceMCQController!
                                                        .practiceMCQList[
                                                            practiceMCQController!
                                                                .selectedIndex
                                                                .value]
                                                        .userSelectedAnswerApp!
                                                        .isNotEmpty &&
                                                    practiceMCQController!
                                                            .practiceMCQList[
                                                                practiceMCQController!
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
                                                        practiceMCQController!
                                                                .practiceMCQList[
                                                                    practiceMCQController!
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
                                                        practiceMCQController!
                                                            .practiceMCQList[
                                                                practiceMCQController!
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
                                            practiceMCQController!
                                                        .practiceMCQList
                                                        .isNotEmpty &&
                                                    practiceMCQController!
                                                        .practiceMCQList[
                                                            practiceMCQController!
                                                                .selectedIndex
                                                                .value]
                                                        .userSelectedAnswerApp!
                                                        .isNotEmpty
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
                                                                          practiceMCQController!.convertToHour(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].takenTime!).value.toString() +
                                                                              ':' +
                                                                              practiceMCQController!.convertToMinutes(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].takenTime!).value.toString() +
                                                                              ':' +
                                                                              practiceMCQController!.convertToSeconds(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].takenTime!).value.toString(),
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
                                                                      listingController!.selectedTypeId.value ==
                                                                              '1'
                                                                          ? Center(
                                                                              child: Text(
                                                                                practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPracticeAnswer != null ? (practiceMCQController!.convertToHour(double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPracticeAnswer!.averageTime!).round()).value.toString() + ':' + practiceMCQController!.convertToMinutes(double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPracticeAnswer!.averageTime!).round()).value.toString() + ':' + practiceMCQController!.convertToSeconds(double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPracticeAnswer!.averageTime!).round()).value.toString()) : '00:00:00',
                                                                                textAlign: TextAlign.center,
                                                                                style: const TextStyle(fontSize: 10.0, color: kPrimaryColorDark, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            )
                                                                          : Center(
                                                                              child: Text(
                                                                                practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPyqAnswer != null ? (practiceMCQController!.convertToHour(double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPyqAnswer!.averageTime!).round()).value.toString() + ':' + practiceMCQController!.convertToMinutes(double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPyqAnswer!.averageTime!).round()).value.toString() + ':' + practiceMCQController!.convertToSeconds(double.parse(practiceMCQController!.practiceMCQList[practiceMCQController!.selectedIndex.value].getPyqAnswer!.averageTime!).round()).value.toString()) : '00:00:00',
                                                                                textAlign: TextAlign.center,
                                                                                style: const TextStyle(fontSize: 10.0, color: kPrimaryColorDark, fontWeight: FontWeight.w500),
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
                                              visible: practiceMCQController!
                                                          .practiceMCQList
                                                          .isNotEmpty &&
                                                      practiceMCQController!
                                                          .practiceMCQList[
                                                              practiceMCQController!
                                                                  .selectedIndex
                                                                  .value]
                                                          .userSelectedAnswerApp!
                                                          .isNotEmpty
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
                                                            (practiceMCQController!
                                                                    .practiceMCQList
                                                                    .isNotEmpty)
                                                                ? practiceMCQController!
                                                                    .practiceMCQList[
                                                                        practiceMCQController!
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                practiceMCQController!
                                                    .previousQuestion();
                                              },
                                              child: Container(
                                                height: 35.h,
                                                width: 90.w,
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 10),
                                                decoration:
                                                    boxDecorationValidTill(
                                                        Colors.green,
                                                        Colors.green[300]!,
                                                        10),
                                                child: Center(
                                                  child: Text(
                                                    "Previous",
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
                                                practiceMCQController!
                                                    .nextQuestion(
                                                        listingController!
                                                            .selectedTypeId
                                                            .value);
                                              },
                                              child: Container(
                                                height: 35.h,
                                                width: 90.w,
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                decoration:
                                                    boxDecorationValidTill(
                                                        kPrimaryColor,
                                                        kPrimaryColorLight,
                                                        10),
                                                child: Center(
                                                  child: Text(
                                                    "Next",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(child: Container()),
                                        Visibility(
                                          visible: (practiceMCQController!
                                                      .practiceMCQList
                                                      .isNotEmpty &&
                                                  practiceMCQController!
                                                      .practiceMCQList[
                                                          practiceMCQController!
                                                              .selectedIndex
                                                              .value]
                                                      .userSelectedAnswerApp!
                                                      .isEmpty &&
                                                  (practiceMCQController!
                                                              .practiceMCQList[
                                                                  practiceMCQController!
                                                                      .selectedIndex
                                                                      .value]
                                                              .type ==
                                                          2 ||
                                                      practiceMCQController!
                                                              .practiceMCQList[
                                                                  practiceMCQController!
                                                                      .selectedIndex
                                                                      .value]
                                                              .type ==
                                                          3))
                                              ? true
                                              : false,
                                          child: GestureDetector(
                                            onTap: () {
                                              practiceMCQController!
                                                  .submitAnswer(
                                                      listingController!
                                                          .selectedTypeId
                                                          .value);
                                              setState(() {});
                                            },
                                            child: Container(
                                              height: 35.h,
                                              width: 90.w,
                                              padding: const EdgeInsets.only(
                                                  left: 15, right: 15),
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              decoration:
                                                  boxDecorationValidTill(
                                                      kDarkBlueColor,
                                                      kBlueColor,
                                                      10),
                                              child: Center(
                                                child: Text(
                                                  "Submit",
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
                                          visible: (practiceMCQController!
                                                      .practiceMCQList
                                                      .isNotEmpty &&
                                                  practiceMCQController!
                                                      .practiceMCQList[
                                                          practiceMCQController!
                                                              .selectedIndex
                                                              .value]
                                                      .userSelectedAnswerApp!
                                                      .isNotEmpty)
                                              ? true
                                              : false,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (practiceMCQController!
                                                  .practiceMCQList[
                                                      practiceMCQController!
                                                          .selectedIndex.value]
                                                  .video
                                                  .toString()
                                                  .contains('youtube')) {
                                                String? youtubeID =
                                                    YoutubePlayer.convertUrlToId(
                                                        practiceMCQController!
                                                            .practiceMCQList[
                                                                practiceMCQController!
                                                                    .selectedIndex
                                                                    .value]
                                                            .video
                                                            .toString());
                                                getItRegister<
                                                    Map<String, dynamic>>({
                                                  'youtubeID': youtubeID,
                                                }, name: "selected_youtube");
                                                Get.toNamed(
                                                    AppRoutes.videosolution);
                                              } else {
                                                showFlutterToast(
                                                    'Solution link is not proper');
                                              }
                                            },
                                            child: Container(
                                              height: 45,
                                              width: 110,
                                              color: Colors.transparent,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              margin: const EdgeInsets.only(
                                                  right: 5),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.all(5),
                                                    height: 15,
                                                    width: 15,
                                                    child: SvgPicture.asset(
                                                      'assets/images/orangevideo.svg',
                                                      width: 15,
                                                    ),
                                                  ),
                                                  const Center(
                                                    child: Text(
                                                      "Video Solution",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
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
                  Obx(
                    () {
                      return Visibility(
                        maintainState: false,
                        maintainAnimation: false,
                        maintainInteractivity: false,
                        maintainSemantics: false,
                        maintainSize: false,
                        visible: (practiceMCQController!
                                .practiceMCQList.isNotEmpty &&
                            practiceMCQController!.showGif.value),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: kPrimaryColorDark.withOpacity(0.5),
                          ),
                          child: GifView.asset(
                            (practiceMCQController!
                                        .practiceMCQList.isNotEmpty &&
                                    practiceMCQController!
                                            .practiceMCQList[
                                                practiceMCQController!
                                                    .selectedIndex.value]
                                            .isAnswerTrue ==
                                        1)
                                ? 'assets/images/correctanswer.gif'
                                : 'assets/images/wronganswer.gif',
                            loop: false,
                            onFinish: () {
                              practiceMCQController!.showGif.value = false;
                            },
                          ),
                        ),
                      );
                    },
                  ),
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

  Widget itemWidgetOptions(
      GetPracticeOption options, int index, PracticeMCQData data) {
    return InkWell(
      onTap: () {
        practiceMCQController!.onSelectionOfOption(
            data,
            index,
            options,
            options.id.toString(),
            options.isUserSelected!,
            listingController!.selectedTypeId.value);
      },
      child: Container(
          decoration: ((data.userSelectedAnswerApp!
                          .contains(options.id.toString()) &&
                      options.isTrue == 1) ||
                  (data.userSelectedAnswerApp!.isNotEmpty &&
                      options.isTrue == 1))
              ? boxDecorationRectBorder(Colors.lightGreen[100]!,
                  Colors.lightGreen[100]!, Colors.green)
              : ((data.userSelectedAnswerApp!.contains(options.id.toString()) &&
                      options.isTrue == 0))
                  ? boxDecorationRectBorder(
                      const Color.fromARGB(255, 255, 181, 174),
                      const Color.fromARGB(255, 255, 181, 174),
                      Colors.red)
                  : boxDecorationRectBorder(
                      Colors.transparent, Colors.transparent, kBlueColor),
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
                  renderingEngine: renderingEngine,
                  child: TeXViewInkWell(
                    onTap: (value) {
                      practiceMCQController!.onSelectionOfOption(
                          data,
                          index,
                          options,
                          options.id.toString(),
                          options.isUserSelected!,
                          listingController!.selectedTypeId.value);
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

  Widget itemWidgetQuestionNumbers(PracticeMCQData model, int index) {
    if (practiceMCQController!.isCorrect.value ||
        practiceMCQController!.isSaved.value ||
        practiceMCQController!.isInCorrect.value ||
        practiceMCQController!.isUnattempted.value) {
      // practiceMCQController!.showQuestion.value = true;
      if (practiceMCQController!.isCorrect.value && model.isAnswerTrue == 1) {
        practiceMCQController!.practiceMCQList[index].isVisible = true;
        // practiceMCQController!.showQuestion.value = true;
        return itemWidgetQuestionNumbersLayout(model, index);
      } else if (practiceMCQController!.isSaved.value &&
          (model.isAnswerTrue == 0 &&
              model.userSelectedAnswerApp!.isEmpty &&
              model.isBookmark == 1)) {
        practiceMCQController!.practiceMCQList[index].isVisible = true;
        // practiceMCQController!.showQuestion.value = true;
        return itemWidgetQuestionNumbersLayout(model, index);
      } else if (practiceMCQController!.isInCorrect.value &&
          (model.isAnswerTrue == 0 &&
              model.userSelectedAnswerApp!.isNotEmpty)) {
        practiceMCQController!.practiceMCQList[index].isVisible = true;
        // practiceMCQController!.showQuestion.value = true;
        return itemWidgetQuestionNumbersLayout(model, index);
      } else if (practiceMCQController!.isUnattempted.value &&
          (model.isAnswerTrue == 0 &&
              model.userSelectedAnswerApp!.isEmpty &&
              model.isSkip == 0 &&
              model.isBookmark == 0)) {
        practiceMCQController!.practiceMCQList[index].isVisible = true;
        // practiceMCQController!.showQuestion.value = true;
        return itemWidgetQuestionNumbersLayout(model, index);
      }
      practiceMCQController!.practiceMCQList[index].isVisible = false;
      // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      // practiceMCQController!.showQuestion.value = false;
      // });

      return Container();
    } else {
      practiceMCQController!.practiceMCQList[index].isVisible = true;
      // practiceMCQController!.showQuestion.value = true;
      return itemWidgetQuestionNumbersLayout(model, index);
    }
  }

  Widget itemWidgetQuestionNumbersLayout(PracticeMCQData model, int index) {
    return InkWell(
      onTap: () {
        practiceMCQController!.resetStopWatch();
        practiceMCQController!.startStopWatch();
        practiceMCQController!.selectedIndex.value = index;
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 5, right: 5),
            decoration: index == practiceMCQController!.selectedIndex.value
                ? boxDecorationStep(Colors.white, Colors.white, Colors.black)
                : boxDecorationStep(Colors.white, Colors.white, Colors.white),
          ),
          Container(
            height: 25,
            alignment: Alignment.center,
            width: 25,
            margin: const EdgeInsets.only(left: 5, right: 5),
            decoration: (model.isAnswerTrue == 1)
                ? boxDecorationStep(Colors.lightGreen[100]!,
                    Colors.lightGreen[100]!, Colors.green)
                : (model.isAnswerTrue == 0 &&
                        model.userSelectedAnswerApp!.isNotEmpty)
                    ? boxDecorationStep(
                        const Color.fromARGB(255, 255, 181, 174),
                        const Color.fromARGB(255, 255, 181, 174),
                        Colors.red)
                    : (model.isSkip == 1)
                        ? boxDecorationStep(
                            kSecondaryColor, kSecondaryColor, kTextColor)
                        : boxDecorationStep(
                            Colors.white, Colors.white, kTextColor),
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.w500),
            ),
          ),
          (model.isBookmark == 1)
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
              : Container()
        ],
      ),
    );
  }

  Widget itemWidgetQuestionFilter(PracticeMCQData model, int index) {
    return Container(
        // boxDecorationRectBorder
        // decoration: (model.isAnswerTrue == 1)
        //     ? boxDecorationRectBorder(
        //         Colors.lightGreen[100]!, Colors.lightGreen[100]!, Colors.green)
        //     : (model.isAnswerTrue == 0 &&
        //             model.userSelectedAnswerApp!.isNotEmpty)
        //         ? boxDecorationRectBorder(
        //             const Color.fromARGB(255, 255, 181, 174),
        //             const Color.fromARGB(255, 255, 181, 174),
        //             Colors.red)
        //         : (model.isSkip == 1)
        //             ? boxDecorationRectBorder(
        //                 kSecondaryColor, kSecondaryColor, kTextColor)
        //             : boxDecorationRectBorder(
        //                 Colors.white, Colors.white, kTextColor),

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
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration:
                          index == practiceMCQController!.selectedIndex.value
                              ? boxDecorationStep(
                                  Colors.white, Colors.white, Colors.black)
                              : boxDecorationStep(
                                  Colors.white, Colors.white, Colors.white),
                    ),
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      width: 25,
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      decoration: (model.isAnswerTrue == 1)
                          ? boxDecorationStep(Colors.lightGreen[100]!,
                              Colors.lightGreen[100]!, Colors.green)
                          : (model.isAnswerTrue == 0 &&
                                  model.userSelectedAnswerApp!.isNotEmpty)
                              ? boxDecorationStep(
                                  const Color.fromARGB(255, 255, 181, 174),
                                  const Color.fromARGB(255, 255, 181, 174),
                                  Colors.red)
                              : (model.isSkip == 1)
                                  ? boxDecorationStep(kSecondaryColor,
                                      kSecondaryColor, kTextColor)
                                  : boxDecorationStep(
                                      Colors.white, Colors.white, kTextColor),
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
                          practiceMCQController!.resetStopWatch();
                          practiceMCQController!.startStopWatch();
                          practiceMCQController!.selectedIndex.value = index;
                        },
                        child: TeXViewDocument(model.question.toString(),
                            style: TeXViewStyle(
                                contentColor: Colors.black,
                                fontStyle: TeXViewFontStyle(fontSize: 12),
                                textAlign: TeXViewTextAlign.left)),
                        id: (index + 1).toString(),
                      )),
                )),
                Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      if (listingController!.selectedTypeId.value == '1') {
                        practiceMCQController!.getPracticeBookmarked(
                            model.id.toString(), true, index);
                      } else if (listingController!.selectedTypeId.value ==
                          '3') {
                        practiceMCQController!
                            .getPYQBookmarked(model.id.toString(), true, index);
                      }
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
                ),
              ]),
        ));
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
          practiceMCQController!.isOtherSelected.value = true;
        } else if (model.id == 1 && !model.isSelected!) {
          practiceMCQController!.isOtherSelected.value = false;
        }

        practiceMCQController!.drawerControllerAlert.sink.add('N/A');
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
