// To parse this JSON data, do
//
//     final subjectDetailsModel = subjectDetailsModelFromJson(jsonString);

import 'dart:convert';

SubjectDetailsModel subjectDetailsModelFromJson(String str) =>
    SubjectDetailsModel.fromJson(json.decode(str));

String subjectDetailsModelToJson(SubjectDetailsModel data) =>
    json.encode(data.toJson());

class SubjectDetailsModel {
  SubjectDetailsModel({
    this.status,
    this.message,
    this.subject,
    this.subscription,
  });

  bool? status;
  String? message;
  Subject? subject;
  Subject? subscription;

  factory SubjectDetailsModel.fromJson(Map<String, dynamic> json) =>
      SubjectDetailsModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        subject: json["data"] == null ? null : Subject.fromJson(json["data"]),
        subscription:
            json["data"] == null ? null : Subject.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": subject == null ? null : subject!.toJson(),
        "data": subscription == null ? null : subscription!.toJson(),
      };
}

class Subject {
  Subject({
    this.id,
    this.name,
    this.description,
    this.image,
    this.details,
    this.subCategory,
    this.totalChapter,
    this.totalTopic,
    this.totalPracticeQuestion,
    this.subjectSubscription,
  });

  int? id;
  String? name;
  String? description;
  String? image;
  String? details;
  String? subCategory;
  int? totalChapter;
  int? totalTopic;
  int? totalPracticeQuestion;
  List<SubjectSubscription>? subjectSubscription;

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? '' : json["name"],
        description: (json["description"] == null) ? '' : json["description"],
        image: (json["image"] == null) ? '' : json["image"],
        details: (json["details"] == null) ? '' : json["details"],
        subCategory: (json["sub_category"] == null) ? '' : json["sub_category"],
        totalChapter: (json["total_chapter"] == null) ? 0 : json["total_chapter"],
        totalTopic: (json["total_topic"] == null) ? 0 : json["total_topic"],
        totalPracticeQuestion: (json["total_practice_question"] == null)
            ? 0
            : json["total_practice_question"],
        subjectSubscription: (json["subscription_plan"] == null)
            ? null
            : List<SubjectSubscription>.from(json["subscription_plan"]
                .map((x) => SubjectSubscription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? '' : name,
        "description": (description == null) ? '' : description,
        "image": (image == null) ? '' : image,
        "details": (details == null) ? '' : details,
        "sub_category": (subCategory == null) ? '' : subCategory,
        "total_chapter": (totalChapter == null) ? 0 : totalChapter,
        "total_topic": (totalTopic == null) ? 0 : totalTopic,
        "total_practice_question":
            (totalPracticeQuestion == null) ? 0 : totalPracticeQuestion,
        "subscription_plan": subjectSubscription == null
            ? null
            : List<dynamic>.from(subjectSubscription!.map((x) => x.toJson())),
      };
}

class SubjectSubscription {
  SubjectSubscription({
    this.id,
    this.name,
    this.image,
    this.duration,
    this.dummyPrice,
    this.price,
    this.is_active,
    this.expiry_date,
  });

  int? id;
  String? name;
  String? image;
  int? duration;
  int? dummyPrice;
  int? price;
  int? is_active;
  String? expiry_date;

  factory SubjectSubscription.fromJson(Map<String, dynamic> json) =>
      SubjectSubscription(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? '' : json["name"],
        image: (json["image"] == null) ? '' : json["image"],
        duration: (json["duration"] == null) ? 0 : json["duration"],
        dummyPrice: (json["dummy_price"] == null) ? 0 : json["dummy_price"],
        price: (json["price"] == null) ? 0 : json["price"],
        is_active: (json["is_active"] == null) ? 0 : json["is_active"],
        expiry_date: (json["expiry_date"] == null) ? '' : json["expiry_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? '' : name,
        "image": (image == null) ? '' : image,
        "duration": (duration == null) ? 0 : duration,
        "dummy_price": (dummyPrice == null) ? 0 : dummyPrice,
        "price": (price == null) ? 0 : price,
        "is_active": (is_active == null) ? 0 : is_active,
        "expiry_date": (expiry_date == null) ? '' : expiry_date,
      };
}
