// To parse this JSON data, do
//
//     final practiceMcqModel = practiceMcqModelFromJson(jsonString);

import 'dart:convert';

PracticeMcqModel practiceMcqModelFromJson(String str) =>
    PracticeMcqModel.fromJson(json.decode(str));

String practiceMcqModelToJson(PracticeMcqModel data) =>
    json.encode(data.toJson());

class PracticeMcqModel {
  PracticeMcqModel({
    this.status,
    this.message,
    this.data,
    this.lastPage,
    this.total,
    this.from,
    this.to,
    this.perPage,
    this.currentPage,
  });

  bool? status;
  String? message;
  List<PracticeMCQData>? data;
  int? lastPage;
  int? total;
  int? from;
  int? to;
  int? perPage;
  int? currentPage;

  factory PracticeMcqModel.fromJson(Map<String, dynamic> json) =>
      PracticeMcqModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<PracticeMCQData>.from(
                json["data"].map((x) => PracticeMCQData.fromJson(x))),
        lastPage: (json["last_page"] == null) ? null : json["last_page"],
        total: (json["total"] == null) ? 0 : json["total"],
        from: (json["from"] == null) ? 0 : json["from"],
        to: (json["to"] == null) ? 0 : json["to"],
        perPage: (json["per_page"] == null) ? 0 : json["per_page"],
        currentPage: (json["current_page"] == null) ? 0 : json["current_page"],
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": (lastPage == null) ? 0 : lastPage,
        "total": (total == null) ? 0 : total,
        "from": (from == null) ? 0 : from,
        "to": (to == null) ? 0 : to,
        "per_page": (perPage == null) ? 0 : perPage,
        "current_page": (currentPage == null) ? 0 : currentPage,
      };
}

class PracticeMCQData {
  PracticeMCQData({
    this.id,
    this.topicId,
    this.question,
    this.type,
    this.solution,
    this.video,
    this.isBookmark,
    this.isReport,
    this.getOption,
    this.positiveMark,
    this.negetiveMark,
    this.userTempAnswer,
    this.isAnswerTrue,
    this.isSkip,
    this.takenTime,
    this.totalsolved,
    this.takenTimeApp,
    this.userSelectedAnswerApp,
    this.userSelectedAnswer,
    this.selectedOptionId,
    this.numericAnswer,
    this.getPracticeAnswer,
    this.chapterId,
    this.subjectId,
    this.isOpen,
    this.isVisible,
    this.isTrue,
    this.getPyqAnswer,
  });

  int? id;
  int? topicId;
  String? question;
  int? type;
  String? solution;
  dynamic video;
  int? isBookmark;
  int? isReport;
  List<GetPracticeOption>? getOption;
  dynamic positiveMark;
  dynamic negetiveMark;
  List<String>? userTempAnswer;
  int? isAnswerTrue;
  int? isSkip;
  int? takenTime;
  int? totalsolved;
  int? takenTimeApp;
  String? userSelectedAnswer;
  List<String>? userSelectedAnswerApp;
  int? selectedOptionId;
  dynamic numericAnswer;
  GetPracticeAnswer? getPracticeAnswer;
  GetPyqAnswer? getPyqAnswer;
  int? chapterId;
  int? subjectId;
  bool? isOpen;
  bool? isVisible;

  int? isTrue;

  factory PracticeMCQData.fromJson(Map<String, dynamic> json) =>
      PracticeMCQData(
        id: (json["id"] == null) ? null : json["id"],
        topicId: (json["topic_id"] == null) ? null : json["topic_id"],
        question: (json["question"] == null) ? '' : json["question"],
        type: (json["type"] == null) ? 0 : json["type"],
        solution: (json["solution"] == null) ? '' : json["solution"],
        video: (json["video"] == null) ? '' : json["video"],
        isBookmark: (json["is_bookmark"] == null) ? 0 : json["is_bookmark"],
        isReport: (json["is_report"] == null) ? null : json["is_report"],
        getOption: (json["get_option"] == null)
            ? null
            : List<GetPracticeOption>.from(
                json["get_option"].map((x) => GetPracticeOption.fromJson(x))),
        positiveMark: json["positive_mark"],
        negetiveMark: json["negetive_mark"],
        userTempAnswer: (json["user_temp_answer"] == null)
            ? []
            : List<String>.from(json["user_temp_answer"].map((x) => x)),
        isAnswerTrue: (json["isAnswerTrue"] == null) ? 0 : json["isAnswerTrue"],
        isSkip: (json["is_skip"] == null) ? 0 : json["is_skip"],
        takenTime: (json["taken_time"] == null) ? 0 : json["taken_time"],
        totalsolved: (json["total_solved"] == null) ? 0 : json["total_solved"],
        takenTimeApp: (json["takenTimeApp"] == null) ? 0 : json["takenTimeApp"],
        userSelectedAnswerApp: json["user_selected_answer"] == null
            ? []
            : List<String>.from(
                jsonDecode(json["user_selected_answer"]).map((x) => x)),
        userSelectedAnswer: (json["user_selected_answer"] == null)
            ? ''
            : json["user_selected_answer"],
        selectedOptionId: (json["selected_option_id"] == null)
            ? 0
            : json["selected_option_id"],
        numericAnswer:
            (json["numeric_answer"] == null) ? 0 : json["numeric_answer"],
        getPracticeAnswer: json["get_practice_answer"] == null
            ? null
            : GetPracticeAnswer.fromJson(json["get_practice_answer"]),
        chapterId: (json["chapter_id"] == null) ? 0 : json["chapter_id"],
        subjectId: (json["subject_id"] == null) ? 0 : json["subject_id"],
        isOpen: (json["isOpen"] == null) ? false : json["isOpen"],
        isVisible: (json["isVisible"] == null) ? true : json["isVisible"],
        isTrue: (json["is_true"] == null) ? 0 : json["is_true"],
        getPyqAnswer: json["get_pyq_answer"] == null
            ? null
            : GetPyqAnswer.fromJson(json["get_pyq_answer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "topic_id": (topicId == null) ? null : topicId,
        "question": (question == null) ? null : question,
        "type": (type == null) ? null : type,
        "solution": (solution == null) ? null : solution,
        "video": video,
        "is_bookmark": (isBookmark == null) ? 0 : isBookmark,
        "is_report": (isReport == null) ? null : isReport,
        "get_option": getOption == null
            ? null
            : List<dynamic>.from(getOption!.map((x) => x.toJson())),
        "positive_mark": positiveMark,
        "negetive_mark": negetiveMark,
        "user_temp_answer": userTempAnswer == null
            ? []
            : List<dynamic>.from(userTempAnswer!.map((x) => x)),
        "isAnswerTrue": (isAnswerTrue == null) ? 0 : isAnswerTrue,
        "is_skip": (isSkip == null) ? 0 : isSkip,
        "taken_time": (takenTime == null) ? 0 : takenTime,
        "total_solved": (takenTime == null) ? 0 : totalsolved,
        "takenTimeApp": (takenTimeApp == null) ? 0 : takenTimeApp,
        "user_selected_answer_app": userSelectedAnswerApp == null
            ? []
            : List<dynamic>.from(userSelectedAnswerApp!.map((x) => x)),
        "user_selected_answer":
            (userSelectedAnswer == null) ? null : userSelectedAnswer,
        "selected_option_id": (selectedOptionId == null) ? 0 : selectedOptionId,
        "numeric_answer": (numericAnswer == null) ? 0 : numericAnswer,
        "chapter_id": (chapterId == null) ? 0 : chapterId,
        "subject_id": (subjectId == null) ? 0 : subjectId,
        "get_practice_answer":
            getPracticeAnswer == null ? null : getPracticeAnswer!.toJson(),
        "isOpen": (isOpen == null) ? false : isOpen,
        "isVisible": (isVisible == null) ? true : isVisible,
        "isTrue": (isTrue == null) ? 0 : isTrue,
        "get_pyq_answer": getPyqAnswer == null ? null : getPyqAnswer!.toJson(),
      };
}

class GetPracticeOption {
  GetPracticeOption({
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

  factory GetPracticeOption.fromJson(Map<String, dynamic> json) =>
      GetPracticeOption(
        id: (json["id"] == null) ? null : json["id"],
        questionId: (json["question_id"] == null) ? null : json["question_id"],
        option: (json["option"] == null) ? null : json["option"],
        isTrue: (json["is_true"] == null) ? 0 : json["is_true"],
        optionMin: (json["option_min"] == null) ? 0.0 : json["option_min"],
        optionMax: (json["option_max"] == null) ? 0.0 : json["option_max"],
        isUserSelected:
            (json["is_user_selected"] == null) ? 0 : json["is_user_selected"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "question_id": (questionId == null) ? null : questionId,
        "option": (option == null) ? null : option,
        "is_true": (isTrue == null) ? 0 : isTrue,
        "option_min": (optionMin == null) ? 0.0 : optionMin,
        "option_max": (optionMax == null) ? 0.0 : optionMax,
        "is_user_selected": (isUserSelected == null) ? 0 : isUserSelected,
      };
}

class GetPracticeAnswer {
  GetPracticeAnswer({
    this.questionId,
    this.totalSolved,
    this.averageTime,
  });

  int? questionId;
  int? totalSolved;
  String? averageTime;

  factory GetPracticeAnswer.fromJson(Map<String, dynamic> json) =>
      GetPracticeAnswer(
        questionId: (json["question_id"] == null) ? 0 : json["question_id"],
        totalSolved: (json["total_solved"] == null) ? 0 : json["total_solved"],
        averageTime:
            (json["average_time"] == null) ? '0.0' : json["average_time"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": (questionId == null) ? 0 : questionId,
        "total_solved": (totalSolved == null) ? 0 : totalSolved,
        "average_time": (averageTime == null) ? '0.0' : averageTime,
      };
}

class GetPyqAnswer {
  GetPyqAnswer({
    this.questionId,
    this.totalSolved,
    this.averageTime,
  });

  int? questionId;
  int? totalSolved;
  String? averageTime;

  factory GetPyqAnswer.fromJson(Map<String, dynamic> json) => GetPyqAnswer(
        questionId: (json["question_id"] == null) ? 0 : json["question_id"],
        totalSolved: (json["total_solved"] == null) ? 0 : json["total_solved"],
        averageTime:
            (json["average_time"] == null) ? '0.0' : json["average_time"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": (questionId == null) ? 0 : questionId,
        "total_solved": (totalSolved == null) ? 0 : totalSolved,
        "average_time": (averageTime == null) ? '0.0' : averageTime,
      };
}
