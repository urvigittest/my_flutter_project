// To parse this JSON data, do
//
//     final questionWiseModel = questionWiseModelFromJson(jsonString);

import 'dart:convert';

QuestionWiseModel questionWiseModelFromJson(String str) =>
    QuestionWiseModel.fromJson(json.decode(str));

String questionWiseModelToJson(QuestionWiseModel data) =>
    json.encode(data.toJson());

class QuestionWiseModel {
  QuestionWiseModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<QuestionWiseData>? data;

  factory QuestionWiseModel.fromJson(Map<String, dynamic> json) =>
      QuestionWiseModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<QuestionWiseData>.from(
                json["data"].map((x) => QuestionWiseData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class QuestionWiseData {
  QuestionWiseData({
    this.srNo,
    this.id,
    this.marks,
    this.takenTime,
    this.bestTakenTime,
  });

  int? srNo;
  int? id;
  dynamic? marks;
  int? takenTime;
  int? bestTakenTime;

  factory QuestionWiseData.fromJson(Map<String, dynamic> json) =>
      QuestionWiseData(
        srNo: json["sr_no"] == null ? null : json["sr_no"],
        id: json["id"] == null ? null : json["id"],
        marks: json["marks"] == null ? 0 : json["marks"],
        takenTime: json["taken_time"] == null ? 0 : json["taken_time"],
        bestTakenTime:
            json["best_taken_time"] == null ? 0 : json["best_taken_time"],
      );

  Map<String, dynamic> toJson() => {
        "sr_no": srNo == null ? null : srNo,
        "id": id == null ? null : id,
        "marks": marks == null ? 0 : marks,
        "taken_time": takenTime == null ? 0 : takenTime,
        "best_taken_time": bestTakenTime == null ? 0 : bestTakenTime,
      };
}
