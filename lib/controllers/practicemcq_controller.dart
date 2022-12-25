import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/practicemcq_model.dart';
import 'package:flutter_practicekiya/models/topicanaysis_model.dart';
import 'package:flutter_practicekiya/utils/staticarrays.dart';

import 'package:get/get.dart';

import 'package:get_it/get_it.dart';
import 'package:vibration/vibration.dart';

import '../models/idstringname_model.dart';
import '../models/login_model.dart';
import '../models/practicetopicleaderboard_model.dart';
import '../services/remote_services.dart';

import '../utils/functions.dart';
import '../utils/preferences.dart';
import '../utils/theme.dart';

class PracticeMCQController extends GetxController {
  Prefs prefs = Prefs.prefs;
  LoginModel? loginModel;
  String userID = '';

  var isLoading = true.obs;

  RxList<PracticeMCQData> practiceMCQList = <PracticeMCQData>[].obs;
  // List<PracticeMCQData>.empty(growable: true).obs;

  RxInt selectedIndex = 0.obs;

  TextEditingController? numericAnswerController;

  RxBool showGif = false.obs;
  final count = 0.obs;

  // RxInt checkAnswer = 0.obs;

  TextEditingController? reportCommentController;
  final GlobalKey<FormState> reportFormKey = GlobalKey<FormState>();

  String? topicId;

  List<CurrentUser> practiceTopicLeaderBoardList =
      List<CurrentUser>.empty(growable: true).obs;
  RxString selectedTopicsTab = '1'.obs;
  CurrentUser? selfPracticeTopicLeaderBoardData;
  List<CurrentUser> top3TopicLeaderBoardList =
      List<CurrentUser>.empty(growable: true).obs;

  ScrollController practiceTopicLeaderBoardScrollController =
      ScrollController();
  int leaderPage = 1;

  ScrollController practiceTopicBookmarkScrollController = ScrollController();
  int topicBookmarkPage = 1;
  RxList<PracticeMCQData> practiceTopicBookmarkList = <PracticeMCQData>[].obs;

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

  RxBool correct = false.obs;
  RxBool incorrect = false.obs;
  RxBool saved = false.obs;
  RxBool unattempted = false.obs;

  RxBool showQuestion = true.obs;

  TopicAnalysisModel? topicAnalysisModel = TopicAnalysisModel();

  RxMap<String, double> dataMapChapterwise = <String, double>{
    "Flutter": 5,
  }.obs;

  RxMap<String, double> dataMapQueBreakdown = <String, double>{
    "Flutter": 5,
  }.obs;

  RxMap<String, double> dataMapTimereakdown = <String, double>{
    "Flutter": 5,
  }.obs;

  StreamController drawerControllerPractice = StreamController.broadcast();
  StreamController drawerControllerAlert = StreamController.broadcast();

  RxList<IdStringNameModel> alertList = StaticArrays.getAlertList().obs;
  RxBool isOtherSelected = false.obs;

  final colorList = <Color>[
    kDarkBlueColor,
    kChartOrangeColor,
    kSecondaryColor,
  ];

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
      print(newTick);
      if (practiceMCQList.isNotEmpty) {
        // practiceMCQList[selectedIndex.value].takenTimeApp = newTick;
        practiceMCQList[selectedIndex.value].takenTimeApp = newTick;
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
    isCorrect.value = correct.value;
    isSaved.value = saved.value;
    isInCorrect.value = incorrect.value;
    isUnattempted.value = unattempted.value;

    for (int i = 0; i < practiceMCQList.length; i++) {
      if (isCorrect.value ||
          isSaved.value ||
          isInCorrect.value ||
          isUnattempted.value) {
        print('URVI 1');
        if (isCorrect.value && practiceMCQList[i].isAnswerTrue == 1) {
          print('URVI 2');
          selectedIndex.value = i;
          break;
        } else if (isSaved.value &&
            (practiceMCQList[i].isAnswerTrue == 0 &&
                practiceMCQList[i].userSelectedAnswerApp!.isEmpty &&
                practiceMCQList[i].isBookmark == 1)) {
          print('URVI 3');
          selectedIndex.value = i;
          break;
        } else if (isInCorrect.value &&
            (practiceMCQList[i].isAnswerTrue == 0 &&
                practiceMCQList[i].userSelectedAnswerApp!.isNotEmpty)) {
          print('URVI 4');
          selectedIndex.value = i;
          break;
        } else if (isUnattempted.value &&
            (practiceMCQList[i].isAnswerTrue == 0 &&
                practiceMCQList[i].userSelectedAnswerApp!.isEmpty &&
                practiceMCQList[i].isSkip == 0 &&
                practiceMCQList[i].isBookmark == 0)) {
          print('URVI 5');
          selectedIndex.value = i;
          break;
        } else {
          selectedIndex.value = i;
        }
      } else {
        print('URVI 6');
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

    print('openDrawer 123' + incorrect.value.toString());
  }

  void clearFilter() {
    isCorrect.value = false;
    isSaved.value = false;
    isInCorrect.value = false;
    isUnattempted.value = false;

    print('clearFilter 123' + isInCorrect.value.toString());
  }

  @override
  void onInit() {
    super.onInit();
    getPrefs();
    numericAnswerController = TextEditingController(text: '');
    reportCommentController = TextEditingController(text: '');

    // addTopicLeaderBoardItems();
    addPracticeTopicBookmarkItems();
  }

  void changeTopicType(RxString topicTabId, String type) {
    selectedTopicsTab.value = topicTabId.value;
    topicId = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_topic")['topicId'];
    if (selectedTopicsTab.value == '1') {
      if (type == '1') {
        getTopicAnalysis(topicId!);
      } else if (type == '3') {
        getPYQTopicAnalysis(topicId!);
      }
    } else if (selectedTopicsTab.value == '2') {
      topicBookmarkPage = 1;
      getTopicBookmarkList(true, topicId!, topicBookmarkPage);
    } else if (selectedTopicsTab.value == '3') {
      leaderPage = 1;
      // if (type == '1') {
      getPracticeTopicLeader(true, topicId!, leaderPage, type);
      // } else if (type == '3') {
      //   getPYQTopicLeader(true, topicId!, leaderPage);
      // }
    }
  }

  addTopicLeaderBoardItems(String type) async {
    practiceTopicLeaderBoardScrollController.addListener(() {
      if (practiceTopicLeaderBoardScrollController.position.maxScrollExtent ==
          practiceTopicLeaderBoardScrollController.position.pixels) {
        leaderPage++;
        getPracticeTopicLeader(false, topicId!, leaderPage, type);
      }
    });
  }

  addPracticeTopicBookmarkItems() async {
    practiceTopicBookmarkScrollController.addListener(() {
      if (practiceTopicBookmarkScrollController.position.maxScrollExtent ==
          practiceTopicBookmarkScrollController.position.pixels) {
        topicBookmarkPage++;
        getTopicBookmarkList(false, topicId!, topicBookmarkPage);
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

  void previousQuestion() {
    if (selectedIndex.value == 0) {
      showSnackBar("Practice MCQ Test", "No previous question");
    } else {
      if (isCorrect.value ||
          isSaved.value ||
          isInCorrect.value ||
          isUnattempted.value) {
        for (int i = practiceMCQList.length - 1; i >= 0; i--) {
          if (i < selectedIndex.value && practiceMCQList[i].isVisible == true) {
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
    if ((practiceMCQList.length - 1) <= selectedIndex.value) {
      //call all submit function
      practiceMCQList[selectedIndex.value].isSkip = 1;
      if (practiceMCQList[selectedIndex.value].userSelectedAnswerApp!.isEmpty) {
        if (type == '1') {
          getPracticeSubmitted(
              practiceMCQList[selectedIndex.value].id.toString(),
              practiceMCQList[selectedIndex.value].type.toString(),
              practiceMCQList[selectedIndex.value].userSelectedAnswerApp!,
              practiceMCQList[selectedIndex.value].takenTimeApp.toString(),
              '1',
              (selectedIndex.value + 1) == practiceMCQList.length ? '1' : '0',
              practiceMCQList[selectedIndex.value].subjectId.toString(),
              practiceMCQList[selectedIndex.value].chapterId.toString());
        } else if (type == '3') {
          getPYQSubmitted(
              practiceMCQList[selectedIndex.value].id.toString(),
              practiceMCQList[selectedIndex.value].type.toString(),
              practiceMCQList[selectedIndex.value].userSelectedAnswerApp!,
              practiceMCQList[selectedIndex.value].takenTimeApp.toString(),
              '1',
              (selectedIndex.value + 1) == practiceMCQList.length ? '1' : '0',
              practiceMCQList[selectedIndex.value].subjectId.toString(),
              practiceMCQList[selectedIndex.value].chapterId.toString());
        }
      }
    } else {
      practiceMCQList[selectedIndex.value].isSkip = 1;
      if (practiceMCQList[selectedIndex.value].userSelectedAnswerApp!.isEmpty) {
        if (type == '1') {
          getPracticeSubmitted(
              practiceMCQList[selectedIndex.value].id.toString(),
              practiceMCQList[selectedIndex.value].type.toString(),
              practiceMCQList[selectedIndex.value].userSelectedAnswerApp!,
              practiceMCQList[selectedIndex.value].takenTimeApp.toString(),
              '1',
              (selectedIndex.value + 1) == practiceMCQList.length ? '1' : '0',
              practiceMCQList[selectedIndex.value].subjectId.toString(),
              practiceMCQList[selectedIndex.value].chapterId.toString());
        } else if (type == '3') {
          getPYQSubmitted(
              practiceMCQList[selectedIndex.value].id.toString(),
              practiceMCQList[selectedIndex.value].type.toString(),
              practiceMCQList[selectedIndex.value].userSelectedAnswerApp!,
              practiceMCQList[selectedIndex.value].takenTimeApp.toString(),
              '1',
              (selectedIndex.value + 1) == practiceMCQList.length ? '1' : '0',
              practiceMCQList[selectedIndex.value].subjectId.toString(),
              practiceMCQList[selectedIndex.value].chapterId.toString());
        }
      }

      if (isCorrect.value ||
          isSaved.value ||
          isInCorrect.value ||
          isUnattempted.value) {
        for (int i = 0; i < practiceMCQList.length; i++) {
          if (i > selectedIndex.value && practiceMCQList[i].isVisible == true) {
            selectedIndex.value = i;
            break;
          }
        }
      } else {
        selectedIndex.value = selectedIndex.value + 1;
      }

      setNumericAnswer();
    }
    resetStopWatch();
    startStopWatch();
  }

  void setNumericAnswer() {
    numericAnswerController!.text =
        practiceMCQList[selectedIndex.value].userSelectedAnswerApp!.isNotEmpty
            ? (practiceMCQList[selectedIndex.value].userSelectedAnswerApp![0])
            : practiceMCQList[selectedIndex.value].userTempAnswer!.isNotEmpty
                ? practiceMCQList[selectedIndex.value].userTempAnswer![0]
                : '';

    numericAnswerController!.selection = TextSelection.fromPosition(
        TextPosition(offset: numericAnswerController!.text.toString().length));
  }

  void submitAnswer(String type) {
    if (practiceMCQList[selectedIndex.value].userTempAnswer!.isNotEmpty) {
      practiceMCQList[selectedIndex.value]
          .userSelectedAnswerApp!
          .addAll(practiceMCQList[selectedIndex.value].userTempAnswer!);

      practiceMCQList[selectedIndex.value].userTempAnswer!.clear();

      showGif.value = true;

      setLabelOnQuestionNumber();

      practiceMCQList[selectedIndex.value].takenTime =
          practiceMCQList[selectedIndex.value].takenTimeApp!;

      resetStopWatch();

      if (type == '1') {
        getPracticeSubmitted(
            practiceMCQList[selectedIndex.value].id.toString(),
            practiceMCQList[selectedIndex.value].type.toString(),
            practiceMCQList[selectedIndex.value].userSelectedAnswerApp!,
            practiceMCQList[selectedIndex.value].takenTime.toString(),
            '0',
            (selectedIndex.value + 1) == practiceMCQList.length ? '1' : '0',
            practiceMCQList[selectedIndex.value].subjectId.toString(),
            practiceMCQList[selectedIndex.value].chapterId.toString());
      } else if (type == '3') {
        getPYQSubmitted(
            practiceMCQList[selectedIndex.value].id.toString(),
            practiceMCQList[selectedIndex.value].type.toString(),
            practiceMCQList[selectedIndex.value].userSelectedAnswerApp!,
            practiceMCQList[selectedIndex.value].takenTime.toString(),
            '0',
            (selectedIndex.value + 1) == practiceMCQList.length ? '1' : '0',
            practiceMCQList[selectedIndex.value].subjectId.toString(),
            practiceMCQList[selectedIndex.value].chapterId.toString());
      }

      // Future.delayed(const Duration(seconds: 2), () {
      //   showGif.value = false;
      // });

    } else {
      showSnackBar("Practice MCQ Test", "Please select/write answer");
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

  void onSelectionOfOption(PracticeMCQData data, int index,
      GetPracticeOption options, String optionid, int isSelected, String type) {
    if (practiceMCQList[selectedIndex.value].userSelectedAnswerApp!.isEmpty) {
      if (data.type == 1) {
        data.userTempAnswer!.clear();
        options.isUserSelected = 0;
        data.userTempAnswer!.add(optionid.toString());

        submitAnswer(type);
      } else if (data.type == 2) {
        if (isSelected == 0) {
          options.isUserSelected = 1;
          data.userTempAnswer!.add(optionid.toString());
        } else {
          options.isUserSelected = 0;
          data.userTempAnswer!.remove(optionid.toString());
        }
      } else if (data.type == 3) {}

      data.getOption![index] = options;

      practiceMCQList[selectedIndex.value] = data;
    } else {
      // showSnackBar(
      //     "Practice MCQ Test", "You have already submitted the answer");
    }
  }

  void setLabelOnQuestionNumber() {
    if (practiceMCQList[selectedIndex.value].type == 1 ||
        practiceMCQList[selectedIndex.value].type == 2) {
      List trueAnswers = [];

      for (int i = 0;
          i < practiceMCQList[selectedIndex.value].getOption!.length;
          i++) {
        if (practiceMCQList[selectedIndex.value].getOption![i].isTrue == 1) {
          trueAnswers.add(
              practiceMCQList[selectedIndex.value].getOption![i].id.toString());
        }
      }

      trueAnswers.sort((a, b) => a.length.compareTo(b.length));
      practiceMCQList[selectedIndex.value]
          .userSelectedAnswerApp!
          // .sort((a, b) => a.length.compareTo(b.length));
          .sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      if (listEquals(trueAnswers,
          practiceMCQList[selectedIndex.value].userSelectedAnswerApp!)) {
        practiceMCQList[selectedIndex.value].isAnswerTrue = 1;
        Vibration.vibrate(duration: 500, amplitude: 128);
      } else {
        practiceMCQList[selectedIndex.value].isAnswerTrue = 0;
        Vibration.vibrate(pattern: [250, 250, 250, 250], intensities: [1, 128]);
      }
    } else if (practiceMCQList[selectedIndex.value].type == 3) {
      if (practiceMCQList[selectedIndex.value]
              .userSelectedAnswerApp!
              .isNotEmpty &&
          (double.parse(practiceMCQList[selectedIndex.value]
                  .userSelectedAnswerApp![0]
                  .toString()) >=
              double.parse(practiceMCQList[selectedIndex.value]
                  .getOption![0]
                  .optionMin
                  .toString())) &&
          (double.parse(practiceMCQList[selectedIndex.value]
                  .userSelectedAnswerApp![0]
                  .toString()) <=
              double.parse(practiceMCQList[selectedIndex.value]
                  .getOption![0]
                  .optionMax
                  .toString()))) {
        practiceMCQList[selectedIndex.value].isAnswerTrue = 1;
        Vibration.vibrate(duration: 500, amplitude: 128);
      } else if (practiceMCQList[selectedIndex.value]
              .userSelectedAnswerApp!
              .isNotEmpty &&
          ((double.parse(practiceMCQList[selectedIndex.value]
                      .userSelectedAnswerApp![0]
                      .toString()) <
                  double.parse(practiceMCQList[selectedIndex.value]
                      .getOption![0]
                      .optionMin
                      .toString())) ||
              (double.parse(practiceMCQList[selectedIndex.value]
                      .userSelectedAnswerApp![0]
                      .toString()) >
                  double.parse(practiceMCQList[selectedIndex.value]
                      .getOption![0]
                      .optionMax
                      .toString())))) {
        practiceMCQList[selectedIndex.value].isAnswerTrue = 0;
        Vibration.vibrate(pattern: [250, 250, 250, 250], intensities: [1, 128]);
      }
    }
  }

  void checkReport(String type, String comments) {
    final isValid = reportFormKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      if (type == '1') {
        getPracticeReported(practiceMCQList[selectedIndex.value].id.toString(),
            comments + ", " + reportCommentController!.text);
      } else if (type == '3') {
        getPYQReported(practiceMCQList[selectedIndex.value].id.toString(),
            comments + ", " + reportCommentController!.text);
      }
    }
  }

  void getPracticeMCQList(
    bool isShowLoading,
    String topicid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      practiceMCQList.clear();

      PracticeMcqModel? model =
          await RemoteServices.instance.getPracticeMCQList(topicid);

      List<PracticeMCQData> practiceMCQListTemp = <PracticeMCQData>[];

      practiceMCQListTemp.addAll(model!.data!);

      for (int i = 0; i < practiceMCQListTemp.length; i++) {
        if (practiceMCQListTemp[i].type == 1 ||
            practiceMCQListTemp[i].type == 2) {
          List trueAnswers = [];

          print('error index --> ' + i.toString());
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
        practiceMCQList.add(practiceMCQListTemp[i]);
      }
      // practiceMCQList.addAll(practiceMCQListTemp);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getPYQMCQList(
    bool isShowLoading,
    String topicid,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      practiceMCQList.clear();

      PracticeMcqModel? model =
          await RemoteServices.instance.getPYQMCQList(topicid);

      List<PracticeMCQData> practiceMCQListTemp = <PracticeMCQData>[];

      practiceMCQListTemp.addAll(model!.data!);

      for (int i = 0; i < practiceMCQListTemp.length; i++) {
        if (practiceMCQListTemp[i].type == 1 ||
            practiceMCQListTemp[i].type == 2) {
          List trueAnswers = [];

          print('error index --> ' + i.toString());
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
        practiceMCQList.add(practiceMCQListTemp[i]);
      }
      // practiceMCQList.addAll(practiceMCQListTemp);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getPracticeBookmarked(String practiceid, bool isList, int index) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.getPracticeBookmarked(practiceid);

      if (model!.status!) {
        if (isList) {
          if (practiceMCQList[index].isBookmark == 1) {
            practiceMCQList[index].isBookmark = 0;
            drawerControllerPractice.sink.add('N/A');
          } else {
            practiceMCQList[index].isBookmark = 1;
            drawerControllerPractice.sink.add('N/A');
          }
        } else {
          if (practiceMCQList[selectedIndex.value].isBookmark == 1) {
            practiceMCQList[selectedIndex.value].isBookmark = 0;
          } else {
            practiceMCQList[selectedIndex.value].isBookmark = 1;
          }
          drawerControllerPractice.sink.add('N/A');
        }
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getPYQBookmarked(String practiceid, bool isList, int index) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.getPYQBookmarked(practiceid);

      if (model!.status!) {
        if (isList) {
          if (practiceMCQList[index].isBookmark == 1) {
            practiceMCQList[index].isBookmark = 0;
            drawerControllerPractice.sink.add('N/A');
          } else {
            practiceMCQList[index].isBookmark = 1;
            drawerControllerPractice.sink.add('N/A');
          }
        } else {
          if (practiceMCQList[selectedIndex.value].isBookmark == 1) {
            practiceMCQList[selectedIndex.value].isBookmark = 0;
          } else {
            practiceMCQList[selectedIndex.value].isBookmark = 1;
          }
          drawerControllerPractice.sink.add('N/A');
        }
      }
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getPracticeReported(
    String practiceid,
    String comment,
  ) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance
          .getPracticeReported(practiceid, comment.replaceAll('Other,', ''));

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

  void getPYQReported(
    String practiceid,
    String comment,
  ) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance
          .getPYQReported(practiceid, comment.replaceAll('Other,', ''));

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

  void getPracticeSubmitted(
      String practiceid,
      String questionType,
      List<String> answerOption,
      String takenTimeApp,
      String isSkip,
      String isTopicCompleted,
      String subjectid,
      String chapterid) async {
    try {
      isLoading(true);

      print('takenTimeApp->' + takenTimeApp);

      MainCategoryModel? model = await RemoteServices.instance
          .getPracticeSubmitted(practiceid, questionType, answerOption,
              takenTimeApp, isSkip, isTopicCompleted, subjectid, chapterid);
    } finally {
      isLoading(false);
    }
  }

  void getPYQSubmitted(
      String practiceid,
      String questionType,
      List<String> answerOption,
      String takenTimeApp,
      String isSkip,
      String isTopicCompleted,
      String subjectid,
      String chapterid) async {
    try {
      isLoading(true);

      MainCategoryModel? model = await RemoteServices.instance.getPYQSubmitted(
          practiceid,
          questionType,
          answerOption,
          takenTimeApp,
          isSkip,
          isTopicCompleted,
          subjectid,
          chapterid);
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

      if (type == '1') {
        model =
            await RemoteServices.instance.getPracticeTopicLeader(topicid, page);
      } else if (type == '3') {
        model = await RemoteServices.instance.getPYQTopicLeader(topicid, page);
      }
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

  void getTopicBookmarkList(
    bool isShowLoading,
    String topicid,
    int page,
  ) async {
    try {
      if (isShowLoading) {
        showLoader();
        practiceTopicBookmarkList.clear();
      }

      isLoading(true);
      PracticeMcqModel? model =
          await RemoteServices.instance.getTopicBookmarkList(topicid, page);

      List<PracticeMCQData> practiceTopictBookmarkListTemp =
          <PracticeMCQData>[];

      practiceTopictBookmarkListTemp.addAll(model!.data!);

      for (int i = 0; i < practiceTopictBookmarkListTemp.length; i++) {
        if (practiceTopictBookmarkListTemp[i].type == 1 ||
            practiceTopictBookmarkListTemp[i].type == 2) {
          List trueAnswers = [];

          for (int j = 0;
              j < practiceTopictBookmarkListTemp[i].getOption!.length;
              j++) {
            if (practiceTopictBookmarkListTemp[i].getOption![j].isTrue == 1) {
              trueAnswers.add(practiceTopictBookmarkListTemp[i]
                  .getOption![j]
                  .id
                  .toString());
            }
          }

          trueAnswers.sort((a, b) => a.length.compareTo(b.length));
          practiceTopictBookmarkListTemp[i]
              .userSelectedAnswerApp!
              .sort((a, b) => int.parse(a).compareTo(int.parse(b)));

          if (listEquals(trueAnswers,
              practiceTopictBookmarkListTemp[i].userSelectedAnswerApp!)) {
            practiceTopictBookmarkListTemp[i].isAnswerTrue = 1;
          } else {
            practiceTopictBookmarkListTemp[i].isAnswerTrue = 0;
          }
        } else if (practiceTopictBookmarkListTemp[i].type == 3) {
          if (practiceTopictBookmarkListTemp[i]
                  .userSelectedAnswerApp!
                  .isNotEmpty &&
              (double.parse(practiceTopictBookmarkListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) >=
                  double.parse(practiceTopictBookmarkListTemp[i]
                      .getOption![0]
                      .optionMin
                      .toString())) &&
              (double.parse(practiceTopictBookmarkListTemp[i]
                      .userSelectedAnswerApp![0]
                      .toString()) <=
                  double.parse(practiceTopictBookmarkListTemp[i]
                      .getOption![0]
                      .optionMax
                      .toString()))) {
            practiceTopictBookmarkListTemp[i].isAnswerTrue = 1;
          } else if (practiceTopictBookmarkListTemp[i]
                  .userSelectedAnswerApp!
                  .isNotEmpty &&
              ((double.parse(practiceTopictBookmarkListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) <
                      double.parse(practiceTopictBookmarkListTemp[i]
                          .getOption![0]
                          .optionMin
                          .toString())) ||
                  (double.parse(practiceTopictBookmarkListTemp[i]
                          .userSelectedAnswerApp![0]
                          .toString()) >
                      double.parse(practiceTopictBookmarkListTemp[i]
                          .getOption![0]
                          .optionMax
                          .toString())))) {
            practiceTopictBookmarkListTemp[i].isAnswerTrue = 0;
          }
        }
        practiceTopicBookmarkList.add(practiceTopictBookmarkListTemp[i]);
      }

      // practiceSubjectBookmarkList.addAll(model!.data!);

    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getTopicAnalysis(
    String topicid,
  ) async {
    try {
      showLoader();

      isLoading(true);

      TopicAnalysisModel? model =
          await RemoteServices.instance.getTopicAnalysis(topicid);

      topicAnalysisModel = model;
      // dataMapChapterwise = <String, double>{
      //   "Completed": model!.data!.totalCompletedTopic!.toDouble(),
      //   "Ongoing": model.data!.totalOngoingTopic!.toDouble(),
      //   "Unseen": model.data!.totalUnseenTopic!.toDouble(),
      // };

      dataMapChapterwise.value = <String, double>{
        "Correct": model!.data!.totalCorrect!.toDouble(),
        "Incorrect": model.data!.totalIncorrect!.toDouble(),
        "Unseen": (model.data!.totalQuestion!.toDouble() -
            model.data!.totalCorrect!.toDouble() -
            model.data!.totalIncorrect!.toDouble() -
            model.data!.totalSkip!.toDouble()),
      };

      dataMapQueBreakdown.value = <String, double>{
        "Correct": model.data!.totalCorrect!.toDouble(),
        "Incorrect": model.data!.totalIncorrect!.toDouble(),
        // "Skipped": model.data!.totalSkip!.toDouble(),
      };

      dataMapTimereakdown.value = <String, double>{
        "Correct": model.data!.totalCorrectTime!.toDouble(),
        "Incorrect": model.data!.totalIncorrectTime!.toDouble(),
        "Skipped": model.data!.totalSkipTime!.toDouble(),
      };
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getPYQTopicAnalysis(
    String topicid,
  ) async {
    try {
      showLoader();

      isLoading(true);

      TopicAnalysisModel? model =
          await RemoteServices.instance.getPYQTopicAnalysis(topicid);

      topicAnalysisModel = model;
      // dataMapChapterwise = <String, double>{
      //   "Completed": model!.data!.totalCompletedTopic!.toDouble(),
      //   "Ongoing": model.data!.totalOngoingTopic!.toDouble(),
      //   "Unseen": model.data!.totalUnseenTopic!.toDouble(),
      // };

      dataMapChapterwise.value = <String, double>{
        "Correct": model!.data!.totalCorrect!.toDouble(),
        "Incorrect": model.data!.totalIncorrect!.toDouble(),
        "Unseen": (model.data!.totalQuestion!.toDouble() -
            model.data!.totalCorrect!.toDouble() -
            model.data!.totalIncorrect!.toDouble() -
            model.data!.totalSkip!.toDouble()),
      };

      dataMapQueBreakdown.value = <String, double>{
        "Correct": model.data!.totalCorrect!.toDouble(),
        "Incorrect": model.data!.totalIncorrect!.toDouble(),
        // "Skipped": model.data!.totalSkip!.toDouble(),
      };

      dataMapTimereakdown.value = <String, double>{
        "Correct": model.data!.totalCorrectTime!.toDouble(),
        "Incorrect": model.data!.totalIncorrectTime!.toDouble(),
        "Skipped": model.data!.totalSkipTime!.toDouble(),
      };
    } finally {
      hideLoader();

      isLoading(false);
    }
  }
}
