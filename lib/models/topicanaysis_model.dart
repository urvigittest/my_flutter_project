// To parse this JSON data, do
//
//     final topicAnalysisModel = topicAnalysisModelFromJson(jsonString);

import 'dart:convert';

TopicAnalysisModel topicAnalysisModelFromJson(String str) =>
    TopicAnalysisModel.fromJson(json.decode(str));

String topicAnalysisModelToJson(TopicAnalysisModel data) =>
    json.encode(data.toJson());

class TopicAnalysisModel {
  TopicAnalysisModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  TopicAnaylsisData? data;

  factory TopicAnalysisModel.fromJson(Map<String, dynamic> json) =>
      TopicAnalysisModel(
        status: (json["status"] == null) ? false : json["status"],
        message: (json["message"] == null) ? '' : json["message"],
        data: json["data"] == null
            ? null
            : TopicAnaylsisData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class TopicAnaylsisData {
  TopicAnaylsisData({
    this.totalCorrect,
    this.totalIncorrect,
    this.totalSkip,
    this.totalCorrectTime,
    this.totalIncorrectTime,
    this.totalSkipTime,
    this.totalTime,
    this.totalQuestion,
    this.accuracyTotal,
    this.totalAvgTime,
  });

  int? totalCorrect;
  int? totalIncorrect;
  int? totalSkip;
  int? totalCorrectTime;
  int? totalIncorrectTime;
  int? totalSkipTime;
  int? totalTime;
  int? totalQuestion;
  dynamic? accuracyTotal;
  dynamic totalAvgTime;

  factory TopicAnaylsisData.fromJson(Map<String, dynamic> json) =>
      TopicAnaylsisData(
        totalCorrect:
            (json["total_correct"] == null) ? 0 : json["total_correct"],
        totalIncorrect:
            (json["total_incorrect"] == null) ? 0 : json["total_incorrect"],
        totalSkip: (json["total_skip"] == null) ? 0 : json["total_skip"],
        totalCorrectTime: (json["total_correct_time"] == null)
            ? 0
            : json["total_correct_time"],
        totalIncorrectTime: (json["total_incorrect_time"] == null)
            ? 0
            : json["total_incorrect_time"],
        totalSkipTime:
            (json["total_skip_time"] == null) ? 0 : json["total_skip_time"],
        totalTime: (json["total_time"] == null) ? 0 : json["total_time"],
        totalQuestion:
            (json["total_question"] == null) ? 0 : json["total_question"],
        accuracyTotal:
            (json["accuracy_total"] == null) ? 0 : json["accuracy_total"],
        totalAvgTime:
            (json["total_avg_time"] == null) ? 0.0 : json["total_avg_time"],
      );

  Map<String, dynamic> toJson() => {
        "total_correct": (totalCorrect == null) ? 0 : totalCorrect,
        "total_incorrect": (totalIncorrect == null) ? 0 : totalIncorrect,
        "total_skip": (totalSkip == null) ? 0 : totalSkip,
        "total_correct_time": (totalCorrectTime == null) ? 0 : totalCorrectTime,
        "total_incorrect_time":
            (totalIncorrectTime == null) ? 0 : totalIncorrectTime,
        "total_skip_time": (totalSkipTime == null) ? 0 : totalSkipTime,
        "total_time": (totalTime == null) ? 0 : totalTime,
        "total_question": (totalQuestion == null) ? 0 : totalQuestion,
        "accuracy_total": (accuracyTotal == null) ? 0 : accuracyTotal,
        "total_avg_time": (totalAvgTime == null) ? 0.0 : totalAvgTime,
      };
}
