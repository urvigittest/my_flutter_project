// To parse this JSON data, do
//
//     final topicModel = topicModelFromJson(jsonString);

import 'dart:convert';

TopicModel topicModelFromJson(String str) =>
    TopicModel.fromJson(json.decode(str));

String topicModelToJson(TopicModel data) => json.encode(data.toJson());

class TopicModel {
  TopicModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<TopicData>? data;

  factory TopicModel.fromJson(Map<String, dynamic> json) => TopicModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TopicData>.from(
                json["data"].map((x) => TopicData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TopicData {
  TopicData({
    this.id,
    this.name,
    this.pdfDoc,
    this.totalPracticeQuestion,
    this.totalGivenPracticeAnswer,
    this.totalCorrectPracticeAnswer,
    this.totalIncorrectPracticeAnswer,
    this.is_start,
    this.totalPyqQuestion,
    this.totalGivenPyqAnswer,
    this.totalCorrectPyqAnswer,
    this.totalIncorrectPyqAnswer,
  });

  int? id;
  String? name;
  String? pdfDoc;
  int? totalPracticeQuestion;
  int? totalGivenPracticeAnswer;
  int? totalCorrectPracticeAnswer;
  int? totalIncorrectPracticeAnswer;
  int? is_start;

  int? totalPyqQuestion;
  int? totalGivenPyqAnswer;
  int? totalCorrectPyqAnswer;
  int? totalIncorrectPyqAnswer;

  factory TopicData.fromJson(Map<String, dynamic> json) => TopicData(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? '' : json["name"],
        pdfDoc: (json["pdf_doc"] == null) ? '' : json["pdf_doc"],
        totalPracticeQuestion: (json["total_practice_question"] == null)
            ? 0
            : json["total_practice_question"],
        totalGivenPracticeAnswer: (json["total_given_practice_answer"] == null)
            ? 0
            : json["total_given_practice_answer"],
        totalCorrectPracticeAnswer:
            (json["total_correct_practice_answer"] == null)
                ? 0
                : json["total_correct_practice_answer"],
        totalIncorrectPracticeAnswer:
            (json["total_incorrect_practice_answer"] == null)
                ? 0
                : json["total_incorrect_practice_answer"],
        is_start: (json["is_start"] == null) ? 0 : json["is_start"],
        totalPyqQuestion:
            (json["total_pyq_question"] == null) ? 0 : json["total_pyq_question"],
        totalGivenPyqAnswer: (json["total_given_pyq_answer"] == null)
            ? 0
            : json["total_given_pyq_answer"],
        totalCorrectPyqAnswer: (json["total_correct_pyq_answer"] == null)
            ? 0
            : json["total_correct_pyq_answer"],
        totalIncorrectPyqAnswer: (json["total_incorrect_pyq_answer"] == null)
            ? 0
            : json["total_incorrect_pyq_answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? null : name,
        "pdf_doc": (pdfDoc == null) ? null : pdfDoc,
        "total_practice_question":
            (totalPracticeQuestion == null) ? 0 : totalPracticeQuestion,
        "total_given_practice_answer":
            (totalGivenPracticeAnswer == null) ? 0 : totalGivenPracticeAnswer,
        "total_correct_practice_answer": (totalCorrectPracticeAnswer == null)
            ? null
            : totalCorrectPracticeAnswer,
        "total_incorrect_practice_answer": (totalIncorrectPracticeAnswer == null)
            ? 0
            : totalIncorrectPracticeAnswer,
        "is_start": (is_start == null) ? 0 : is_start,
        "total_pyq_question": (totalPyqQuestion == null) ? 0 : totalPyqQuestion,
        "total_given_pyq_answer":
            (totalGivenPyqAnswer == null) ? 0 : totalGivenPyqAnswer,
        "total_correct_pyq_answer":
            (totalCorrectPyqAnswer == null) ? 0 : totalCorrectPyqAnswer,
        "total_incorrect_pyq_answer":
            (totalIncorrectPyqAnswer == null) ? 0 : totalIncorrectPyqAnswer,
      };
}
