// To parse this JSON data, do
//
//     final testSubjectModel = testSubjectModelFromJson(jsonString);

import 'dart:convert';

TestSubjectModel testSubjectModelFromJson(String str) =>
    TestSubjectModel.fromJson(json.decode(str));

String testSubjectModelToJson(TestSubjectModel data) =>
    json.encode(data.toJson());

class TestSubjectModel {
  TestSubjectModel({
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
  List<TestSubjectData>? data;
  int? lastPage;
  int? total;
  int? from;
  int? to;
  int? perPage;
  int? currentPage;

  factory TestSubjectModel.fromJson(Map<String, dynamic> json) =>
      TestSubjectModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<TestSubjectData>.from(
                json["data"].map((x) => TestSubjectData.fromJson(x))),
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

class TestSubjectData {
  TestSubjectData({
    this.id,
    this.testName,
    this.activationDateTime,
    this.testStatus,
  });

  int? id;
  String? testName;
  DateTime? activationDateTime;
  int? testStatus;

  factory TestSubjectData.fromJson(Map<String, dynamic> json) =>
      TestSubjectData(
        id: json["id"] == null ? null : json["id"],
        testName: json["test_name"] == null ? null : json["test_name"],
        activationDateTime: json["activation_date_time"] == null
            ? DateTime.parse('0000-00-00 00:00:00')
            : DateTime.parse(json["activation_date_time"]),
        testStatus: json["test_status"] == null ? 1 : json["test_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "test_name": testName == null ? null : testName,
        "activation_date_time": activationDateTime == null
            ? DateTime.parse('0000-00-00 00:00:00').toString()
            : activationDateTime!.toIso8601String(),
        "test_status": testStatus == null ? null : testStatus,
      };
}
