import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/controllers/listing_controller.dart';
import 'package:flutter_practicekiya/models/testsubject_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/payment_controller.dart';

import '../routes/app_routes.dart';
import '../utils/functions.dart';
import '../utils/theme.dart';

class TestSingleTopicScreen extends StatefulWidget {
  const TestSingleTopicScreen({Key? key}) : super(key: key);

  @override
  State<TestSingleTopicScreen> createState() => _TestSingleTopicScreenState();
}

class _TestSingleTopicScreenState extends State<TestSingleTopicScreen> {
  ListingController? listingController;
  PaymentController? paymentController;
  String? examId, examName, subjectId, subjectName, topicId, topicName;

  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.katex();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListingController>();
    paymentController = Get.find<PaymentController>();

    listingController!.addSingleTopicTestItems();

    examId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
    examName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_exam")['examName'];

    subjectId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectId'];
    subjectName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectName'];

    topicId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_topic")['topicId'];

    topicName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_topic")['topicName'];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      listingController!.getTestBySingleTopic(true, topicId!, 1);
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
                        // border: Border.all(color: kPrimaryColorDark),
                        color: kPrimaryColorDark,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(children: [
                        paymentController!.appBar(false, 'Topic Test List',
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
                                    topicName!,
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
                    Obx(
                      () {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(5),
                            itemCount:
                                listingController!.testSingleTopicList.length,
                            controller:
                                listingController!.subjectTestScrollController,
                            itemBuilder: (context, index) {
                              return itemWidgetTestSingleTopic(
                                  listingController!
                                      .testSingleTopicList[index]);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget itemWidgetTestSingleTopic(TestSubjectData model) {
    bool isStartTest = false;
    bool isResume = false;
    bool isTestCompleted = false;
    // bool isUpgrade = false;
    bool isFutureTest = false;
    bool isTestOver = false;

    if (model.testStatus == 3) {
      isTestCompleted = true;
    } else {
      if (model.testStatus == 2) {
        isResume = true;
      } else {
        if (listingController!.isTestLableSubject(model) == 1) {
          isFutureTest = true;
        } else if (listingController!.isTestLableSubject(model) ==
            3) //|| model.IsFree
        {
          isStartTest = true;
        } else {
          isTestOver = true;
        }
      }
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.topRight,
            child: SvgPicture.asset(
              'assets/images/subjectback.svg',
              height: 45,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  // margin:
                  //     const EdgeInsets.only(top: 2, bottom: 2, right: 2, left: 2),
                  child: Text(
                    model.testName!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: kPrimaryColorDark,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () async {
                    if (isStartTest) {
                      listingController!.getInstructions(
                          true, model.id.toString(), model.testName.toString());
                    } else if (isResume) {
                      // getItRegister<Map<String, dynamic>>({
                      //   'testId': model.id.toString(),
                      //   'testName': model.testName!.toUpperCase(),
                      //   'testFrom': 'Test',
                      //   'testIntro': '',
                      // }, name: "selected_test");
                      // Get.toNamed(AppRoutes.testmcq);

                      getItRegister<Map<String, dynamic>>({
                        'testId': model.id.toString(),
                        'testName': model.testName!.toUpperCase(),
                        'testFrom': 'Test',
                        'testIntro': '',
                      }, name: "selected_test");
                      final data = await Get.toNamed(AppRoutes.testmcq);
                      if (data == 'success') {
                        listingController!
                            .getTestBySingleTopic(true, topicId!, 1);
                      }
                    } else if (isTestCompleted) {
                      getItRegister<Map<String, dynamic>>({
                        'testId': model.id.toString(),
                        'testName': model.testName!.toUpperCase(),
                        'testFrom': 'Solution',
                        'testIntro': '',
                      }, name: "selected_test");
                      getItRegister<Map<String, dynamic>>({
                        'scoreFrom': 'LIST',
                      }, name: "selected_score");
                      Get.toNamed(AppRoutes.scorecard);
                    } else if (isFutureTest) {
                      showFlutterToast('Test will be lived on ' +
                          Jiffy(model.activationDateTime, "yyyy-MM-dd HH:mm:ss")
                              .format("dd-MM-yyyy hh:mm a"));
                    } else if (isTestOver) {
                      showFlutterToast('Test is over');
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    margin: const EdgeInsets.only(
                        top: 4, bottom: 4, right: 2, left: 2),
                    decoration: isStartTest
                        ? boxDecorationRevise(
                            kPrimaryColorLight, kPrimaryColor, 20)
                        : isResume
                            ? boxDecorationRevise(
                                Colors.lightGreen, Colors.green, 20)
                            : isTestCompleted
                                ? boxDecorationRevise(
                                    kPurpleColor, kPurpleColor, 20)
                                : isFutureTest
                                    ? boxDecorationRevise(
                                        kBlueColor, kPrimaryColorDark, 20)
                                    : isTestOver
                                        ? boxDecorationRevise(Colors.redAccent,
                                            Colors.redAccent, 20)
                                        : boxDecorationRevise(
                                            kPrimaryColorDarkLight,
                                            kPrimaryColorDark,
                                            20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isStartTest
                                ? 'Start Now'
                                : isResume
                                    ? 'Resume'
                                    : isTestCompleted
                                        ? 'Score Board'
                                        : isFutureTest
                                            ? 'Activation ' +
                                                Jiffy(model.activationDateTime,
                                                        "yyyy-MM-dd HH:mm:ss")
                                                    .format("dd-MM-yyyy")
                                            : isTestOver
                                                ? 'Test Over'
                                                : '',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/whitearrow.svg',
                          width: 10.w,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
