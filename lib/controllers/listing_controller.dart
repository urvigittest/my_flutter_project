import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/scorecard_model.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/models/chapter_model.dart';
import 'package:flutter_practicekiya/models/practicemcq_model.dart';
import 'package:flutter_practicekiya/models/subjectanalysis_model.dart';
import 'package:flutter_practicekiya/models/subjectdetails_model.dart';
import 'package:flutter_practicekiya/models/testsubject_model.dart';
import 'package:flutter_practicekiya/models/testtopic_model.dart';
import 'package:flutter_practicekiya/models/topic_model.dart';
import 'package:flutter_practicekiya/utils/functions.dart';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';

import '../models/idstringname_model.dart';

import '../models/subject_model.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';

import '../utils/preferences.dart';
import '../utils/theme.dart';

class ListingController extends GetxController {
  Prefs prefs = Prefs.prefs;

  var isLoading = true.obs;

  ScrollController controller = ScrollController();

  int page = 1;

  List<IdStringNameModel> selectedTypeList = getExamType().obs;

  RxString selectedTypeId = '1'.obs;

  RxList<GetSinglePlan> subjectList =
      List<GetSinglePlan>.empty(growable: true).obs;

  RxList<GetSinglePlan> comboSubjectList =
      List<GetSinglePlan>.empty(growable: true).obs;

  List<GetSinglePlan> subjectList2 =
      List<GetSinglePlan>.empty(growable: true).obs;

  List<ChapterData> chapterList = List<ChapterData>.empty(growable: true).obs;
  RxString selectedSubjectTab = '1'.obs;

  List<TopicData> topicList = List<TopicData>.empty(growable: true).obs;

  RxList<SubjectSubscription> subjectSubscriptionList =
      <SubjectSubscription>[].obs;

  SubjectDetailsModel? subjectDetailsModel;
  SubjectAnalysisModel? subjectAnalysisModel;

  String? subjectId, topicId;

  Map<String, double> dataMapChapterwise = <String, double>{
    "Flutter": 5,
  };

  Map<String, double> dataMapQueBreakdown = <String, double>{
    "Flutter": 5,
  };

  Map<String, double> dataMapTimereakdown = <String, double>{
    "Flutter": 5,
  };

  final colorList = <Color>[
    kChartGreenColor,
    kChartOrangeColor,
    kSecondaryColor,
  ];

  ScrollController practiceSubjectBookmarkScrollController = ScrollController();
  int subjectBookmarkPage = 1;

  RxList<PracticeMCQData> practiceSubjectBookmarkList = <PracticeMCQData>[].obs;

  RxString selectedTestType = 'Topic Wise Test'.obs;
  // List of items in our dropdown menu
  List<String> items = ['Topic Wise Test', 'SubjectWise Test'];

  List<TestTopicData> testTopicList =
      List<TestTopicData>.empty(growable: true).obs;
  ScrollController topicTestScrollController = ScrollController();
  int topicTestPage = 1;

  List<TestSubjectData> testSubjectList =
      List<TestSubjectData>.empty(growable: true).obs;
  ScrollController subjectTestScrollController = ScrollController();
  int subjectTestPage = 1;

  List<TestSubjectData> testSingleTopicList =
      List<TestSubjectData>.empty(growable: true).obs;
  ScrollController topicSingleTestScrollController = ScrollController();
  int topicSingleTestPage = 1;

  @override
  void onInit() {
    super.onInit();
    addPracticeSubjectBookmarkItems();
    addTopicTestItems();

    addSubjectTestItems();
  }

  int isTestLable(GetTest subjecttest) {
    int lable = 0;

    DateTime now = DateTime.now();
    var formatterdate = DateFormat('yyyy-MM-dd');
    String currentDate = formatterdate.format(now);
    var formatterdatetime = DateFormat('yyyy-MM-dd HH:mm:ss');
    String currentDateTime = formatterdatetime.format(now);

    final teststartdateTime =
        Jiffy(subjecttest.activationDateTime.toString(), "yyyy-MM-dd HH:mm:ss")
            .dateTime;
    final currentdatetime =
        Jiffy(currentDateTime.toString(), "yyyy-MM-dd HH:mm:ss").dateTime;

    print(subjecttest.activationDateTime);
    print(teststartdateTime);
    print(currentdatetime);

    final teststartdate =
        Jiffy(subjecttest.activationDateTime, "yyyy-MM-dd").dateTime;
    final currentdate = Jiffy(currentDate, "yyyy-MM-dd").dateTime;

    // if (teststartdate.isAfter(currentdate)) {

    if (teststartdateTime.isAfter(currentdatetime)) {
      print('Future test');
      lable = 1;
    } else {
      print('Start test');
      lable = 3;
    }

    // else if (teststartdateTime.isBefore(currentdatetime)) {
    //   print('Test Gonebbb');
    //   // lable = 2;
    //   if (teststartdateTime
    //       .add(Duration(minutes: 30))
    //       .isAfter(currentdatetime)) {
    //     print('Start test');
    //     lable = 3;
    //   } else {
    //     print('Test OVER');
    //     lable = 4;
    //   }
    // } else if (teststartdateTime.isAtSameMomentAs(currentdatetime)) {
    //   print('TEST');
    //   if (teststartdateTime
    //       .add(Duration(minutes: 30))
    //       .isAfter(currentdatetime)) {
    //     print('Start test');
    //     lable = 3;
    //   } else {
    //     print('Test OVER');
    //     lable = 4;
    //   }
    // }

    return lable;
  }

  int isTestLableSubject(TestSubjectData subjecttest) {
    int lable = 0;

    DateTime now = DateTime.now();
    var formatterdate = DateFormat('yyyy-MM-dd');
    String currentDate = formatterdate.format(now);
    var formatterdatetime = DateFormat('yyyy-MM-dd HH:mm:ss');
    String currentDateTime = formatterdatetime.format(now);

    final teststartdateTime =
        Jiffy(subjecttest.activationDateTime.toString(), "yyyy-MM-dd HH:mm:ss")
            .dateTime;
    final currentdatetime =
        Jiffy(currentDateTime.toString(), "yyyy-MM-dd HH:mm:ss").dateTime;

    print(subjecttest.activationDateTime);
    print(teststartdateTime);
    print(currentdatetime);

    final teststartdate =
        Jiffy(subjecttest.activationDateTime, "yyyy-MM-dd").dateTime;
    final currentdate = Jiffy(currentDate, "yyyy-MM-dd").dateTime;

    // if (teststartdate.isAfter(currentdate)) {

    if (teststartdateTime.isAfter(currentdatetime)) {
      print('Future test');
      lable = 1;
    } else {
      print('Start test');
      lable = 3;
    }

    // else if (teststartdateTime.isBefore(currentdatetime)) {
    //   print('Test Gonebbb');
    //   // lable = 2;
    //   if (teststartdateTime
    //       .add(Duration(minutes: 30))
    //       .isAfter(currentdatetime)) {
    //     print('Start test');
    //     lable = 3;
    //   } else {
    //     print('Test OVER');
    //     lable = 4;
    //   }
    // } else if (teststartdateTime.isAtSameMomentAs(currentdatetime)) {
    //   print('TEST');
    //   if (teststartdateTime
    //       .add(Duration(minutes: 30))
    //       .isAfter(currentdatetime)) {
    //     print('Start test');
    //     lable = 3;
    //   } else {
    //     print('Test OVER');
    //     lable = 4;
    //   }
    // }

    return lable;
  }

  void setSelectedTestType(String value) {
    selectedTestType.value = value;

    subjectId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectId'];
    if (selectedTestType.value == 'Topic Wise Test') {
      topicTestPage = 1;
      getTestByTopic(true, subjectId!, topicTestPage);
    } else {
      subjectTestPage = 1;
      getTestBySubject(true, subjectId!, subjectTestPage);
    }
  }

  String separateString(String mixString, String seperateBy, int index) {
    if (mixString.contains(seperateBy)) {
      final names = mixString;
      final splitNames = names.split(seperateBy);
      List<String>? splitList = [];
      for (int i = 0; i < splitNames.length; i++) {
        splitList.add(splitNames[i]);
      }
      return splitList[index];
    } else {
      if (index == 0) {
        return mixString;
      } else {
        return "";
      }
    }
  }

  void changeType(String typeId, String subcategoryId, String from) {
    selectedTypeId.value = typeId;

    print('selectedTypeId->' + selectedTypeId.value.toString());

    if (from == 'Plan') {
      print('LENGHT -->Plan');
      getPlanList(
          true,
          selectedTypeId.value == '1'
              ? 'practice'
              : selectedTypeId.value == '2'
                  ? 'test'
                  : 'pyq');
    } else {
      print('LENGHT -->Subject');
      getSubjectList(
          true,
          subcategoryId,
          selectedTypeId.value == '1'
              ? 'practice'
              : selectedTypeId.value == '2'
                  ? 'test'
                  : 'pyq');
    }
  }

  void changeSubjectType(RxString tabId) {
    selectedSubjectTab.value = tabId.value;
    subjectId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_subject")['subjectId'];
    if (selectedSubjectTab.value == '1') {
      if (selectedTypeId.value == '1') {
        getChapterList(true, subjectId!);
      } else if (selectedTypeId.value == '3') {
        getPYQChapterList(true, subjectId!);
      }
    } else if (selectedSubjectTab.value == '2') {
      if (selectedTypeId.value == '1') {
        getSubjectAnalysis(subjectId!);
      } else if (selectedTypeId.value == '3') {
        getPYQSubjectAnalysis(subjectId!);
      }
    } else if (selectedSubjectTab.value == '3') {
      subjectBookmarkPage = 1;

      getSubjectBookmarkList(
          true, subjectId!, subjectBookmarkPage, selectedTypeId.value);
    }
  }

  addPracticeSubjectBookmarkItems() async {
    practiceSubjectBookmarkScrollController.addListener(() {
      if (practiceSubjectBookmarkScrollController.position.maxScrollExtent ==
          practiceSubjectBookmarkScrollController.position.pixels) {
        subjectBookmarkPage++;
        getSubjectBookmarkList(
            false, subjectId!, subjectBookmarkPage, selectedTypeId.value);
      }
    });
  }

  addTopicTestItems() async {
    topicTestScrollController.addListener(() {
      if (topicTestScrollController.position.maxScrollExtent ==
          topicTestScrollController.position.pixels) {
        topicTestPage++;
        getTestByTopic(false, subjectId!, topicTestPage);
      }
    });
  }

  addSubjectTestItems() async {
    subjectTestScrollController.addListener(() {
      if (subjectTestScrollController.position.maxScrollExtent ==
          subjectTestScrollController.position.pixels) {
        subjectTestPage++;
        getTestBySubject(false, subjectId!, subjectTestPage);
      }
    });
  }

  addSingleTopicTestItems() async {
    topicId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_topic")['topicId'];
    topicSingleTestScrollController.addListener(() {
      if (topicSingleTestScrollController.position.maxScrollExtent ==
          topicSingleTestScrollController.position.pixels) {
        topicSingleTestPage++;
        getTestBySingleTopic(false, topicId!, topicSingleTestPage);
      }
    });
  }

  String convertToABCD(int index) {
    RxString optionLable = ''.obs;
    if (index == 0) {
      optionLable.value = 'A';
    } else if (index == 1) {
      optionLable.value = 'B';
    } else if (index == 2) {
      optionLable.value = 'C';
    } else if (index == 3) {
      optionLable.value = 'D';
    } else if (index == 4) {
      optionLable.value = 'E';
    } else if (index == 5) {
      optionLable.value = 'F';
    } else if (index == 6) {
      optionLable.value = 'G';
    }
    return optionLable.value;
  }

  @override
  void onClose() {}

  void getSubjectList(
    bool isShowLoading,
    String subcategoryid,
    String type,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      subjectList.clear();
      comboSubjectList.clear();
      SubjectModel? model =
          await RemoteServices.instance.getSubjectList(subcategoryid, type);

      subjectList.addAll(model!.getSinglePlan!);
      comboSubjectList.addAll(model.getComboPlan!);

      print(subjectList.length);
      print(comboSubjectList.length);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getComboSubjectList(
    bool isShowLoading,
    String subscriptionid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      subjectList2.clear();

      SubjectModel? model =
          await RemoteServices.instance.getComboSubjectList(subscriptionid);

      subjectList2.addAll(model!.getSinglePlan2!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getChapterList(
    bool isShowLoading,
    String subjectid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      chapterList.clear();

      ChapterModel? model =
          await RemoteServices.instance.getChapterList(subjectid);

      chapterList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getPYQChapterList(
    bool isShowLoading,
    String subjectid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      chapterList.clear();

      ChapterModel? model =
          await RemoteServices.instance.getPYQChapterList(subjectid);

      chapterList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getTopicList(
    bool isShowLoading,
    String chapterid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      topicList.clear();

      TopicModel? model = await RemoteServices.instance.getTopicList(chapterid);

      topicList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getPYQTopicList(
    bool isShowLoading,
    String chapterId,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      topicList.clear();

      TopicModel? model =
          await RemoteServices.instance.getPYQTopicList(chapterId);

      topicList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getSubjectDetails(
    String subjectId,
    String type,
  ) async {
    try {
      showLoader();

      isLoading(true);

      subjectSubscriptionList.clear();
      subjectDetailsModel = SubjectDetailsModel();

      SubjectDetailsModel? model =
          await RemoteServices.instance.getSubjectDetails(subjectId, type);

      subjectDetailsModel = model;
      subjectSubscriptionList.addAll(model!.subject!.subjectSubscription ?? []);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getSubscriptionDetails(
    String subscriptionId,
  ) async {
    try {
      showLoader();

      isLoading(true);

      subjectSubscriptionList.clear();
      subjectDetailsModel = SubjectDetailsModel();

      SubjectDetailsModel? model =
          await RemoteServices.instance.getSubscriptionDetails(subscriptionId);

      subjectDetailsModel = model;
      subjectSubscriptionList.addAll(model!.subject!.subjectSubscription!);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getSubjectAnalysis(
    String subjectId,
  ) async {
    try {
      showLoader();

      isLoading(true);

      subjectSubscriptionList.clear();
      subjectDetailsModel = SubjectDetailsModel();

      SubjectAnalysisModel? model =
          await RemoteServices.instance.getSubjectAnalysis(subjectId);

      subjectAnalysisModel = model;
      dataMapChapterwise = <String, double>{
        "Completed": model!.chapterBreakdown!.totalCompletedTopic!.toDouble(),
        "Ongoing": model.chapterBreakdown!.totalOngoingTopic!.toDouble(),
        "Unseen": model.chapterBreakdown!.totalUnseenTopic!.toDouble(),
      };

      dataMapQueBreakdown = <String, double>{
        "Correct": model.questionBreakdown!.totalCorrect!.toDouble(),
        "Incorrect": model.questionBreakdown!.totalIncorrect!.toDouble(),
        "Skipped": model.questionBreakdown!.totalSkip!.toDouble(),
      };

      dataMapTimereakdown = <String, double>{
        "Correct": model.questionBreakdown!.totalCorrectTime!.toDouble(),
        "Incorrect": model.questionBreakdown!.totalIncorrectTime!.toDouble(),
        "Skipped": model.questionBreakdown!.totalSkipTime!.toDouble(),
      };
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getPYQSubjectAnalysis(
    String subjectId,
  ) async {
    try {
      showLoader();

      isLoading(true);

      subjectSubscriptionList.clear();
      subjectDetailsModel = SubjectDetailsModel();

      SubjectAnalysisModel? model =
          await RemoteServices.instance.getPYQSubjectAnalysis(subjectId);

      subjectAnalysisModel = model;
      dataMapChapterwise = <String, double>{
        "Completed": model!.chapterBreakdown!.totalCompletedTopic!.toDouble(),
        "Ongoing": model.chapterBreakdown!.totalOngoingTopic!.toDouble(),
        "Unseen": model.chapterBreakdown!.totalUnseenTopic!.toDouble(),
      };

      dataMapQueBreakdown = <String, double>{
        "Correct": model.questionBreakdown!.totalCorrect!.toDouble(),
        "Incorrect": model.questionBreakdown!.totalIncorrect!.toDouble(),
        "Skipped": model.questionBreakdown!.totalSkip!.toDouble(),
      };

      dataMapTimereakdown = <String, double>{
        "Correct": model.questionBreakdown!.totalCorrectTime!.toDouble(),
        "Incorrect": model.questionBreakdown!.totalIncorrectTime!.toDouble(),
        "Skipped": model.questionBreakdown!.totalSkipTime!.toDouble(),
      };
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  // Yamin need to do pagination in this service
  void getSubjectBookmarkList(
      bool isShowLoading, String subjectId, int page, String type) async {
    try {
      if (isShowLoading) {
        showLoader();
        practiceSubjectBookmarkList.clear();
      }

      isLoading(true);
      PracticeMcqModel? model;

      if (type == '1') {
        model = await RemoteServices.instance
            .getSubjectBookmarkList(subjectId, page);
      } else if (type == '3') {
        model = await RemoteServices.instance
            .getPYQSubjectBookmarkList(subjectId, page);
      }

      List<PracticeMCQData> practiceSubjectBookmarkListTemp =
          <PracticeMCQData>[];

      practiceSubjectBookmarkListTemp.addAll(model!.data!);

      for (int i = 0; i < practiceSubjectBookmarkListTemp.length; i++) {
        if (practiceSubjectBookmarkListTemp[i].type == 1 ||
            practiceSubjectBookmarkListTemp[i].type == 2) {
          List trueAnswers = [];

          for (int j = 0;
              j < practiceSubjectBookmarkListTemp[i].getOption!.length;
              j++) {
            if (practiceSubjectBookmarkListTemp[i].getOption![j].isTrue == 1) {
              trueAnswers.add(practiceSubjectBookmarkListTemp[i]
                  .getOption![j]
                  .id
                  .toString());
            }
          }

          trueAnswers.sort((a, b) => a.length.compareTo(b.length));
          practiceSubjectBookmarkListTemp[i]
              .userSelectedAnswerApp!
              .sort((a, b) => a.length.compareTo(b.length));

          if (listEquals(trueAnswers,
              practiceSubjectBookmarkListTemp[i].userSelectedAnswerApp!)) {
            practiceSubjectBookmarkListTemp[i].isAnswerTrue = 1;
          } else {
            practiceSubjectBookmarkListTemp[i].isAnswerTrue = 0;
          }
        } else if (practiceSubjectBookmarkListTemp[i].type == 3) {
          if (practiceSubjectBookmarkListTemp[i]
                  .userSelectedAnswerApp!
                  .isNotEmpty &&
              (double.parse(practiceSubjectBookmarkListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) >=
                  double.parse(practiceSubjectBookmarkListTemp[i]
                      .getOption![0]
                      .optionMin
                      .toString())) &&
              (double.parse(practiceSubjectBookmarkListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) <=
                  double.parse(practiceSubjectBookmarkListTemp[i]
                      .getOption![0]
                      .optionMax
                      .toString()))) {
            practiceSubjectBookmarkListTemp[i].isAnswerTrue = 1;
          } else if (practiceSubjectBookmarkListTemp[i]
                  .userSelectedAnswerApp!
                  .isNotEmpty &&
              ((double.parse(practiceSubjectBookmarkListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) <
                      double.parse(practiceSubjectBookmarkListTemp[i]
                          .getOption![0]
                          .optionMin
                          .toString())) ||
                  (double.parse(practiceSubjectBookmarkListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) >
                      double.parse(practiceSubjectBookmarkListTemp[i]
                          .getOption![0]
                          .optionMax
                          .toString())))) {
            practiceSubjectBookmarkListTemp[i].isAnswerTrue = 0;
          }
        }
        practiceSubjectBookmarkList.add(practiceSubjectBookmarkListTemp[i]);
      }

      // practiceSubjectBookmarkList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  //TEST MODULE SERVICES
  void getTestByTopic(bool isShowLoading, String subjectId, int page) async {
    try {
      if (isShowLoading) {
        showLoader();
        isLoading(true);

        testTopicList.clear();
      }

      TestTopicModel? model =
          await RemoteServices.instance.getTestByTopic(subjectId, page);

      testTopicList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getTestBySubject(bool isShowLoading, String subjectId, int page) async {
    try {
      if (isShowLoading) {
        showLoader();
        isLoading(true);
        testSubjectList.clear();
      }

      TestSubjectModel? model =
          await RemoteServices.instance.getTestBySubject(subjectId, page);

      testSubjectList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getTestBySingleTopic(
      bool isShowLoading, String topictId, int page) async {
    try {
      if (isShowLoading) {
        showLoader();
        isLoading(true);
        testSingleTopicList.clear();
      }

      TestSubjectModel? model =
          await RemoteServices.instance.getTestBySingleTopic(topictId, page);

      testSingleTopicList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getInstructions(
      bool isShowLoading, String testid, String testname) async {
    try {
      if (isShowLoading) {
        showLoader();
        isLoading(true);
      }

      ScoreCardModel? model =
          await RemoteServices.instance.getInstructions(testid);

      if (model!.status!) {
        // getItRegister<Map<String, dynamic>>({
        //   'testId': testid,
        //   'testName': testname.toUpperCase(),
        //   'testFrom': 'Test',
        //   'testIntro': model.data!.description.toString(),
        // }, name: "selected_test");
        // Get.toNamed(AppRoutes.testmcq);

        getItRegister<Map<String, dynamic>>({
          'testId': testid,
          'testName': testname.toUpperCase(),
          'testFrom': 'Test',
          'testIntro': model.data!.description.toString(),
        }, name: "selected_test");
        final data = await Get.toNamed(AppRoutes.testmcq);
        if (data == 'success') {
          subjectId = GetIt.I<Map<String, dynamic>>(
              instanceName: "selected_subject")['subjectId'];
          if (selectedTestType.value == 'Topic Wise Test') {
            topicTestPage = 1;
            getTestByTopic(true, subjectId!, topicTestPage);
          } else {
            subjectTestPage = 1;
            getTestBySubject(true, subjectId!, subjectTestPage);
          }
        }
      }
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getPlanList(
    bool isShowLoading,
    String type,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      subjectList.clear();
      comboSubjectList.clear();

      SubjectModel? model = await RemoteServices.instance.getPlanList(type);

      print('LENGHT -->' + model!.getSinglePlan!.length.toString());

      subjectList.addAll(model!.getSinglePlan!);
      comboSubjectList.addAll(model.getComboPlan!);

      print(subjectList.length);
      print(comboSubjectList.length);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }
}
