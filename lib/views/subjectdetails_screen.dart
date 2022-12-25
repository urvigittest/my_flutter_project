import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/controllers/listing_controller.dart';

import 'package:flutter_practicekiya/models/subjectdetails_model.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../controllers/payment_controller.dart';

import '../utils/theme.dart';

class SubjectDetailsScreen extends StatefulWidget {
  const SubjectDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  ListingController? listingController;
  PaymentController? paymentController;
  String? examId, examName, screen, subjectId, subjectName;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TeXViewRenderingEngine renderingEngine =
      const TeXViewRenderingEngine.katex();

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListingController>();

    paymentController = Get.find<PaymentController>();

    examId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
    examName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_exam")['examName'];
    screen = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['screen'];
    if (kDebugMode) {
      print(screen);
    }
    subjectId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectId'];
    subjectName = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectName'];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (screen == 'Home') {
        listingController!.getSubscriptionDetails(
          subjectId!,
        );
      } else {
        listingController!.getSubjectDetails(
            subjectId!,
            listingController!.selectedTypeId.value == '1'
                ? 'practice'
                : listingController!.selectedTypeId.value == '2'
                    ? 'test'
                    : 'pyq');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                        paymentController!.appBar(false, 'Subject Details',
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
                    Expanded(
                      flex: 1,
                      child: Obx(
                        () {
                          return Visibility(
                            replacement: const Center(
                              child: Text("Loading..."),
                            ),
                            visible: !listingController!.isLoading.value,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              child: ListView(
                                padding: const EdgeInsets.all(5),
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(5),
                                        height: 35.h,
                                        width: 35.w,
                                        child: SvgPicture.asset(
                                          'assets/images/gateimg.svg',
                                          width: 35.w,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              subjectName!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color: kPrimaryColorDark,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                onSharePage(context, examName!,
                                                    subjectName!);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(5),
                                                height: 25.h,
                                                width: 25.w,
                                                child: SvgPicture.asset(
                                                  'assets/images/orangeshare.svg',
                                                  width: 25.w,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5, top: 10, bottom: 5),
                                    child: Text(
                                      'What will you get in this course?',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5, top: 10, bottom: 5),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  height: 30.h,
                                                  width: 30.w,
                                                  child: SvgPicture.asset(
                                                    'assets/images/chapters.svg',
                                                    width: 30.w,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Chapters',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      (listingController!
                                                                  .subjectDetailsModel!
                                                                  .subject!
                                                                  .totalChapter !=
                                                              null)
                                                          ? listingController!
                                                              .subjectDetailsModel!
                                                              .subject!
                                                              .totalChapter
                                                              .toString()
                                                          : "0",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: kPurpleColor,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  height: 30.h,
                                                  width: 30.w,
                                                  child: SvgPicture.asset(
                                                    'assets/images/topics.svg',
                                                    width: 30.w,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Topics',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      listingController!
                                                          .subjectDetailsModel!
                                                          .subject!
                                                          .totalTopic
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: kYellowColor,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin:
                                                      const EdgeInsets.all(5),
                                                  height: 30.h,
                                                  width: 30.w,
                                                  child: SvgPicture.asset(
                                                    'assets/images/questions.svg',
                                                    width: 30.w,
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Questions',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                      listingController!
                                                          .subjectDetailsModel!
                                                          .subject!
                                                          .totalPracticeQuestion
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  TeXView(
                                    loadingWidgetBuilder: ((context) {
                                      return const Text("Loading...");
                                    }),
                                    renderingEngine: renderingEngine,
                                    child: TeXViewColumn(children: [
                                      TeXViewDocument(
                                          listingController!
                                              .subjectDetailsModel!
                                              .subject!
                                              .details
                                              .toString(),
                                          style: const TeXViewStyle(
                                              textAlign:
                                                  TeXViewTextAlign.left)),
                                    ]),
                                    style: TeXViewStyle(
                                      margin: const TeXViewMargin.all(5),
                                      fontStyle: TeXViewFontStyle(fontSize: 12),
                                      padding: const TeXViewPadding.all(10),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  screen == 'Home'
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const MySeparator(
                                              color: kSecondaryColor,
                                              height: 1,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text(
                                                'Get Subscription',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            GridView.builder(
                                              shrinkWrap: true,
                                              itemCount: listingController!
                                                  .subjectSubscriptionList
                                                  .length,
                                              scrollDirection: Axis.vertical,
                                              padding: const EdgeInsets.all(0),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 1,
                                                      mainAxisSpacing: 5,
                                                      crossAxisSpacing: 5,
                                                      childAspectRatio: 5.3),
                                              itemBuilder: (context, index) {
                                                return itemWidgetSubjectSubscription(
                                                    listingController!
                                                            .subjectSubscriptionList[
                                                        index],
                                                    index);
                                              },
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        Get.back(result: 'success');
        return true;
      },
    );
  }

  Widget itemWidgetSubjectSubscription(SubjectSubscription model, int index) {
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
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: boxDecorationStep(kPrimaryColorDarkLight,
                    kPrimaryColorDark, kPrimaryColorDark),
                child: Text(
                  model.duration.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Month',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '₹' + model.dummyPrice.toString() + '/-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style:
                      (model.dummyPrice!.toDouble() != model.price!.toDouble())
                          ? TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough)
                          : TextStyle(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),
                ),
              ),
              Expanded(
                flex: 1,
                child: (model.dummyPrice!.toDouble() != model.price!.toDouble())
                    ? Text(
                        '₹' + model.price.toString() + '/-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: kPrimaryColor,
                        ),
                      )
                    : Container(),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () {
                    paymentController!.addToCart(
                        listingController!.subjectDetailsModel!.subject!.id
                            .toString(),
                        listingController!.selectedTypeId.value,
                        'S',
                        model.duration.toString(),
                        model.price.toString());
                  },
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 2, left: 2),
                    decoration: model.is_active == 0
                        ? boxDecorationValidTill(
                            kPrimaryColorDark, kPrimaryColorDark, 20)
                        : boxDecorationValidTill(
                            kPrimaryColor, kPrimaryColor, 20),
                    child: Center(
                      child: Text(
                        model.is_active == 0 ? "Buy Subscription" : "Start Now",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              model.is_active == 0
                  ? Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          paymentController!.addToCart(
                              listingController!
                                  .subjectDetailsModel!.subject!.id
                                  .toString(),
                              listingController!.selectedTypeId.value,
                              'C',
                              model.duration.toString(),
                              model.price.toString());
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          height: 25,
                          width: 25,
                          child: SvgPicture.asset(
                            'assets/images/orangecart.svg',
                            width: 25.w,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 6.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
