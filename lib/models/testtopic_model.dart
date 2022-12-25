// To parse this JSON data, do
//
//     final testTopicModel = testTopicModelFromJson(jsonString);

import 'dart:convert';

TestTopicModel testTopicModelFromJson(String str) =>
    TestTopicModel.fromJson(json.decode(str));

String testTopicModelToJson(TestTopicModel data) => json.encode(data.toJson());

class TestTopicModel {
  TestTopicModel({
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
  List<TestTopicData>? data;
  int? lastPage;
  int? total;
  int? from;
  int? to;
  int? perPage;
  int? currentPage;

  factory TestTopicModel.fromJson(Map<String, dynamic> json) => TestTopicModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TestTopicData>.from(
                json["data"].map((x) => TestTopicData.fromJson(x))),
        lastPage: json["last_page"] == null ? null : json["last_page"],
        total: json["total"] == null ? null : json["total"],
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        perPage: json["per_page"] == null ? null : json["per_page"],
        currentPage: json["current_page"] == null ? null : json["current_page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": lastPage == null ? null : lastPage,
        "total": total == null ? null : total,
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "per_page": perPage == null ? null : perPage,
        "current_page": currentPage == null ? null : currentPage,
      };
}

class TestTopicData {
  TestTopicData({
    this.id,
    this.topicName,
    this.description,
    this.pdfDoc,
    this.getTest,
  });

  int? id;
  String? topicName;
  String? description;
  String? pdfDoc;
  List<GetTest>? getTest;

  factory TestTopicData.fromJson(Map<String, dynamic> json) => TestTopicData(
        id: json["id"] == null ? null : json["id"],
        topicName: json["topic_name"] == null ? null : json["topic_name"],
        description: json["description"] == null ? null : json["description"],
        pdfDoc: json["pdf_doc"] == null ? null : json["pdf_doc"],
        getTest: json["get_test"] == null
            ? null
            : List<GetTest>.from(
                json["get_test"].map((x) => GetTest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "topic_name": topicName == null ? null : topicName,
        "description": description == null ? null : description,
        "pdf_doc": pdfDoc == null ? null : pdfDoc,
        "get_test": getTest == null
            ? null
            : List<dynamic>.from(getTest!.map((x) => x.toJson())),
      };
}

class GetTest {
  GetTest({
    this.id,
    this.testName,
    this.topicId,
    this.activationDateTime,
    this.testStatus,
  });

  int? id;
  String? testName;
  int? topicId;
  DateTime? activationDateTime;
  int? testStatus;

  factory GetTest.fromJson(Map<String, dynamic> json) => GetTest(
        id: json["id"] == null ? null : json["id"],
        testName: json["test_name"] == null ? null : json["test_name"],
        topicId: json["topic_id"] == null ? null : json["topic_id"],
        activationDateTime: json["activation_date_time"] == null
            ? DateTime.parse('0000-00-00 00:00:00')
            : DateTime.parse(json["activation_date_time"]),
        testStatus: json["test_status"] == null ? 1 : json["test_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "test_name": testName == null ? null : testName,
        "topic_id": topicId == null ? null : topicId,
        "activation_date_time": activationDateTime == null
            ? DateTime.parse('0000-00-00 00:00:00')
            : activationDateTime!.toIso8601String(),
        "test_status": testStatus == null ? null : testStatus,
      };
}
