// To parse this JSON data, do
//
//     final topicWiseModel = topicWiseModelFromJson(jsonString);

import 'dart:convert';

TopicWiseModel topicWiseModelFromJson(String str) =>
    TopicWiseModel.fromJson(json.decode(str));

String topicWiseModelToJson(TopicWiseModel data) => json.encode(data.toJson());

class TopicWiseModel {
  TopicWiseModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  TopicWiseData? data;

  factory TopicWiseModel.fromJson(Map<String, dynamic> json) => TopicWiseModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data:
            json["data"] == null ? null : TopicWiseData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class TopicWiseData {
  TopicWiseData({
    this.testName,
    this.totalQuestion,
    this.technicalTotalMarks,
    this.technicalObtainMarks,
    this.generalAptitudeTotalMarks,
    this.generalAptitudeObtainMarks,
    this.technicalCorrectQuestion,
    this.technicalIncorrectQuestion,
    this.technicalSkipQuestion,
    this.generalAptitudeCorrectQuestion,
    this.generalAptitudeIncorrectQuestion,
    this.generalAptitudeSkipQuestion,
    this.technicalCorrectMarks,
    this.technicalIncorrectMarks,
    this.technicalSkipMarks,
    this.generalAptitudeCorrectMarks,
    this.generalAptitudeIncorrectMarks,
    this.generalAptitudeSkipMarks,
  });

  String? testName;
  int? totalQuestion;
  dynamic? technicalTotalMarks;
  dynamic? technicalObtainMarks;
  dynamic? generalAptitudeTotalMarks;
  dynamic? generalAptitudeObtainMarks;
  int? technicalCorrectQuestion;
  int? technicalIncorrectQuestion;
  int? technicalSkipQuestion;
  int? generalAptitudeCorrectQuestion;
  int? generalAptitudeIncorrectQuestion;
  int? generalAptitudeSkipQuestion;
  dynamic? technicalCorrectMarks;
  dynamic? technicalIncorrectMarks;
  dynamic? technicalSkipMarks;
  dynamic? generalAptitudeCorrectMarks;
  dynamic? generalAptitudeIncorrectMarks;
  dynamic? generalAptitudeSkipMarks;

  factory TopicWiseData.fromJson(Map<String, dynamic> json) => TopicWiseData(
        testName: json["test_name"] == null ? '' : json["test_name"],
        totalQuestion:
            json["total_question"] == null ? 0 : json["total_question"],
        technicalTotalMarks: json["technical_total_marks"] == null
            ? 0
            : json["technical_total_marks"],
        technicalObtainMarks: json["technical_obtain_marks"] == null
            ? 0
            : json["technical_obtain_marks"],
        generalAptitudeTotalMarks: json["general_aptitude_total_marks"] == null
            ? 0
            : json["general_aptitude_total_marks"],
        generalAptitudeObtainMarks:
            json["general_aptitude_obtain_marks"] == null
                ? 0
                : json["general_aptitude_obtain_marks"],
        technicalCorrectQuestion: json["technical_correct_question"] == null
            ? 0
            : json["technical_correct_question"],
        technicalIncorrectQuestion: json["technical_incorrect_question"] == null
            ? 0
            : json["technical_incorrect_question"],
        technicalSkipQuestion: json["technical_skip_question"] == null
            ? 0
            : json["technical_skip_question"],
        generalAptitudeCorrectQuestion:
            json["general_aptitude_correct_question"] == null
                ? 0
                : json["general_aptitude_correct_question"],
        generalAptitudeIncorrectQuestion:
            json["general_aptitude_incorrect_question"] == null
                ? 0
                : json["general_aptitude_incorrect_question"],
        generalAptitudeSkipQuestion:
            json["general_aptitude_skip_question"] == null
                ? 0
                : json["general_aptitude_skip_question"],
        technicalCorrectMarks: json["technical_correct_marks"] == null
            ? 0
            : json["technical_correct_marks"],
        technicalIncorrectMarks: json["technical_incorrect_marks"] == null
            ? 0
            : json["technical_incorrect_marks"],
        technicalSkipMarks: json["technical_skip_marks"] == null
            ? 0
            : json["technical_skip_marks"],
        generalAptitudeCorrectMarks:
            json["general_aptitude_correct_marks"] == null
                ? 0
                : json["general_aptitude_correct_marks"],
        generalAptitudeIncorrectMarks:
            json["general_aptitude_incorrect_marks"] == null
                ? 0
                : json["general_aptitude_incorrect_marks"],
        generalAptitudeSkipMarks: json["general_aptitude_skip_marks"] == null
            ? 0
            : json["general_aptitude_skip_marks"],
      );

  Map<String, dynamic> toJson() => {
        "test_name": testName == null ? null : testName,
        "total_question": totalQuestion == null ? null : totalQuestion,
        "technical_total_marks":
            technicalTotalMarks == null ? null : technicalTotalMarks,
        "technical_obtain_marks":
            technicalObtainMarks == null ? null : technicalObtainMarks,
        "general_aptitude_total_marks": generalAptitudeTotalMarks == null
            ? null
            : generalAptitudeTotalMarks,
        "general_aptitude_obtain_marks": generalAptitudeObtainMarks == null
            ? null
            : generalAptitudeObtainMarks,
        "technical_correct_question":
            technicalCorrectQuestion == null ? null : technicalCorrectQuestion,
        "technical_incorrect_question": technicalIncorrectQuestion == null
            ? null
            : technicalIncorrectQuestion,
        "technical_skip_question":
            technicalSkipQuestion == null ? null : technicalSkipQuestion,
        "general_aptitude_correct_question":
            generalAptitudeCorrectQuestion == null
                ? null
                : generalAptitudeCorrectQuestion,
        "general_aptitude_incorrect_question":
            generalAptitudeIncorrectQuestion == null
                ? null
                : generalAptitudeIncorrectQuestion,
        "general_aptitude_skip_question": generalAptitudeSkipQuestion == null
            ? null
            : generalAptitudeSkipQuestion,
        "technical_correct_marks":
            technicalCorrectMarks == null ? null : technicalCorrectMarks,
        "technical_incorrect_marks":
            technicalIncorrectMarks == null ? null : technicalIncorrectMarks,
        "technical_skip_marks":
            technicalSkipMarks == null ? null : technicalSkipMarks,
        "general_aptitude_correct_marks": generalAptitudeCorrectMarks == null
            ? null
            : generalAptitudeCorrectMarks,
        "general_aptitude_incorrect_marks":
            generalAptitudeIncorrectMarks == null
                ? null
                : generalAptitudeIncorrectMarks,
        "general_aptitude_skip_marks":
            generalAptitudeSkipMarks == null ? null : generalAptitudeSkipMarks,
      };
}
