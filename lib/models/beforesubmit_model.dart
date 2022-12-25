// To parse this JSON data, do
//
//     final beforeSubmitModel = beforeSubmitModelFromJson(jsonString);

import 'dart:convert';

BeforeSubmitModel beforeSubmitModelFromJson(String str) =>
    BeforeSubmitModel.fromJson(json.decode(str));

String beforeSubmitModelToJson(BeforeSubmitModel data) =>
    json.encode(data.toJson());

class BeforeSubmitModel {
  BeforeSubmitModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  BeforeSubmitData? data;

  factory BeforeSubmitModel.fromJson(Map<String, dynamic> json) =>
      BeforeSubmitModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : BeforeSubmitData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class BeforeSubmitData {
  BeforeSubmitData({
    this.testId,
    this.totalAttempted,
    this.totalQuestion,
    this.totalReviewed,
  });

  int? testId;
  int? totalAttempted;
  int? totalQuestion;
  int? totalReviewed;

  factory BeforeSubmitData.fromJson(Map<String, dynamic> json) =>
      BeforeSubmitData(
        testId: json["test_id"] == null ? 0 : json["test_id"],
        totalAttempted:
            json["total_attempted"] == null ? 0 : json["total_attempted"],
        totalQuestion:
            json["total_question"] == null ? 0 : json["total_question"],
        totalReviewed:
            json["total_reviewed"] == null ? 0 : json["total_reviewed"],
      );

  Map<String, dynamic> toJson() => {
        "test_id": testId == null ? 0 : testId,
        "total_attempted": totalAttempted == null ? 0 : totalAttempted,
        "total_question": totalQuestion == null ? 0 : totalQuestion,
        "total_reviewed": totalReviewed == null ? 0 : totalReviewed,
      };
}
