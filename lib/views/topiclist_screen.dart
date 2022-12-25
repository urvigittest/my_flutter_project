import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/controllers/listing_controller.dart';

import 'package:flutter_practicekiya/models/topic_model.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:percent_indicator/percent_indicator.dart';

import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({Key? key}) : super(key: key);

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  ListingController? listingController;
  PaymentController? paymentController;
  String? examId,
      examName,
      subjectId,
      subjectName,
      chapterId,
      chapterName,
      chapterLabel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListingController>();
    paymentController = Get.find<PaymentController>();
    print('STARTED selected_exam');
    examId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
    examName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_exam")['examName'];

    print('STARTED selected_subject');

    subjectId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectId'];
    subjectName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectName'];

    print('STARTED selected_chapter');

    chapterId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_chapter")['chapterId'];
    chapterName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_chapter")['chapterName'];
    chapterLabel = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_chapter")['chapterLabel'];

    print('ENDED selected_chapter');

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (listingController!.selectedTypeId.value == '1') {
        listingController!.getTopicList(true, chapterId!);
      } else if (listingController!.selectedTypeId.value == '3') {
        listingController!.getPYQTopicList(true, chapterId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'success');
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
                        height: 120.h,
                        decoration: const BoxDecoration(
                          // border: Border.all(color: kPrimaryColorDark),
                          color: kPrimaryColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(children: [
                          paymentController!.appBar(false, 'Topic List',
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
                                      chapterLabel! + ' ' + chapterName!,
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
                      Obx(
                        () {
                          return Expanded(
                              child: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemCount: listingController!.topicList.length,
                            scrollDirection: Axis.vertical,
                            physics: AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 5.5),
                            itemBuilder: (context, index) {
                              if (listingController!.selectedTypeId.value ==
                                  '1') {
                                return itemWidgetTopic(
                                    listingController!.topicList[index]);
                              } else if (listingController!
                                      .selectedTypeId.value ==
                                  '3') {
                                return itemWidgetPYQTopic(
                                    listingController!.topicList[index]);
                              }
                              return Container();
                            },
                          ));
                        },
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget itemWidgetTopic(TopicData model) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            // Expanded(
            //   flex: 2,
            //   child: Container(
            //     height: 40.h,
            //     width: 40.w,
            //     margin: const EdgeInsets.all(2),
            //     alignment: Alignment.center,
            //     decoration: boxDecorationValidTill(
            //         kPrimaryColorDark, kPrimaryColorDark, 10),
            //     child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             listingController!
            //                 .separateString(chapterLabel!, '-', 0),
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               fontSize: 12.sp,
            //               color: Colors.white,
            //             ),
            //           ),
            //           Text(
            //             listingController!
            //                 .separateString(chapterLabel!, '-', 1),
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //                 fontSize: 14.sp,
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold),
            //           )
            //         ]),
            //   ),
            // ),
            Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.only(left: 2, right: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        model.totalGivenPracticeAnswer.toString() +
                            ' / ' +
                            model.totalPracticeQuestion.toString() +
                            ' Practice Qs',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: kSecondaryColor,
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      LinearPercentIndicator(
                        animation: true,
                        animationDuration: 1000,
                        padding: const EdgeInsets.all(0),
                        lineHeight: 12.h,
                        percent: (100 *
                                        model.totalGivenPracticeAnswer! /
                                        model.totalPracticeQuestion!)
                                    .isInfinite ||
                                (100 *
                                        model.totalGivenPracticeAnswer! /
                                        model.totalPracticeQuestion!)
                                    .isNaN
                            ? 0
                            : ((100 *
                                                model
                                                    .totalGivenPracticeAnswer! /
                                                model.totalPracticeQuestion!)
                                            .round() /
                                        100 >
                                    1
                                ? 1
                                : (100 *
                                            model.totalGivenPracticeAnswer! /
                                            model.totalPracticeQuestion!)
                                        .round() /
                                    100),
                        center: Text(
                          (100 *
                                          model.totalGivenPracticeAnswer! /
                                          model.totalPracticeQuestion!)
                                      .isInfinite ||
                                  (100 *
                                          model.totalGivenPracticeAnswer! /
                                          model.totalPracticeQuestion!)
                                      .isNaN
                              ? '0%'
                              : (100 *
                                          model.totalGivenPracticeAnswer! /
                                          model.totalPracticeQuestion!)
                                      .round()
                                      .toString() +
                                  '%',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.white),
                        ),
                        barRadius: const Radius.circular(15),
                        backgroundColor: kSecondaryColor,
                        progressColor: kDarkBlueColor,
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Correct : ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          model.totalCorrectPracticeAnswer.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 8.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Incorrect : ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          model.totalIncorrectPracticeAnswer.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 8.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                )),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            getItRegister<Map<String, dynamic>>({
                              'topicId': model.id.toString(),
                              'topicName': model.name.toString().toUpperCase(),
                            }, name: "selected_topic");
                            final data =
                                await Get.toNamed(AppRoutes.practicemcq);
                            if (data == 'success') {
                              if (listingController!.selectedTypeId.value ==
                                  '1') {
                                listingController!
                                    .getTopicList(true, chapterId!);
                              } else if (listingController!
                                      .selectedTypeId.value ==
                                  '3') {
                                listingController!
                                    .getPYQTopicList(true, chapterId!);
                              }
                            }
                            // Get.toNamed(AppRoutes.practicemcq);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            width: 35.w,
                            decoration: model.is_start == 0
                                ? boxDecorationValidTill(
                                    kDarkBlueColor, kPrimaryColorDark, 10)
                                : boxDecorationValidTill(
                                    Colors.lightGreen, Colors.green, 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: SvgPicture.asset(
                                      model.is_start == 0
                                          ? 'assets/images/playimg.svg'
                                          : 'assets/images/pause.svg',
                                      width: 15.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    model.is_start == 0 ? 'Start' : 'Resume',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // launchIn(RemoteServices.imageMainLink +
                            //     model.pdfDoc!);

                            getItRegister<Map<String, dynamic>>({
                              'pdfUrl':
                                  RemoteServices.imageMainLink + model.pdfDoc!,
                              'pfdTitle': model.name.toString().toUpperCase(),
                            }, name: "selected_pdf");
                            Get.toNamed(AppRoutes.pdfviewpage);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            width: 35.w,
                            decoration: boxDecorationValidTill(
                                kPrimaryColorLight, kPrimaryColor, 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: SvgPicture.asset(
                                      'assets/images/refreshimg.svg',
                                      width: 15.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Revise',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            getItRegister<Map<String, dynamic>>({
                              'topicId': model.id.toString(),
                              'topicName': model.name.toString().toUpperCase(),
                            }, name: "selected_topic");
                            Get.toNamed(AppRoutes.topicanalysis);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            width: 35.w,
                            decoration: boxDecorationValidTill(
                                kSecondaryColor, kTextColor, 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: SvgPicture.asset(
                                      'assets/images/analyimg.svg',
                                      width: 15.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Analysis',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemWidgetPYQTopic(TopicData model) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            // Expanded(
            //   flex: 2,
            //   child: Container(
            //     height: 40.h,
            //     width: 40.w,
            //     margin: const EdgeInsets.all(2),
            //     alignment: Alignment.center,
            //     decoration: boxDecorationValidTill(
            //         kPrimaryColorDark, kPrimaryColorDark, 10),
            //     child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             listingController!
            //                 .separateString(chapterLabel!, '-', 0),
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //               fontSize: 12.sp,
            //               color: Colors.white,
            //             ),
            //           ),
            //           Text(
            //             listingController!
            //                 .separateString(chapterLabel!, '-', 1),
            //             textAlign: TextAlign.center,
            //             style: TextStyle(
            //                 fontSize: 14.sp,
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold),
            //           )
            //         ]),
            //   ),
            // ),
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      model.totalGivenPyqAnswer.toString() +
                          ' / ' +
                          model.totalPyqQuestion.toString() +
                          ' Practice Qs',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: kSecondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      animationDuration: 1000,
                      padding: const EdgeInsets.all(0),
                      lineHeight: 12.h,
                      percent: (100 *
                                      model.totalGivenPyqAnswer! /
                                      model.totalPyqQuestion!)
                                  .isInfinite ||
                              (100 *
                                      model.totalGivenPyqAnswer! /
                                      model.totalPyqQuestion!)
                                  .isNaN
                          ? 0
                          : ((100 *
                                              model.totalGivenPyqAnswer! /
                                              model.totalPyqQuestion!)
                                          .round() /
                                      100 >
                                  1
                              ? 1
                              : (100 *
                                          model.totalGivenPyqAnswer! /
                                          model.totalPyqQuestion!)
                                      .round() /
                                  100),
                      center: Text(
                        (100 *
                                        model.totalGivenPyqAnswer! /
                                        model.totalPyqQuestion!)
                                    .isInfinite ||
                                (100 *
                                        model.totalGivenPyqAnswer! /
                                        model.totalPyqQuestion!)
                                    .isNaN
                            ? '0%'
                            : (100 *
                                        model.totalGivenPyqAnswer! /
                                        model.totalPyqQuestion!)
                                    .round()
                                    .toString() +
                                '%',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10.sp, color: Colors.white),
                      ),
                      barRadius: const Radius.circular(15),
                      backgroundColor: kSecondaryColor,
                      progressColor: kDarkBlueColor,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Correct : ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        model.totalCorrectPyqAnswer.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Incorrect : ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        model.totalIncorrectPyqAnswer.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            getItRegister<Map<String, dynamic>>({
                              'topicId': model.id.toString(),
                              'topicName': model.name.toString().toUpperCase(),
                            }, name: "selected_topic");
                            final data =
                                await Get.toNamed(AppRoutes.practicemcq);
                            if (data == 'success') {
                              if (listingController!.selectedTypeId.value ==
                                  '1') {
                                listingController!
                                    .getTopicList(true, chapterId!);
                              } else if (listingController!
                                      .selectedTypeId.value ==
                                  '3') {
                                listingController!
                                    .getPYQTopicList(true, chapterId!);
                              }
                            }
                            // Get.toNamed(AppRoutes.practicemcq);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            width: 35.w,
                            decoration: model.is_start == 0
                                ? boxDecorationValidTill(
                                    kDarkBlueColor, kPrimaryColorDark, 10)
                                : boxDecorationValidTill(
                                    Colors.lightGreen, Colors.green, 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: SvgPicture.asset(
                                      model.is_start == 0
                                          ? 'assets/images/playimg.svg'
                                          : 'assets/images/pause.svg',
                                      width: 15.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    model.is_start == 0 ? 'Start' : 'Resume',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // launchIn(RemoteServices.imageMainLink +
                            //     model.pdfDoc!);

                            getItRegister<Map<String, dynamic>>({
                              'pdfUrl':
                                  RemoteServices.imageMainLink + model.pdfDoc!,
                              'pfdTitle': model.name.toString().toUpperCase(),
                            }, name: "selected_pdf");
                            Get.toNamed(AppRoutes.pdfviewpage);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            width: 35.w,
                            decoration: boxDecorationValidTill(
                                kPrimaryColorLight, kPrimaryColor, 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: SvgPicture.asset(
                                      'assets/images/refreshimg.svg',
                                      width: 15.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Revise',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            getItRegister<Map<String, dynamic>>({
                              'topicId': model.id.toString(),
                              'topicName': model.name.toString().toUpperCase(),
                            }, name: "selected_topic");
                            Get.toNamed(AppRoutes.topicanalysis);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40.h,
                            width: 35.w,
                            decoration: boxDecorationValidTill(
                                kSecondaryColor, kTextColor, 10),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(5),
                                    child: SvgPicture.asset(
                                      'assets/images/analyimg.svg',
                                      width: 15.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Analysis',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                    ),
                                  )
                                ]),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
