import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/models/beforesubmit_model.dart';
import 'package:flutter_practicekiya/models/competitive_model.dart';
import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/questionwise_model.dart';
import 'package:flutter_practicekiya/models/scorecard_model.dart';

import 'package:flutter_practicekiya/models/topicanaysis_model.dart';

import 'package:get/get.dart';

import 'package:get_it/get_it.dart';
import 'package:jiffy/jiffy.dart';

import '../models/idstringname_model.dart';
import '../models/login_model.dart';
import '../models/practicetopicleaderboard_model.dart';
import '../models/testmcq_model.dart';
import '../models/testtopic_model.dart';
import '../models/topicwise_model.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';

import '../utils/functions.dart';
import '../utils/preferences.dart';
import '../utils/staticarrays.dart';
import '../utils/theme.dart';

class TestMCQController extends GetxController {
  Prefs prefs = Prefs.prefs;
  LoginModel? loginModel;
  String userID = '';

  var isLoading = true.obs;

  RxList<TestMcqData> testMCQList = <TestMcqData>[].obs;
  RxList<TestMcqData> testTechnicalList = <TestMcqData>[].obs;
  RxList<TestMcqData> testGeneralList = <TestMcqData>[].obs;

  RxInt testTypeSelected = 2.obs;
  // List<TestMcqData>.empty(growable: true).obs;

  RxInt selectedIndex = 0.obs;

  TextEditingController? numericAnswerController;

  RxBool showGif = false.obs;
  final count = 0.obs;

  // RxInt checkAnswer = 0.obs;

  TextEditingController? reportCommentController;
  final GlobalKey<FormState> reportFormKey = GlobalKey<FormState>();

  String? topicId, testId;

  List<CurrentUser> practiceTopicLeaderBoardList =
      List<CurrentUser>.empty(growable: true).obs;
  RxString selectedTestAnalysisTab = '1'.obs;
  CurrentUser? selfPracticeTopicLeaderBoardData;
  List<CurrentUser> top3TopicLeaderBoardList =
      List<CurrentUser>.empty(growable: true).obs;

  ScrollController practiceTopicLeaderBoardScrollController =
      ScrollController();
  int leaderPage = 1;

  ScrollController questionWiseScrollController = ScrollController();
  int questionWisePage = 1;
  // RxList<TestMcqData> practiceTopicBookmarkList = <TestMcqData>[].obs;

  bool flag = true;
  Stream<int>? timerStream;
  StreamSubscription<int>? timerSubscription;
  RxString hoursStr = '00'.obs;
  RxString minutesStr = '00'.obs;
  RxString secondsStr = '00'.obs;

  RxBool isCorrect = false.obs;
  RxBool isInCorrect = false.obs;
  RxBool isSaved = false.obs;
  RxBool isUnattempted = false.obs;
  RxBool isAnswered = false.obs;
  RxBool isMarkReviewNoAnswer = false.obs;
  RxBool isMarkReviewWithAnswer = false.obs;

  RxBool correct = false.obs;
  RxBool incorrect = false.obs;
  RxBool saved = false.obs;
  RxBool unattempted = false.obs;
  RxBool answered = false.obs;
  RxBool markReviewNoAnswer = false.obs;
  RxBool markReviewWithAnswer = false.obs;

  RxBool showQuestion = true.obs;

  Timer? timer;
  RxInt? start = 0.obs;

  // RxBool showFinalDialog = false.obs;

  BeforeSubmitData? beforeSubmitData = BeforeSubmitData();

  var scoreCardModel = ScoreCardModel().obs;

  TopicAnalysisModel? topicAnalysisModel = TopicAnalysisModel();

  Map<String, double> dataMapTechnicalCorrect = <String, double>{
    "Flutter": 5,
  };

  Map<String, double> dataMapTechnicalInCorrect = <String, double>{
    "Flutter": 5,
  };

  Map<String, double> dataMapTechnicalSkipped = <String, double>{
    "Flutter": 5,
  };

  Map<String, double> dataMapGeneralCorrect = <String, double>{
    "Flutter": 5,
  };

  Map<String, double> dataMapGeneralInCorrect = <String, double>{
    "Flutter": 5,
  };

  Map<String, double> dataMapGeneralSkipped = <String, double>{
    "Flutter": 5,
  };

  StreamController<String> refreshStreamController =
      StreamController.broadcast();

  List<QuestionWiseData> questionWiseList =
      List<QuestionWiseData>.empty(growable: true).obs;

  TopicWiseData? topicWiseData;

  List<CurrentUserData> competitiveStudentList =
      List<CurrentUserData>.empty(growable: true).obs;

  CurrentUserData? currentUserData;

  var sliderController =
      PageController(viewportFraction: 1, keepPage: true).obs;

  StreamController drawerController = StreamController.broadcast();

  StreamController drawerControllerAlert = StreamController.broadcast();

  RxList<IdStringNameModel> alertList = StaticArrays.getAlertList().obs;
  RxBool isOtherSelected = false.obs;

  final colorList = <Color>[
    kDarkBlueColor,
    kChartOrangeColor,
    kSecondaryColor,
  ];

  RxList<Widget> commentWidgets = <Widget>[].obs;

  RxBool isList = true.obs;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timerrr) {
        print("TIMER " + start!.value.toString());
        if (start!.value == 0) {
          // setState(() {

          //JUST COMMENTED

          String testFrom = GetIt.I<Map<String, dynamic>>(
              instanceName: "selected_test")['testFrom'];

          if (testFrom == 'Test') {
            print("TIMER Test " + start!.value.toString());
            getWholeTestSubmittedFinal(testId!);
          }
          timerrr.cancel();
        } else {
          // setState(() {
          start!.value--;
          // });
        }
      },
    );
  }

  Stream<int> stopWatchStream() {
    StreamController<int>? streamController;
    Timer? timer;
    Duration? timerInterval = const Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      if (timer != null) {
        timer!.cancel();
        timer = null;
        counter = 0;
        streamController!.close();
      }
    }

    void tick(_) {
      counter++;
      streamController!.add(counter);
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  void startStopWatch() {
    timerStream = stopWatchStream();
    timerSubscription = timerStream!.listen((int newTick) {
      if (testMCQList.isNotEmpty) {
        testMCQList[selectedIndex.value].takenTimeApp = newTick;
      }
      hoursStr.value =
          ((newTick / (60 * 60)) % 60).floor().toString().padLeft(2, '0');
      minutesStr.value =
          ((newTick / 60) % 60).floor().toString().padLeft(2, '0');
      secondsStr.value = (newTick % 60).floor().toString().padLeft(2, '0');
    });
  }

  void resetStopWatch() {
    if (timerSubscription != null) {
      timerSubscription!.cancel();
      timerStream = null;

      hoursStr.value = '00';
      minutesStr.value = '00';
      secondsStr.value = '00';
    }
  }

  RxString convertToHour(int seconds) {
    RxString hoursStr =
        ((seconds / (60 * 60)) % 60).floor().toString().padLeft(2, '0').obs;
    return hoursStr;
  }

  RxString convertToMinutes(int seconds) {
    RxString minutesStr =
        ((seconds / 60) % 60).floor().toString().padLeft(2, '0').obs;
    return minutesStr;
  }

  RxString convertToSeconds(int seconds) {
    RxString secondsStr = (seconds % 60).floor().toString().padLeft(2, '0').obs;
    return secondsStr;
  }

  void applyFilter() {
    String testFrom = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_test")['testFrom'];

    print("URVI->" + testFrom);
    isCorrect.value = correct.value;
    isSaved.value = saved.value;
    isInCorrect.value = incorrect.value;
    isUnattempted.value = unattempted.value;

    isAnswered.value = answered.value;
    isMarkReviewNoAnswer.value = markReviewNoAnswer.value;
    isMarkReviewWithAnswer.value = markReviewWithAnswer.value;

    for (int i = 0; i < testMCQList.length; i++) {
      if (isCorrect.value ||
          isSaved.value ||
          isInCorrect.value ||
          isUnattempted.value ||
          isAnswered.value ||
          isMarkReviewNoAnswer.value ||
          isMarkReviewWithAnswer.value) {
        if (isCorrect.value && testMCQList[i].isAnswerTrue == 1) {
          selectedIndex.value = i;

          break;
        } else if ((testFrom == 'Test') &&
            isSaved.value &&
            (testMCQList[i].isBookmark == 1)) {
          print('URVI 3');
          selectedIndex.value = i;
          break;
        } else if (isInCorrect.value &&
            (testMCQList[i].isAnswerTrue == 0 &&
                testMCQList[i].userSelectedAnswerApp!.isNotEmpty)) {
          print('URVI 4');
          selectedIndex.value = i;
          break;
        } else if ((testFrom == 'Test') &&
            isUnattempted.value &&
            (testMCQList[i].userSelectedAnswerApp!.isEmpty &&
                testMCQList[i].markReview == 0 &&
                testMCQList[i].isBookmark == 0)) {
          print('URVI 5');
          selectedIndex.value = i;
          break;
        } else if ((testFrom == 'Test') &&
            isAnswered.value &&
            (testMCQList[i].userSelectedAnswerApp!.isNotEmpty &&
                testMCQList[i].markReview == 0)) {
          print('URVI 6');
          selectedIndex.value = i;
          break;
        } else if ((testFrom == 'Test') &&
            isMarkReviewNoAnswer.value &&
            (testMCQList[i].userSelectedAnswerApp!.isEmpty &&
                testMCQList[i].markReview == 1)) {
          print('URVI 7');
          selectedIndex.value = i;
          break;
        } else if ((testFrom == 'Test') &&
            isMarkReviewWithAnswer.value &&
            (testMCQList[i].userSelectedAnswerApp!.isNotEmpty &&
                testMCQList[i].markReview == 1)) {
          print('URVI 8');
          selectedIndex.value = i;
          break;
        } else if ((testFrom == 'Solution') &&
            isUnattempted.value &&
            (testMCQList[i].userSelectedAnswerApp!.isEmpty)) {
          print('URVI SU');
          selectedIndex.value = i;
          break;
        } else {
          selectedIndex.value = i;
        }
      } else {
        print('URVI 9');
        selectedIndex.value = i;
        break;
      }
    }

    setNumericAnswer();
    resetStopWatch();
    startStopWatch();
  }

  void openDrawer() {
    correct.value = isCorrect.value;
    saved.value = isSaved.value;
    incorrect.value = isInCorrect.value;
    unattempted.value = isUnattempted.value;

    answered.value = isAnswered.value;
    markReviewNoAnswer.value = isMarkReviewNoAnswer.value;
    markReviewWithAnswer.value = isMarkReviewWithAnswer.value;
  }

  void clearFilter() {
    isCorrect.value = false;
    isSaved.value = false;
    isInCorrect.value = false;
    isUnattempted.value = false;
    isAnswered.value = false;
    isMarkReviewNoAnswer.value = false;
    isMarkReviewWithAnswer.value = false;

    correct.value = false;
    saved.value = false;
    incorrect.value = false;
    unattempted.value = false;
    answered.value = false;
    markReviewNoAnswer.value = false;
    markReviewWithAnswer.value = false;

    drawerController.sink.add('N/A');
  }

  @override
  void onInit() {
    super.onInit();
    getPrefs();
    numericAnswerController = TextEditingController(text: '');
    reportCommentController = TextEditingController(text: '');
    testId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_test")['testId'];
    // addQuestionWiseItems();
  }

  void changeTestAnalysisType(RxString testAnalysisTabId, String type) {
    selectedTestAnalysisTab.value = testAnalysisTabId.value;
    testId =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_test")['testId'];
    if (selectedTestAnalysisTab.value == '1') {
      getTopicWise(testId!);
    } else if (selectedTestAnalysisTab.value == '2') {
      // questionWisePage = 1;
      getQuestionWiseList(testId!);
    } else if (selectedTestAnalysisTab.value == '3') {
      getCompetitive(testId!);
    }
  }

  // addQuestionWiseItems() async {
  //   questionWiseScrollController.addListener(() {
  //     if (questionWiseScrollController.position.maxScrollExtent ==
  //         questionWiseScrollController.position.pixels) {
  //       questionWisePage++;
  //       getTopicBookmarkList(false, topicId!, questionWisePage);
  //     }
  //   });
  // }

  addTopicLeaderBoardItems(String type) async {
    practiceTopicLeaderBoardScrollController.addListener(() {
      if (practiceTopicLeaderBoardScrollController.position.maxScrollExtent ==
          practiceTopicLeaderBoardScrollController.position.pixels) {
        leaderPage++;
        getPracticeTopicLeader(false, topicId!, leaderPage, type);
      }
    });
  }

  @override
  void onClose() {}

  void getPrefs() async {
    loginModel = LoginModel.fromJson(await prefs.getLoginData("login"));
    userID = loginModel!.data!.id.toString();
  }

  @override
  void dispose() {
    super.dispose();
    stopWatchStream();
  }

  void changeTestTypeFilter(int type) {
    testTypeSelected.value = type;
    selectedIndex.value = 0;
    if (testTypeSelected.value == 1) {
      testGeneralList = testMCQList;

      testMCQList = testTechnicalList;
    } else {
      testTechnicalList = testMCQList;

      testMCQList = testGeneralList;
    }
  }

  void previousQuestion() {
    if (selectedIndex.value == 0) {
      showSnackBar("Practice MCQ Test", "No previous question");
    } else {
      if (isCorrect.value ||
          isSaved.value ||
          isInCorrect.value ||
          isUnattempted.value ||
          isAnswered.value ||
          isMarkReviewNoAnswer.value ||
          isMarkReviewWithAnswer.value) {
        for (int i = testMCQList.length - 1; i >= 0; i--) {
          if (i < selectedIndex.value && testMCQList[i].isVisible == true) {
            selectedIndex.value = i;
            break;
          }
        }
      } else {
        selectedIndex.value = selectedIndex.value - 1;
      }

      setNumericAnswer();
    }
    resetStopWatch();
    startStopWatch();
  }

  void nextQuestion(String type) {
    if ((testMCQList.length - 1) <= selectedIndex.value) {
      selectedIndex.value = 0;
    } else {
      if (isCorrect.value ||
          isSaved.value ||
          isInCorrect.value ||
          isUnattempted.value ||
          isAnswered.value ||
          isMarkReviewNoAnswer.value ||
          isMarkReviewWithAnswer.value) {
        for (int i = 0; i < testMCQList.length; i++) {
          if (i > selectedIndex.value && testMCQList[i].isVisible == true) {
            selectedIndex.value = i;
            break;
          }
        }
      } else {
        selectedIndex.value = selectedIndex.value + 1;
      }
      // startStopWatch();
    }

    setNumericAnswer();

//     // if ((testMCQList.length - 1) <= selectedIndex.value) {
//     //   //call all submit function

//     // } else {
//     // testMCQList[selectedIndex.value].isSkip = 1;
//     // if (testMCQList[selectedIndex.value].userSelectedAnswerApp!.isEmpty) {
//       // getSingleTestSubmitted(
//       //   testMCQList[selectedIndex.value].id.toString(),
//       //   testMCQList[selectedIndex.value].type.toString(),
//       //   testMCQList[selectedIndex.value].userSelectedAnswerApp!,
//       //   testMCQList[selectedIndex.value].takenTimeApp.toString(),
//       //   '1',
//       // );
//       // }

// //JUST COMMENTED

//       // if (isCorrect.value ||
//       //     isSaved.value ||
//       //     isInCorrect.value ||
//       //     isUnattempted.value) {
//       //   for (int i = 0; i < testMCQList.length; i++) {
//       //     if (i > selectedIndex.value && testMCQList[i].isVisible == true) {
//       //       selectedIndex.value = i;
//       //       break;
//       //     }
//       //   }
//       // } else {
//       //   selectedIndex.value = selectedIndex.value + 1;
//       // }
//       setNumericAnswer();
//     // }
//     resetStopWatch();
//     startStopWatch();
  }

  void markReviewAnswer() {
    // if ((testMCQList.length - 1) <= selectedIndex.value) {
    //   //call all submit function

    // } else {
    // testMCQList[selectedIndex.value].isSkip = 1;

    getTestMarkReview(testMCQList[selectedIndex.value].id.toString(), '1');

    // if (testMCQList[selectedIndex.value].userSelectedAnswerApp!.isEmpty) {
    //   getTestMarkReview(testMCQList[selectedIndex.value].id.toString(), '2');
    // } else if (testMCQList[selectedIndex.value]
    //     .userSelectedAnswerApp!
    //     .isNotEmpty) {
    //   getTestMarkReview(testMCQList[selectedIndex.value].id.toString(), '3');
    // }

    // if (isCorrect.value ||
    //     isSaved.value ||
    //     isInCorrect.value ||
    //     isUnattempted.value) {
    //   for (int i = 0; i < testMCQList.length; i++) {
    //     if (i > selectedIndex.value && testMCQList[i].isVisible == true) {
    //       selectedIndex.value = i;
    //       break;
    //     }
    //   }
    // } else {
    //   selectedIndex.value = selectedIndex.value + 1;
    // }
    // setNumericAnswer();
    // }
    resetStopWatch();
    startStopWatch();
  }

  void clearAnswer() {
    getTestClearAnswer(testMCQList[selectedIndex.value].id.toString());
  }

  void setNumericAnswer() {
    if (numericAnswerController!.text != null) {
      numericAnswerController!.text =
          testMCQList[selectedIndex.value].userSelectedAnswerApp!.isNotEmpty
              ? (testMCQList[selectedIndex.value].userSelectedAnswerApp![0])
              : testMCQList[selectedIndex.value].userTempAnswer!.isNotEmpty
                  ? testMCQList[selectedIndex.value].userTempAnswer![0]
                  : '';

      numericAnswerController!.selection = TextSelection.fromPosition(
          TextPosition(
              offset: numericAnswerController!.text.toString().length));
    }
  }

  void submitAnswer(String type) {
    if (testMCQList[selectedIndex.value].userTempAnswer!.isNotEmpty) {
      testMCQList[selectedIndex.value].isSkip = 0;
      testMCQList[selectedIndex.value]
          .userSelectedAnswerApp!
          .addAll(testMCQList[selectedIndex.value].userTempAnswer!);

      setLabelOnQuestionNumber();

      resetStopWatch();

      getSingleTestSubmitted(
          testMCQList[selectedIndex.value].id.toString(),
          testMCQList[selectedIndex.value].type.toString(),
          testMCQList[selectedIndex.value].userSelectedAnswerApp!,
          testMCQList[selectedIndex.value].takenTimeApp.toString(),
          '0');
    } else {
      // showSnackBar("Practice MCQ Test", "Please select/write answer");

      testMCQList[selectedIndex.value].isSkip = 1;
      setLabelOnQuestionNumber();

      resetStopWatch();

      getSingleTestSubmitted(
          testMCQList[selectedIndex.value].id.toString(),
          testMCQList[selectedIndex.value].type.toString(),
          testMCQList[selectedIndex.value].userSelectedAnswerApp!,
          testMCQList[selectedIndex.value].takenTimeApp.toString(),
          '1');
    }
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

  void onSelectionOfOption(TestMcqData data, int index, GetOption options,
      String optionid, int isSelected, String type) {
    // if (testMCQList[selectedIndex.value].userSelectedAnswerApp!.isEmpty) {
    if (data.type == 1) {
      data.userTempAnswer!.clear();
      data.userSelectedAnswerApp!.clear();
      options.isUserSelected = 0;
      data.userTempAnswer!.add(optionid.toString());

      //Commented
      // submitAnswer(type);
    } else if (data.type == 2) {
      data.userSelectedAnswerApp!.clear();
      if (isSelected == 0) {
        options.isUserSelected = 1;
        data.userTempAnswer!.add(optionid.toString());
        // data.userSelectedAnswerApp!.add(optionid.toString());
      } else {
        options.isUserSelected = 0;
        data.userTempAnswer!.remove(optionid.toString());
        // data.userSelectedAnswerApp!.remove(optionid.toString());
      }
    } else if (data.type == 3) {}

    data.getOption![index] = options;

    testMCQList[selectedIndex.value] = data;
    // } else {}
  }

  void setLabelOnQuestionNumber() {
    if (testMCQList[selectedIndex.value].type == 1 ||
        testMCQList[selectedIndex.value].type == 2) {
      List trueAnswers = [];

      for (int i = 0;
          i < testMCQList[selectedIndex.value].getOption!.length;
          i++) {
        if (testMCQList[selectedIndex.value].getOption![i].isTrue == 1) {
          trueAnswers.add(
              testMCQList[selectedIndex.value].getOption![i].id.toString());
        }
      }

      trueAnswers.sort((a, b) => a.length.compareTo(b.length));
      testMCQList[selectedIndex.value]
          .userSelectedAnswerApp!
          // .sort((a, b) => a.length.compareTo(b.length));
          .sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      if (listEquals(trueAnswers,
          testMCQList[selectedIndex.value].userSelectedAnswerApp!)) {
        testMCQList[selectedIndex.value].isAnswerTrue = 1;
        // Vibration.vibrate(duration: 500, amplitude: 128);
      } else {
        testMCQList[selectedIndex.value].isAnswerTrue = 0;
        // Vibration.vibrate(pattern: [250, 250, 250, 250], intensities: [1, 128]);
      }
    } else if (testMCQList[selectedIndex.value].type == 3) {
      if (testMCQList[selectedIndex.value].userSelectedAnswerApp!.isNotEmpty &&
          (double.parse(testMCQList[selectedIndex.value]
                  .userSelectedAnswerApp![0]
                  .toString()) >=
              double.parse(testMCQList[selectedIndex.value]
                  .getOption![0]
                  .optionMin
                  .toString())) &&
          (double.parse(testMCQList[selectedIndex.value]
                  .userSelectedAnswerApp![0]
                  .toString()) <=
              double.parse(testMCQList[selectedIndex.value]
                  .getOption![0]
                  .optionMax
                  .toString()))) {
        testMCQList[selectedIndex.value].isAnswerTrue = 1;
        // Vibration.vibrate(duration: 500, amplitude: 128);
      } else if (testMCQList[selectedIndex.value]
              .userSelectedAnswerApp!
              .isNotEmpty &&
          ((double.parse(testMCQList[selectedIndex.value]
                      .userSelectedAnswerApp![0]
                      .toString()) <
                  double.parse(testMCQList[selectedIndex.value]
                      .getOption![0]
                      .optionMin
                      .toString())) ||
              (double.parse(testMCQList[selectedIndex.value]
                      .userSelectedAnswerApp![0]
                      .toString()) >
                  double.parse(testMCQList[selectedIndex.value]
                      .getOption![0]
                      .optionMax
                      .toString())))) {
        testMCQList[selectedIndex.value].isAnswerTrue = 0;
        // Vibration.vibrate(pattern: [250, 250, 250, 250], intensities: [1, 128]);
      }
    }
  }

  void checkReport(String type, String comments) {
    final isValid = reportFormKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      getTestReported(testMCQList[selectedIndex.value].id.toString(),
          comments + ", " + reportCommentController!.text);
    }
  }

  void getTestMCQList(
    bool isShowLoading,
    String topicid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      testMCQList.clear();

      testTechnicalList.clear();
      testGeneralList.clear();

      TestMcqModel? model =
          await RemoteServices.instance.getTestMCQList(topicid);

      List<TestMcqData> practiceMCQListTemp = <TestMcqData>[];

      practiceMCQListTemp.addAll(model!.data!);

      start!.value = practiceMCQListTemp[0].remainingTime!;

      for (int i = 0; i < practiceMCQListTemp.length; i++) {
        if (practiceMCQListTemp[i].type == 1 ||
            practiceMCQListTemp[i].type == 2) {
          List trueAnswers = [];

          for (int j = 0; j < practiceMCQListTemp[i].getOption!.length; j++) {
            if (practiceMCQListTemp[i].getOption![j].isTrue == 1) {
              trueAnswers
                  .add(practiceMCQListTemp[i].getOption![j].id.toString());
            }
          }

          trueAnswers.sort((a, b) => a.length.compareTo(b.length));
          practiceMCQListTemp[i]
              .userSelectedAnswerApp!
              .sort((a, b) => int.parse(a).compareTo(int.parse(b)));

          practiceMCQListTemp[i]
              .userTempAnswer!
              .addAll(practiceMCQListTemp[i].userSelectedAnswerApp!);

          if (listEquals(
              trueAnswers, practiceMCQListTemp[i].userSelectedAnswerApp!)) {
            practiceMCQListTemp[i].isAnswerTrue = 1;
            // break;
          } else {
            practiceMCQListTemp[i].isAnswerTrue = 0;
            // break;
          }
        } else if (practiceMCQListTemp[i].type == 3) {
          if (practiceMCQListTemp[i].userSelectedAnswerApp!.isNotEmpty &&
              (double.parse(practiceMCQListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) >=
                  double.parse(practiceMCQListTemp[i]
                      .getOption![0]
                      .optionMin
                      .toString())) &&
              (double.parse(practiceMCQListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) <=
                  double.parse(practiceMCQListTemp[i]
                      .getOption![0]
                      .optionMax
                      .toString()))) {
            practiceMCQListTemp[i].isAnswerTrue = 1;
          } else if (practiceMCQListTemp[i].userSelectedAnswerApp!.isNotEmpty &&
              ((double.parse(practiceMCQListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) <
                      double.parse(practiceMCQListTemp[i]
                          .getOption![0]
                          .optionMin
                          .toString())) ||
                  (double.parse(practiceMCQListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) >
                      double.parse(practiceMCQListTemp[i]
                          .getOption![0]
                          .optionMax
                          .toString())))) {
            practiceMCQListTemp[i].isAnswerTrue = 0;
          }
        }

        if (practiceMCQListTemp[i].question_type == 1) {
          testTechnicalList.add(practiceMCQListTemp[i]);
        } else {
          testGeneralList.add(practiceMCQListTemp[i]);
        }
      }

      if (testTypeSelected.value == 1) {
        testMCQList.addAll(testTechnicalList);
      } else {
        testMCQList.addAll(testGeneralList);
      }
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getTestMCQSolutionList(
    bool isShowLoading,
    String topicid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      testMCQList.clear();
      testTechnicalList.clear();
      testGeneralList.clear();

      TestMcqModel? model =
          await RemoteServices.instance.getTestMCQSolutionList(topicid);

      List<TestMcqData> practiceMCQListTemp = <TestMcqData>[];

      practiceMCQListTemp.addAll(model!.data!);
      start!.value = practiceMCQListTemp[0].remainingTime!;
      for (int i = 0; i < practiceMCQListTemp.length; i++) {
        if (practiceMCQListTemp[i].type == 1 ||
            practiceMCQListTemp[i].type == 2) {
          List trueAnswers = [];

          for (int j = 0; j < practiceMCQListTemp[i].getOption!.length; j++) {
            if (practiceMCQListTemp[i].getOption![j].isTrue == 1) {
              trueAnswers
                  .add(practiceMCQListTemp[i].getOption![j].id.toString());
            }
          }

          trueAnswers.sort((a, b) => a.length.compareTo(b.length));
          practiceMCQListTemp[i]
              .userSelectedAnswerApp!
              .sort((a, b) => int.parse(a).compareTo(int.parse(b)));

          if (listEquals(
              trueAnswers, practiceMCQListTemp[i].userSelectedAnswerApp!)) {
            practiceMCQListTemp[i].isAnswerTrue = 1;
            // break;
          } else {
            practiceMCQListTemp[i].isAnswerTrue = 0;
            // break;
          }
        } else if (practiceMCQListTemp[i].type == 3) {
          if (practiceMCQListTemp[i].userSelectedAnswerApp!.isNotEmpty &&
              (double.parse(practiceMCQListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) >=
                  double.parse(practiceMCQListTemp[i]
                      .getOption![0]
                      .optionMin
                      .toString())) &&
              (double.parse(practiceMCQListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) <=
                  double.parse(practiceMCQListTemp[i]
                      .getOption![0]
                      .optionMax
                      .toString()))) {
            practiceMCQListTemp[i].isAnswerTrue = 1;
          } else if (practiceMCQListTemp[i].userSelectedAnswerApp!.isNotEmpty &&
              ((double.parse(practiceMCQListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) <
                      double.parse(practiceMCQListTemp[i]
                          .getOption![0]
                          .optionMin
                          .toString())) ||
                  (double.parse(practiceMCQListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) >
                      double.parse(practiceMCQListTemp[i]
                          .getOption![0]
                          .optionMax
                          .toString())))) {
            practiceMCQListTemp[i].isAnswerTrue = 0;
          }
        }

        if (practiceMCQListTemp[i].question_type == 1) {
          testTechnicalList.add(practiceMCQListTemp[i]);
        } else {
          testGeneralList.add(practiceMCQListTemp[i]);
        }
      }

      if (testTypeSelected.value == 1) {
        testMCQList.addAll(testTechnicalList);
      } else {
        testMCQList.addAll(testGeneralList);
      }
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getTestBookmarked(String practiceid, bool isList, int index) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.getTestBookmarked(practiceid);

      if (model!.status!) {
        if (isList) {
          if (testMCQList[index].isBookmark == 1) {
            testMCQList[index].isBookmark = 0;
            drawerController.sink.add('N/A');
          } else {
            testMCQList[index].isBookmark = 1;
            drawerController.sink.add('N/A');
          }
        } else {
          if (testMCQList[selectedIndex.value].isBookmark == 1) {
            testMCQList[selectedIndex.value].isBookmark = 0;
          } else {
            testMCQList[selectedIndex.value].isBookmark = 1;
          }
          drawerController.sink.add('N/A');
        }
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getTestReported(
    String practiceid,
    String comment,
  ) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.getTestReported(practiceid, comment);

      if (model!.status!) {
        showFlutterToast(model.message!);
        Get.back();
      }
      reportCommentController!.text = '';
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getTestMarkReview(
    String practiceid,
    String markreview,
  ) async {
    try {
      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance
          .getTestMarkReview(practiceid, markreview);
      if (model!.status!) {
        testMCQList[selectedIndex.value].markReview = 1;
      }

      if ((testMCQList.length - 1) <= selectedIndex.value) {
        // String testId = GetIt.I<Map<String, dynamic>>(
        //     instanceName: "selected_test")['testId'];
        // getWholeTestSubmittedBefore(testId, 'MARK');
        selectedIndex.value = 0;
      } else {
        if (isCorrect.value ||
            isSaved.value ||
            isInCorrect.value ||
            isUnattempted.value ||
            isAnswered.value ||
            isMarkReviewNoAnswer.value ||
            isMarkReviewWithAnswer.value) {
          for (int i = 0; i < testMCQList.length; i++) {
            if (i > selectedIndex.value && testMCQList[i].isVisible == true) {
              selectedIndex.value = i;
              break;
            }
          }
        } else {
          selectedIndex.value = selectedIndex.value + 1;
        }
        startStopWatch();
      }
    } finally {
      isLoading(false);
    }
  }

  void getTestClearAnswer(
    String practiceid,
  ) async {
    try {
      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.getTestClearAnswer(practiceid);
      testMCQList[selectedIndex.value].userTempAnswer!.clear();
      testMCQList[selectedIndex.value].userSelectedAnswerApp!.clear();
    } finally {
      isLoading(false);
    }
  }

  void getSingleTestSubmitted(
    String practiceid,
    String questionType,
    List<String> answerOption,
    String takenTimeApp,
    String isSkip,
  ) async {
    try {
      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance
          .getSingleTestSubmitted(
              practiceid, questionType, answerOption, takenTimeApp, isSkip);

      if ((testMCQList.length - 1) <= selectedIndex.value) {
        // String testId = GetIt.I<Map<String, dynamic>>(
        //     instanceName: "selected_test")['testId'];
        // getWholeTestSubmittedBefore(testId, 'SUBMIT');
        selectedIndex.value = 0;
      } else {
        if (isCorrect.value ||
            isSaved.value ||
            isInCorrect.value ||
            isUnattempted.value ||
            isAnswered.value ||
            isMarkReviewNoAnswer.value ||
            isMarkReviewWithAnswer.value) {
          for (int i = 0; i < testMCQList.length; i++) {
            if (i > selectedIndex.value && testMCQList[i].isVisible == true) {
              selectedIndex.value = i;
              break;
            }
          }
        } else {
          selectedIndex.value = selectedIndex.value + 1;
        }
        startStopWatch();
      }
    } finally {
      isLoading(false);
    }
  }

  void getPracticeTopicLeader(
      bool isShowLoading, String topicid, int page, String type) async {
    try {
      if (isShowLoading) {
        showLoader();
        practiceTopicLeaderBoardList.clear();
        top3TopicLeaderBoardList.clear();
      }

      isLoading(true);
      PracticeTopicLeaderBoardModel? model;

      model =
          await RemoteServices.instance.getPracticeTopicLeader(topicid, page);

      practiceTopicLeaderBoardList.addAll(model!.data!);
      top3TopicLeaderBoardList.addAll(model.topThreeUser!);

      if (model.isCurrentUserInArray == 0) {
        practiceTopicLeaderBoardList.add(model.currentUser!);
      }
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getWholeTestSubmittedBefore(String testid, String from) async {
    try {
      isLoading(true);

      BeforeSubmitModel? model =
          await RemoteServices.instance.getWholeTestSubmittedBefore(testid);

      beforeSubmitData = model!.data;
      refreshStreamController.sink.add(from);

      // beforeDialog();
    } finally {
      isLoading(false);
    }
  }

  void getWholeTestSubmittedFinal(
    String testid,
  ) async {
    try {
      isLoading(true);

      BeforeSubmitModel? model =
          await RemoteServices.instance.getWholeTestSubmittedFinal(testid);

      if (model!.status!) {
        getItRegister<Map<String, dynamic>>({
          'scoreFrom': 'TEST',
        }, name: "selected_score");
        Get.toNamed(AppRoutes.scorecard);
      }
    } finally {
      isLoading(false);
    }
  }

  void getScoreCard(
    String testid,
  ) async {
    try {
      showLoader();
      isLoading(true);

      ScoreCardModel? model =
          await RemoteServices.instance.getScoreCard(testid);
      scoreCardModel.value = model!;
    } finally {
      hideLoader();
      isLoading(false);
    }
  }

  void getQuestionWiseList(
    String testid,
  ) async {
    try {
      showLoader();

      isLoading(true);

      questionWiseList.clear();

      QuestionWiseModel? model =
          await RemoteServices.instance.getQuestionWiseList(testid);
      questionWiseList.addAll(model!.data!);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getTopicWise(
    String testid,
  ) async {
    try {
      showLoader();

      isLoading(true);

      TopicWiseModel? model =
          await RemoteServices.instance.getTopicWise(testid);
      topicWiseData = model!.data;
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getCompetitive(
    String testid,
  ) async {
    try {
      showLoader();
      competitiveStudentList.clear();
      isLoading(true);

      CompetitiveModel? model =
          await RemoteServices.instance.getCompetitive(testid);
      currentUserData = model!.currentUserData;

      competitiveStudentList.addAll(model.topStudents!);
    } finally {
      hideLoader();
      isLoading(false);
    }
  }
}
