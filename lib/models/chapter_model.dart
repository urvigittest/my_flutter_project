// To parse this JSON data, do
//
//     final chapterModel = chapterModelFromJson(jsonString);

import 'dart:convert';

ChapterModel chapterModelFromJson(String str) =>
    ChapterModel.fromJson(json.decode(str));

String chapterModelToJson(ChapterModel data) => json.encode(data.toJson());

class ChapterModel {
  ChapterModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<ChapterData>? data;

  factory ChapterModel.fromJson(Map<String, dynamic> json) => ChapterModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<ChapterData>.from(
                json["data"].map((x) => ChapterData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ChapterData {
  ChapterData({
    this.id,
    this.name,
    this.label,
    this.totalOngoingTopic,
    this.totalCompletedTopic,
    this.totalTopic,
  });

  int? id;
  String? name;
  String? label;
  int? totalOngoingTopic;
  int? totalCompletedTopic;
  int? totalTopic;

  factory ChapterData.fromJson(Map<String, dynamic> json) => ChapterData(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? '' : json["name"],
        label: (json["label"] == null) ? '' : json["label"],
        totalOngoingTopic: (json["total_ongoing_topic"] == null)
            ? 0
            : json["total_ongoing_topic"],
        totalCompletedTopic: (json["total_completed_topic"] == null)
            ? 0
            : json["total_completed_topic"],
        totalTopic: (json["total_topic"] == null) ? 0 : json["total_topic"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? '' : name,
        "label": (label == null) ? '' : label,
        "total_ongoing_topic":
            (totalOngoingTopic == null) ? 0 : totalOngoingTopic,
        "total_completed_topic":
            (totalCompletedTopic == null) ? 0 : totalCompletedTopic,
        "total_topic": (totalTopic == null) ? 0 : totalTopic,
      };
}
