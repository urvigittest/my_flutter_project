// To parse this JSON data, do
//
//     final testMcqModel = testMcqModelFromJson(jsonString);

import 'dart:convert';

TestMcqModel testMcqModelFromJson(String str) =>
    TestMcqModel.fromJson(json.decode(str));

String testMcqModelToJson(TestMcqModel data) => json.encode(data.toJson());

class TestMcqModel {
  TestMcqModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<TestMcqData>? data;

  factory TestMcqModel.fromJson(Map<String, dynamic> json) => TestMcqModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TestMcqData>.from(
                json["data"].map((x) => TestMcqData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TestMcqData {
  TestMcqData({
    this.id,
    this.topicId,
    this.chapterId,
    this.subjectId,
    this.question,
    this.type,
    this.solution,
    this.video,
    this.positiveMark,
    this.negetiveMark,
    this.isBookmark,
    this.isReport,
    this.markReview,
    this.remainingTime,
    this.isTrue,
    this.isSkip,
    this.takenTime,
    this.takenTimeApp,
    this.userSelectedAnswer,
    this.getTestAnswer,
    this.getOption,
    this.userSelectedAnswerApp,
    this.selectedOptionId,
    this.numericAnswer,
    this.isOpen,
    this.isVisible,
    this.isAnswerTrue,
    this.userTempAnswer,
    this.question_type,
  });

  int? id;
  int? topicId;
  int? chapterId;
  int? subjectId;
  String? question;
  int? type;
  String? solution;
  String? video;
  dynamic? positiveMark;
  dynamic? negetiveMark;
  int? isBookmark;
  int? isReport;
  int? markReview;
  int? remainingTime;
  int? isTrue;
  int? isSkip;
  int? takenTime;
  int? takenTimeApp;
  String? userSelectedAnswer;
  GetTestAnswer? getTestAnswer;
  List<GetOption>? getOption;
  List<String>? userSelectedAnswerApp;
  int? selectedOptionId;
  dynamic numericAnswer;
  bool? isOpen;
  bool? isVisible;
  int? isAnswerTrue;
  List<String>? userTempAnswer;
  int? question_type;

  factory TestMcqData.fromJson(Map<String, dynamic> json) => TestMcqData(
        id: json["id"] == null ? null : json["id"],
        topicId: json["topic_id"] == null ? null : json["topic_id"],
        chapterId: json["chapter_id"] == null ? 0 : json["chapter_id"],
        subjectId: json["subject_id"] == null ? 0 : json["subject_id"],
        question: json["question"] == null ? '' : json["question"],
        type: json["type"] == null ? 0 : json["type"],
        solution: json["solution"] == null ? '' : json["solution"],
        video: json["video"] == null ? '' : json["video"],
        positiveMark: json["positive_mark"] == null ? 0 : json["positive_mark"],
        negetiveMark: json["negetive_mark"] == null ? 0 : json["negetive_mark"],
        isBookmark: json["is_bookmark"] == null ? 0 : json["is_bookmark"],
        isReport: json["is_report"] == null ? 0 : json["is_report"],
        markReview: json["mark_review"] == null ? 0 : json["mark_review"],
        remainingTime:
            json["remaining_time"] == null ? 0 : json["remaining_time"],
        isTrue: json["is_true"] == null ? 0 : json["is_true"],
        isSkip: json["is_skip"] == null ? 0 : json["is_skip"],
        takenTime: json["taken_time"] == null ? 0 : json["taken_time"],
        takenTimeApp: json["takenTimeApp"] == null ? 0 : json["takenTimeApp"],
        userSelectedAnswer: (json["user_selected_answer"] == null)
            ? ''
            : json["user_selected_answer"],
        getTestAnswer: json["get_test_answer"] == null
            ? null
            : GetTestAnswer.fromJson(json["get_test_answer"]),
        getOption: json["get_option"] == null
            ? null
            : List<GetOption>.from(
                json["get_option"].map((x) => GetOption.fromJson(x))),
        userSelectedAnswerApp: json["user_selected_answer"] == null
            ? []
            : List<String>.from(
                jsonDecode(json["user_selected_answer"]).map((x) => x)),
        selectedOptionId: (json["selected_option_id"] == null)
            ? 0
            : json["selected_option_id"],
        numericAnswer:
            (json["numeric_answer"] == null) ? 0 : json["numeric_answer"],
        isOpen: (json["isOpen"] == null) ? false : json["isOpen"],
        isVisible: (json["isVisible"] == null) ? true : json["isVisible"],
        isAnswerTrue: (json["isAnswerTrue"] == null) ? 0 : json["isAnswerTrue"],
        userTempAnswer: (json["user_temp_answer"] == null)
            ? []
            : List<String>.from(json["user_temp_answer"].map((x) => x)),
        question_type:
            json["question_type"] == null ? 1 : json["question_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "topic_id": topicId == null ? null : topicId,
        "chapter_id": chapterId == null ? null : chapterId,
        "subject_id": subjectId == null ? null : subjectId,
        "question": question == null ? null : question,
        "type": type == null ? null : type,
        "solution": solution == null ? null : solution,
        "video": video == null ? null : video,
        "positive_mark": positiveMark == null ? null : positiveMark,
        "negetive_mark": negetiveMark == null ? null : negetiveMark,
        "is_bookmark": isBookmark == null ? 0 : isBookmark,
        "is_report": isReport == null ? null : isReport,
        "mark_review": markReview == null ? 0 : markReview,
        "remaining_time": remainingTime == null ? null : remainingTime,
        "is_true": isTrue == null ? 0 : isTrue,
        "is_skip": isSkip == null ? 0 : isSkip,
        "taken_time": takenTime == null ? 0 : takenTime,
        "takenTimeApp": takenTimeApp == null ? 0 : takenTimeApp,
        "user_selected_answer":
            (userSelectedAnswer == null) ? [] : userSelectedAnswer,
        "get_test_answer":
            getTestAnswer == null ? null : getTestAnswer!.toJson(),
        "get_option": getOption == null
            ? null
            : List<dynamic>.from(getOption!.map((x) => x.toJson())),
        // "user_selected_answer":
        //     userSelectedAnswer == null ? [] : userSelectedAnswer,
        "get_option": getOption == null
            ? null
            : List<dynamic>.from(getOption!.map((x) => x.toJson())),
        "user_selected_answer_app": userSelectedAnswerApp == null
            ? []
            : List<dynamic>.from(userSelectedAnswerApp!.map((x) => x)),
        "selected_option_id": (selectedOptionId == null) ? 0 : selectedOptionId,
        "numeric_answer": (numericAnswer == null) ? 0 : numericAnswer,
        "isOpen": (isOpen == null) ? false : isOpen,
        "isVisible": (isVisible == null) ? true : isVisible,
        "isAnswerTrue": (isAnswerTrue == null) ? 0 : isAnswerTrue,
        "user_temp_answer": userTempAnswer == null
            ? []
            : List<dynamic>.from(userTempAnswer!.map((x) => x)),
        "question_type": question_type == null ? 1 : question_type,
      };
}

class GetOption {
  GetOption({
    this.id,
    this.questionId,
    this.option,
    this.isTrue,
    this.optionMin,
    this.optionMax,
    this.isUserSelected,
  });

  int? id;
  int? questionId;
  String? option;
  int? isTrue;
  dynamic optionMin;
  dynamic optionMax;
  int? isUserSelected;

  factory GetOption.fromJson(Map<String, dynamic> json) => GetOption(
        id: json["id"] == null ? null : json["id"],
        questionId: json["question_id"] == null ? 0 : json["question_id"],
        option: json["option"] == null ? '' : json["option"],
        isTrue: json["is_true"] == null ? 0 : json["is_true"],
        optionMin: json["option_min"] == null ? 0 : json["option_min"],
        optionMax: json["option_max"] == null ? 0 : json["option_max"],
        isUserSelected:
            (json["is_user_selected"] == null) ? 0 : json["is_user_selected"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "question_id": questionId == null ? null : questionId,
        "option": option == null ? null : option,
        "is_true": isTrue == null ? null : isTrue,
        "option_min": optionMin,
        "option_max": optionMax,
        "is_user_selected": (isUserSelected == null) ? 0 : isUserSelected,
      };
}

class GetTestAnswer {
  GetTestAnswer({
    this.questionId,
    this.totalSolved,
    this.averageTime,
  });

  int? questionId;
  int? totalSolved;
  String? averageTime;

  factory GetTestAnswer.fromJson(Map<String, dynamic> json) => GetTestAnswer(
        questionId: json["question_id"] == null ? 0 : json["question_id"],
        totalSolved: json["total_solved"] == null ? 0 : json["total_solved"],
        averageTime:
            json["average_time"] == null ? '0.0' : json["average_time"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId == null ? null : questionId,
        "total_solved": totalSolved == null ? null : totalSolved,
        "average_time": averageTime == null ? null : averageTime,
      };
}
