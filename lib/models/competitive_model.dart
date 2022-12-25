// To parse this JSON data, do
//
//     final competitiveModel = competitiveModelFromJson(jsonString);

import 'dart:convert';

CompetitiveModel competitiveModelFromJson(String str) =>
    CompetitiveModel.fromJson(json.decode(str));

String competitiveModelToJson(CompetitiveModel data) =>
    json.encode(data.toJson());

class CompetitiveModel {
  CompetitiveModel({
    this.status,
    this.message,
    this.data,
    this.currentUserData,
    this.topStudents,
  });

  bool? status;
  String? message;
  CompetitiveData? data;
  CurrentUserData? currentUserData;
  List<CurrentUserData>? topStudents;

  factory CompetitiveModel.fromJson(Map<String, dynamic> json) =>
      CompetitiveModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : CompetitiveData.fromJson(json["data"]),
        currentUserData: json["current_user_data"] == null
            ? null
            : CurrentUserData.fromJson(json["current_user_data"]),
        topStudents: json["top_students"] == null
            ? null
            : List<CurrentUserData>.from(
                json["top_students"].map((x) => CurrentUserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
        "current_user_data":
            currentUserData == null ? null : currentUserData!.toJson(),
        "top_students": topStudents == null
            ? null
            : List<dynamic>.from(topStudents!.map((x) => x.toJson())),
      };
}

class CurrentUserData {
  CurrentUserData({
    this.fullname,
    this.rankNo,
    this.totalQuestion,
    this.totalMarks,
    this.obtainMarks,
    this.totalCorrectQuestion,
    this.totalIncorrectQuestion,
    this.totalSkipQuestion,
    this.totalCorrectMarks,
    this.totalIncorrectMarks,
    this.totalSkipMarks,
    this.subjectname,
    this.topicname,
    this.image,
  });

  String? fullname;
  int? rankNo;
  dynamic totalQuestion;
  dynamic? totalMarks;
  dynamic? obtainMarks;
  dynamic? totalCorrectQuestion;
  dynamic? totalIncorrectQuestion;
  dynamic? totalSkipQuestion;
  dynamic? totalCorrectMarks;
  dynamic? totalIncorrectMarks;
  dynamic? totalSkipMarks;
  String? subjectname;
  String? topicname;
  String? image;

  factory CurrentUserData.fromJson(Map<String, dynamic> json) =>
      CurrentUserData(
        fullname: json["fullname"] == null ? '' : json["fullname"],
        rankNo: json["rank_no"] == null ? 0 : json["rank_no"],
        totalQuestion:
            json["total_question"] == null ? 0 : json["total_question"],
        totalMarks: json["total_marks"] == null ? 0 : json["total_marks"],
        obtainMarks: json["obtain_marks"] == null ? 0 : json["obtain_marks"],
        totalCorrectQuestion: json["total_correct_question"] == null
            ? 0
            : json["total_correct_question"],
        totalIncorrectQuestion: json["total_incorrect_question"] == null
            ? 0
            : json["total_incorrect_question"],
        totalSkipQuestion: json["total_skip_question"] == null
            ? 0
            : json["total_skip_question"],
        totalCorrectMarks: json["total_correct_marks"] == null
            ? 0
            : json["total_correct_marks"],
        totalIncorrectMarks: json["total_incorrect_marks"] == null
            ? 0
            : json["total_incorrect_marks"],
        totalSkipMarks:
            json["total_skip_marks"] == null ? 0 : json["total_skip_marks"],
        subjectname: json["subject_name"] == null ? '' : json["subject_name"],
        topicname: json["topic_name"] == null ? '' : json["topic_name"],
        image: json["image"] == null ? '' : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname == null ? null : fullname,
        "rank_no": rankNo == null ? null : rankNo,
        "total_question": totalQuestion == null ? null : totalQuestion,
        "total_marks": totalMarks == null ? null : totalMarks,
        "obtain_marks": obtainMarks == null ? null : obtainMarks,
        "total_correct_question":
            totalCorrectQuestion == null ? null : totalCorrectQuestion,
        "total_incorrect_question":
            totalIncorrectQuestion == null ? null : totalIncorrectQuestion,
        "total_skip_question":
            totalSkipQuestion == null ? null : totalSkipQuestion,
        "total_correct_marks":
            totalCorrectMarks == null ? null : totalCorrectMarks,
        "total_incorrect_marks":
            totalIncorrectMarks == null ? null : totalIncorrectMarks,
        "total_skip_marks": totalSkipMarks == null ? null : totalSkipMarks,
        "subject_name": subjectname == null ? null : subjectname,
        "topic_name": topicname == null ? null : topicname,
        "image": image == null ? null : image,
      };
}

class CompetitiveData {
  CompetitiveData({
    this.testName,
  });

  String? testName;

  factory CompetitiveData.fromJson(Map<String, dynamic> json) =>
      CompetitiveData(
        testName: json["test_name"] == null ? null : json["test_name"],
      );

  Map<String, dynamic> toJson() => {
        "test_name": testName == null ? null : testName,
      };
}
