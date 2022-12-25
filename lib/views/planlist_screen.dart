import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/dashboard_controller.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';

import 'package:flutter_practicekiya/controllers/listing_controller.dart';
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

class PlanListScreen extends StatefulWidget {
  const PlanListScreen({Key? key}) : super(key: key);

  @override
  State<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  ListingController? listingController;
  PaymentController? paymentController;
  HomeController? homeController;
  DashboardController? dashboardController;
  String? examId = '', examName = '', screen = '', comboId = '', comboName = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListingController>();
    paymentController = Get.find<PaymentController>();
    homeController = Get.find<HomeController>();
    dashboardController = Get.find<DashboardController>();

    // examId =
    //     GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['examId'];
    // examName = GetIt.I<Map<String, dynamic>>(
    //     instanceName: "selected_exam")['examName'];

    // if (GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam") != null) {
    //   print('not null');
    screen =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_exam")['screen'];
    // } else {
    //   print(' null');
    // }

    if (screen == 'Subject') {
      comboId = GetIt.I<Map<String, dynamic>>(
          instanceName: "selected_combo")['comboId'];
      comboName = GetIt.I<Map<String, dynamic>>(
          instanceName: "selected_combo")['comboName'];
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // setState(() {
      //   listingController!.selectedTypeId.value =
      //       homeController!.selectedTypeId.value;

      //   listingController!.getPlanList(
      //       true,
      //       listingController!.selectedTypeId.value == '1'
      //           ? 'practice'
      //           : listingController!.selectedTypeId.value == '2'
      //               ? 'test'
      //               : 'pyq');
      // });
      dashboardController!.refreshStreamController.stream.listen((list) {
        if (mounted) {
          hideLoader();

          if (list == 'PLAN') {
            setState(() {
              print('caleeedddddd');
              print(list);
              listingController!.selectedTypeId.value =
                  homeController!.selectedTypeId.value;

              listingController!.subjectList.clear();
              listingController!.comboSubjectList.clear();

              listingController!.getPlanList(
                  true,
                  listingController!.selectedTypeId.value == '1'
                      ? 'practice'
                      : listingController!.selectedTypeId.value == '2'
                          ? 'test'
                          : 'pyq');
            });
          } else if (list == 'PLANCARD') {
            setState(() {
              print('caleeedddddd');
              print(list);
              // listingController!.selectedTypeId.value =
              //     homeController!.selectedTypeId.value;

              listingController!.subjectList.clear();
              listingController!.comboSubjectList.clear();

              listingController!.getPlanList(
                  true,
                  listingController!.selectedTypeId.value == '1'
                      ? 'practice'
                      : listingController!.selectedTypeId.value == '2'
                          ? 'test'
                          : 'pyq');
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Get.back(result: 'success');
        dashboardController!.tabIndex.value = 0;
        dashboardController!.changeTabIndex(0);

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
                          paymentController!.appBar(false, 'Plan List',
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
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      screen == 'Home' ? examName! : comboName!,
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
                              Expanded(
                                flex: 2,
                                child: screen == 'Home'
                                    ? Container(
                                        decoration: const BoxDecoration(
                                          // border: Border.all(color: kPrimaryColorDark),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          ),
                                        ),
                                        height: 25,
                                        width: 100,
                                        child: Obx(
                                          () => Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: DropdownButtonFormField(
                                              value: listingController!
                                                  .selectedTypeId.value,
                                              onChanged: (dynamic newVal) {
                                                listingController!
                                                    .selectedTypeId
                                                    .value = newVal;
                                                listingController!.changeType(
                                                    listingController!
                                                        .selectedTypeId.value,
                                                    examId!,
                                                    'Plan');
                                              },
                                              selectedItemBuilder:
                                                  (BuildContext context) {
                                                return listingController!
                                                    .selectedTypeList
                                                    .map((value) {
                                                  return Text(
                                                    value.name!,
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color:
                                                            kPrimaryColorDark),
                                                  );
                                                }).toList();
                                              },
                                              alignment: Alignment.center,
                                              isExpanded: true,
                                              icon: const Icon(
                                                Icons.arrow_drop_down,
                                                size: 20,
                                                color: kPrimaryColorDark,
                                              ),
                                              items: listingController!
                                                  .selectedTypeList
                                                  .map((item) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                    item.name!,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: kTextColor),
                                                  ),
                                                  value: item.id.toString(),
                                                );
                                              }).toList(),
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    tranparentBorder(),
                                                border: tranparentBorder(),
                                                focusedBorder:
                                                    tranparentBorder(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              )
                            ],
                          )
                        ]),
                      ),
                      Expanded(
                        child: Obx(
                          () {
                            return Stack(
                              children: [
                                (listingController!.subjectList.isNotEmpty ||
                                        listingController!
                                            .subjectList2.isNotEmpty ||
                                        listingController!
                                            .comboSubjectList.isNotEmpty)
                                    ? ListView(
                                        // shrinkWrap: true,
                                        physics:
                                            const AlwaysScrollableScrollPhysics(),
                                        children: [
                                            (listingController!.subjectList
                                                        .isNotEmpty &&
                                                    screen == 'Home')
                                                ? GridView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        listingController!
                                                            .subjectList.length,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            mainAxisSpacing: 5,
                                                            crossAxisSpacing: 5,
                                                            childAspectRatio:
                                                                1.05),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return itemWidgetSubject(
                                                          listingController!
                                                                  .subjectList[
                                                              index],
                                                          false);
                                                    },
                                                  )
                                                : Container(),
                                            (listingController!.comboSubjectList
                                                        .isNotEmpty &&
                                                    screen == 'Home')
                                                ? Container(
                                                    height: 30,
                                                    // width: 100,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Combo Plans',
                                                      style: TextStyle(
                                                          color:
                                                              kPrimaryColorDark,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                : Container(),
                                            (listingController!.comboSubjectList
                                                        .isNotEmpty &&
                                                    screen == 'Home')
                                                ? GridView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        listingController!
                                                            .comboSubjectList
                                                            .length,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            mainAxisSpacing: 5,
                                                            crossAxisSpacing: 5,
                                                            childAspectRatio:
                                                                1.05),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return itemWidgetSubject(
                                                          listingController!
                                                                  .comboSubjectList[
                                                              index],
                                                          true);
                                                    },
                                                  )
                                                : Container(),
                                            (listingController!.subjectList2
                                                        .isNotEmpty &&
                                                    screen == 'Subject')
                                                ? GridView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        listingController!
                                                            .subjectList2
                                                            .length,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            mainAxisSpacing: 5,
                                                            crossAxisSpacing: 5,
                                                            childAspectRatio:
                                                                1.05),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return itemWidgetSubject(
                                                          listingController!
                                                                  .subjectList2[
                                                              index],
                                                          false);
                                                    },
                                                  )
                                                : Container(),
                                          ])
                                    : Container(
                                        alignment: Alignment.center,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 120,
                                                height: 120,
                                                child: Image(
                                                  image: AssetImage(
                                                    'assets/images/bluebag.png',
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Buy your favourites courses',
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: kTextColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                'Practice & give tests on any of your devices',
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: kTextColor),
                                              )
                                            ]),
                                      )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget itemWidgetSubject(GetSinglePlan model, bool isCombo) {
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
                    flex: 3,
                    child: InkWell(
                        onTap: () {
                          if (isCombo) {
                            getItRegister<Map<String, dynamic>>({
                              'comboId': model.id.toString(),
                              'comboName': model.name.toString().toUpperCase(),
                            }, name: "selected_combo");

                            getItRegister<Map<String, dynamic>>({
                              'examId': examId,
                              'examName': examName,
                              'screen': 'Subject',
                            }, name: "selected_exam");

                            Get.toNamed(AppRoutes.planlist,
                                preventDuplicates: false);
                          } else {
                            getItRegister<Map<String, dynamic>>({
                              'subjectId': screen == 'Home'
                                  ? model.id.toString()
                                  : model.subjectId.toString(),
                              'subjectName': screen == 'Home'
                                  ? model.name.toString().capitalize
                                  : model.subjectName.toString().capitalize,
                              'screen': screen,
                            }, name: "selected_subject");
                            Get.toNamed(AppRoutes.subjectdetail);
                          }
                        },
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/gateimg.svg',
                                      width: 20.w,
                                    ),
                                    Expanded(
                                        child: Text(
                                      screen == 'Home'
                                          ? model.name.toString().toUpperCase()
                                          : model.subjectName
                                              .toString()
                                              .toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: kPrimaryColorDark,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
                                    ))
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () async {
                                    if (isCombo) {
                                      getItRegister<Map<String, dynamic>>({
                                        'comboId': model.id.toString(),
                                        'comboName':
                                            model.name.toString().toUpperCase(),
                                      }, name: "selected_combo");

                                      getItRegister<Map<String, dynamic>>({
                                        'examId': examId,
                                        'examName': examName,
                                        'screen': 'Subject',
                                      }, name: "selected_exam");

                                      Get.toNamed(AppRoutes.planlist,
                                          preventDuplicates: false);
                                    } else {
                                      getItRegister<Map<String, dynamic>>({
                                        'subjectId': model.subjectId.toString(),
                                        'subjectName': model.subjectName
                                            .toString()
                                            .toUpperCase(),
                                        'screen': 'Subject',
                                      }, name: "selected_subject");

                                      final data = await Get.toNamed(
                                          (listingController!.selectedTypeId
                                                          .value ==
                                                      '1') ||
                                                  (listingController!
                                                          .selectedTypeId
                                                          .value ==
                                                      '3')
                                              ? AppRoutes.chapterlist
                                              : AppRoutes.testtopicsubject);
                                      // final data = await Get.toNamed(
                                      //     AppRoutes.chapterlist);
                                      if (data == 'success') {
                                        if (screen == 'Home') {
                                          listingController!.getPlanList(
                                              true,
                                              listingController!.selectedTypeId
                                                          .value ==
                                                      '1'
                                                  ? 'practice'
                                                  : listingController!
                                                              .selectedTypeId
                                                              .value ==
                                                          '2'
                                                      ? 'test'
                                                      : 'pyq');
                                        } else if (screen == 'Subject') {
                                          listingController!
                                              .getComboSubjectList(
                                                  true, comboId!);
                                        }
                                      }
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      model.is_active == 1
                                          ? Container(
                                              alignment: Alignment.center,
                                              height: 40.w,
                                              width: 40.w,
                                              decoration:
                                                  boxDecorationValidTill(
                                                      kDarkBlueColor,
                                                      kPrimaryColorDark,
                                                      10),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Valid till',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 7.sp,
                                                      ),
                                                    ),
                                                    Text(
                                                      model.expiry_date != ''
                                                          ? Jiffy(
                                                                  model
                                                                      .expiry_date,
                                                                  "yyyy-MM-dd")
                                                              .format("MM")
                                                          : 'NA',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      model.expiry_date != ''
                                                          ? Jiffy(
                                                                  model
                                                                      .expiry_date,
                                                                  "yyyy-MM-dd")
                                                              .format("MMM yy")
                                                          : 'NA',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 7.sp,
                                                      ),
                                                    )
                                                  ]),
                                            )
                                          : Container(
                                              alignment: Alignment.center,
                                              height: 40.w,
                                              width: 40.w,
                                              decoration:
                                                  boxDecorationValidTill(
                                                      kDarkBlueColor,
                                                      kPrimaryColorDark,
                                                      100),
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Start',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      'Demo',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ]),
                                            ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // https://medium.com/@piyushmaurya23/building-profile-image-stack-in-flutter-2156102f65dd
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/blueuser.svg',
                                      width: 12.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      model.totalRatingUser.toString() +
                                          ' Ratings',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 10.sp, color: kTextColor),
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0, right: 5, top: 2, bottom: 2),
                                    child: Row(
                                      children: [
                                        Text(
                                          model.totalRating.toString(),
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        RatingBar.builder(
                                          ignoreGestures: true,
                                          itemSize: 15,
                                          initialRating: double.parse(
                                              model.totalRating.toString()),
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/blueuser.svg',
                                      width: 12.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      model.total_enrolled.toString() +
                                          ' Enrolled',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 10.sp, color: kTextColor),
                                    )
                                  ],
                                ),
                                model.is_active == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (isCombo) {
                                                  getItRegister<
                                                      Map<String, dynamic>>({
                                                    'comboId':
                                                        model.id.toString(),
                                                    'comboName': model.name
                                                        .toString()
                                                        .toUpperCase(),
                                                  }, name: "selected_combo");

                                                  getItRegister<
                                                      Map<String, dynamic>>({
                                                    'examId': examId,
                                                    'examName': examName,
                                                    'screen': 'Subject',
                                                  }, name: "selected_exam");

                                                  Get.toNamed(
                                                      AppRoutes.planlist,
                                                      preventDuplicates: false);
                                                } else {
                                                  getItRegister<
                                                      Map<String, dynamic>>({
                                                    'subjectId': model.subjectId
                                                        .toString(),
                                                    'subjectName': model
                                                        .subjectName
                                                        .toString()
                                                        .toUpperCase(),
                                                    'screen': 'Subject',
                                                  }, name: "selected_subject");
                                                  final data = await Get.toNamed(
                                                      (listingController!
                                                                      .selectedTypeId
                                                                      .value ==
                                                                  '1') ||
                                                              (listingController!
                                                                      .selectedTypeId
                                                                      .value ==
                                                                  '3')
                                                          ? AppRoutes
                                                              .chapterlist
                                                          : AppRoutes
                                                              .testtopicsubject);
                                                  if (data == 'success') {
                                                    if (screen == 'Home') {
                                                      listingController!
                                                          .getPlanList(
                                                              true,
                                                              listingController!
                                                                          .selectedTypeId
                                                                          .value ==
                                                                      '1'
                                                                  ? 'practice'
                                                                  : listingController!
                                                                              .selectedTypeId
                                                                              .value ==
                                                                          '2'
                                                                      ? 'test'
                                                                      : 'pyq');
                                                    } else if (screen ==
                                                        'Subject') {
                                                      listingController!
                                                          .getComboSubjectList(
                                                              true, comboId!);
                                                    }
                                                  }
                                                }
                                              },
                                              child: Container(
                                                height: 25,
                                                margin: const EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 2,
                                                    right: 2,
                                                    left: 2),
                                                decoration:
                                                    boxDecorationValidTill(
                                                        kPrimaryColorLight,
                                                        kPrimaryColor,
                                                        20),
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
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                buyNowPopUp(model);
                                              },
                                              child: Container(
                                                height: 25,
                                                margin: const EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 2,
                                                    right: 2,
                                                    left: 2),
                                                decoration:
                                                    boxDecorationValidTill(
                                                        kPrimaryColorDarkLight,
                                                        kPrimaryColorDark,
                                                        20),
                                                child: Center(
                                                  child: Text(
                                                    "Extend",
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
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          screen == 'Home'
                                              ? Expanded(
                                                  child: GestureDetector(
                                                  onTap: () {
                                                    buyNowPopUp(model);
                                                  },
                                                  child: Container(
                                                    height: 25,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 2,
                                                            bottom: 2,
                                                            right: 2,
                                                            left: 2),
                                                    decoration:
                                                        boxDecorationValidTill(
                                                            kPurpleColor,
                                                            kPurpleColor,
                                                            20),
                                                    child: Center(
                                                      child: Text(
                                                        "Renew",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                              : Container(),

                                          // screen == 'Home'
                                          //     ? GestureDetector(
                                          //         onTap: () {
                                          //           buyNowPopUp(model);
                                          //         },
                                          //         child: SizedBox(
                                          //           height: 25,
                                          //           child: SvgPicture.asset(
                                          //             'assets/images/orangecart.svg',
                                          //             width: 20.w,
                                          //           ),
                                          //         ),
                                          //       )
                                          //     : Container(),
                                          // screen == 'Home'
                                          //     ? GestureDetector(
                                          //         onTap: () {
                                          //           getItRegister<
                                          //               Map<String, dynamic>>({
                                          //             'subjectId': screen ==
                                          //                     'Home'
                                          //                 ? model.id.toString()
                                          //                 : model.subjectId
                                          //                     .toString(),
                                          //             'subjectName': screen ==
                                          //                     'Home'
                                          //                 ? model.name
                                          //                     .toString()
                                          //                     .capitalize
                                          //                 : model.subjectName
                                          //                     .toString()
                                          //                     .capitalize,
                                          //             'screen': screen,
                                          //           }, name: "selected_subject");
                                          //           Get.toNamed(AppRoutes
                                          //               .subjectdetail);
                                          //         },
                                          //         child: SizedBox(
                                          //           height: 25,
                                          //           child: SvgPicture.asset(
                                          //             'assets/images/greydots.svg',
                                          //             width: 20.w,
                                          //           ),
                                          //         ),
                                          //       )
                                          //     : Container(),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget itemWidgetSubjectSubscription(
      SubscriptionPlan model, GetSinglePlan singlePlan) {
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
                    //NEW ADDED
                    paymentController!.addToCart(
                        singlePlan.id.toString(),
                        listingController!.selectedTypeId.value,
                        'S',
                        model.duration.toString(),
                        model.price.toString());
                  },
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 2, left: 2),
                    decoration: boxDecorationValidTill(
                        kPrimaryColorDark, kPrimaryColorDark, 20),
                    child: Center(
                      child: Text(
                        "Buy Subscription",
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
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    paymentController!.addToCart(
                        singlePlan.id.toString(),
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
            ],
          ),
        ));
  }

  void buyNowPopUp(GetSinglePlan model) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(10),
            // contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),

            child: SizedBox(
              // height: ,
              width: double.infinity,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "Select Subscription",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor),
                    textAlign: TextAlign.left,
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: model.subscriptionPlan!.length,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.all(0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      childAspectRatio: 5.3),
                  itemBuilder: (context, index) {
                    return itemWidgetSubjectSubscription(
                        model.subscriptionPlan![index], model);
                  },
                )
              ]),
            ),
          );
        }));
  }
}
