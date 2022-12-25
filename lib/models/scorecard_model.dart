// To parse this JSON data, do
//
//     final scoreCardModel = scoreCardModelFromJson(jsonString);

import 'dart:convert';

ScoreCardModel scoreCardModelFromJson(String str) =>
    ScoreCardModel.fromJson(json.decode(str));

String scoreCardModelToJson(ScoreCardModel data) => json.encode(data.toJson());

class ScoreCardModel {
  ScoreCardModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  ScoreCardData? data;

  factory ScoreCardModel.fromJson(Map<String, dynamic> json) => ScoreCardModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : ScoreCardData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class ScoreCardData {
  ScoreCardData({
    this.rankNo,
    this.id,
    this.testName,
    this.totalQuestion,
    this.totalMarks,
    this.totalTime,
    this.totalStudentAttempted,
    this.description,
    this.completiondate,
  });

  int? rankNo;
  int? id;
  String? testName;
  int? totalQuestion;
  dynamic? totalMarks;
  dynamic totalTime;
  int? totalStudentAttempted;
  String? description;
  String? completiondate;

  factory ScoreCardData.fromJson(Map<String, dynamic> json) => ScoreCardData(
        rankNo: json["rank_no"] == null ? 0 : json["rank_no"],
        id: json["id"] == null ? null : json["id"],
        testName: json["test_name"] == null ? '' : json["test_name"],
        totalQuestion:
            json["total_question"] == null ? 0 : json["total_question"],
        totalMarks: json["total_marks"] == null ? 0 : json["total_marks"],
        totalTime: json["total_time"] == null ? '0' : json["total_time"],
        totalStudentAttempted: json["total_student_attempted"] == null
            ? 0
            : json["total_student_attempted"],
        description: json["description"] == null ? '' : json["description"],
        completiondate:
            json["completion_date"] == null ? '' : json["completion_date"],
      );

  Map<String, dynamic> toJson() => {
        "rank_no": rankNo == null ? 0 : rankNo,
        "id": id == null ? null : id,
        "test_name": testName == null ? null : testName,
        "total_question": totalQuestion == null ? null : totalQuestion,
        "total_marks": totalMarks == null ? null : totalMarks,
        "total_time": totalTime == null ? '0' : totalTime,
        "total_student_attempted":
            totalStudentAttempted == null ? null : totalStudentAttempted,
        "description": (description == null) ? '' : description,
        "completion_date": (completiondate == null) ? '' : completiondate,
      };
}
