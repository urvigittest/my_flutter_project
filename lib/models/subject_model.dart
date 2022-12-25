// To parse this JSON data, do
//
//     final subjectModel = subjectModelFromJson(jsonString);

import 'dart:convert';

SubjectModel subjectModelFromJson(String str) =>
    SubjectModel.fromJson(json.decode(str));

String subjectModelToJson(SubjectModel data) => json.encode(data.toJson());

class SubjectModel {
  SubjectModel({
    this.status,
    this.message,
    this.getSinglePlan,
    this.getSinglePlan2,
    this.getComboPlan,
  });

  bool? status;
  String? message;
  List<GetSinglePlan>? getSinglePlan;
  List<GetSinglePlan>? getSinglePlan2;
  List<GetSinglePlan>? getComboPlan;

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        getSinglePlan: json["get_single_plan"] == null
            ? []
            : List<GetSinglePlan>.from(
                json["get_single_plan"].map((x) => GetSinglePlan.fromJson(x))),
        getSinglePlan2: json["data"] == null
            ? []
            : List<GetSinglePlan>.from(
                json["data"].map((x) => GetSinglePlan.fromJson(x))),
        getComboPlan: json["get_combo_plan"] == null
            ? []
            : List<GetSinglePlan>.from(
                json["get_combo_plan"].map((x) => GetSinglePlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "get_single_plan": getSinglePlan == null
            ? []
            : List<dynamic>.from(getSinglePlan!.map((x) => x.toJson())),
        "data": getSinglePlan2 == null
            ? []
            : List<dynamic>.from(getSinglePlan2!.map((x) => x.toJson())),
        "get_combo_plan": getComboPlan == null
            ? []
            : List<dynamic>.from(getComboPlan!.map((x) => x.toJson())),
      };
}

class GetComboPlan {
  GetComboPlan({
    this.id,
    this.name,
    this.image,
    this.totalRatingUser,
    this.totalRating,
    this.totalSubject,
    this.subjectName,
    this.subjectId,
  });

  int? id;
  String? name;
  String? image;
  int? totalRatingUser;
  double? totalRating;
  int? totalSubject;
  String? subjectName;
  String? subjectId;

  factory GetComboPlan.fromJson(Map<String, dynamic> json) => GetComboPlan(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? null : json["name"],
        image: (json["image"] == null) ? null : json["image"],
        totalRatingUser: (json["total_rating_user"] == null)
            ? null
            : json["total_rating_user"],
        totalRating: (json["total_rating"] == null)
            ? null
            : json["total_rating"].toDouble(),
        totalSubject:
            (json["total_subject"] == null) ? null : json["total_subject"],
        subjectName: (json["subject_name"] == null) ? null : json["subject_name"],
        subjectId: (json["subject_id"] == null) ? null : json["subject_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? null : name,
        "image": (image == null) ? null : image,
        "total_rating_user": (totalRatingUser == null) ? null : totalRatingUser,
        "total_rating": (totalRating == null) ? null : totalRating,
        "total_subject": (totalSubject == null) ? null : totalSubject,
        "subject_name": (subjectName == null) ? null : subjectName,
        "subject_id": (subjectId == null) ? null : subjectId,
      };
}

class GetSinglePlan {
  GetSinglePlan({
    this.id,
    this.name,
    this.image,
    this.totalRatingUser,
    this.totalRating,
    this.totalSubject,
    this.subjectName,
    this.subjectId,
    this.is_active,
    this.expiry_date,
    this.total_enrolled,
    this.subscriptionPlan,
  });

  int? id;
  String? name;
  String? image;
  dynamic totalRatingUser;
  double? totalRating;
  int? totalSubject;
  String? subjectName;
  var subjectId;
  int? is_active;
  String? expiry_date;
  int? total_enrolled;
  List<SubscriptionPlan>? subscriptionPlan;

  factory GetSinglePlan.fromJson(Map<String, dynamic> json) => GetSinglePlan(
        id: (json["id"] == null) ? 0 : json["id"],
        name: (json["name"] == null) ? '' : json["name"],
        image: (json["image"] == null) ? '' : json["image"],
        totalRatingUser:
            (json["total_rating_user"] == null) ? 0.0 : json["total_rating_user"],
        totalRating: json["total_rating"] == null
            ? 0.0
            : json["total_rating"].toDouble(),
        totalSubject: (json["total_subject"] == null) ? 0 : json["total_subject"],
        subjectName: (json["subject_name"] == null) ? '' : json["subject_name"],
        subjectId: (json["subject_id"] == null) ? 0 : json["subject_id"],
        is_active: (json["is_active"] == null) ? 0 : json["is_active"],
        expiry_date: (json["expiry_date"] == null) ? '' : json["expiry_date"],
        total_enrolled:
        (json["total_enrolled"] == null) ? 0 : json["total_enrolled"],
        subscriptionPlan: json["subscription_plan"] == null
            ? null
            : List<SubscriptionPlan>.from(json["subscription_plan"]
                .map((x) => SubscriptionPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? null : name,
        "image": (image == null) ? null : image,
        "total_rating_user": (totalRatingUser == null) ? null : totalRatingUser,
        "total_rating": (totalRating == null) ? null : totalRating,
        "total_subject": (totalSubject == null) ? null : totalSubject,
        "subject_name": (subjectName == null) ? null : subjectName,
        "subject_id": (subjectId == null) ? null : subjectId,
        "is_active": (is_active == null) ? 0 : is_active,
        "expiry_date": (expiry_date == null) ? '' : expiry_date,
        "total_enrolled": (total_enrolled == null) ? '' : total_enrolled,
        "subscription_plan": subscriptionPlan == null
            ? null
            : List<dynamic>.from(subscriptionPlan!.map((x) => x.toJson())),
      };
}

class SubscriptionPlan {
  SubscriptionPlan({
    this.duration,
    this.dummyPrice,
    this.price,
    this.is_active,
  });

  int? duration;
  int? dummyPrice;
  int? price;
  int? is_active;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      SubscriptionPlan(
        duration: (json["duration"] == null) ? null : json["duration"],
        dummyPrice: (json["dummy_price"] == null) ? null : json["dummy_price"],
        price: (json["price"] == null) ? null : json["price"],
        is_active: (json["is_active"] == null) ? 0 : json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "duration": (duration == null) ? null : duration,
        "dummy_price": (dummyPrice == null) ? null : dummyPrice,
        "price": (price == null) ? null : price,
        "is_active": (is_active == null) ? 0 : is_active,
      };
}




// // To parse this JSON data, do
// //
// //     final subjectModel = subjectModelFromJson(jsonString);

// import 'dart:convert';

// SubjectModel subjectModelFromJson(String str) =>
//     SubjectModel.fromJson(json.decode(str));

// String subjectModelToJson(SubjectModel data) => json.encode(data.toJson());

// class SubjectModel {
//   SubjectModel({
//     this.status,
//     this.message,
//     this.getSinglePlan,
//     this.getComboPlan,
//     this.getSinglePlan2,
//   });

//   bool? status;
//   String? message;
//   List<GetPlan>? getSinglePlan;
//   List<GetPlan>? getComboPlan;
//   List<GetPlan>? getSinglePlan2;

//   factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
//         status: json["status"] == null ? null : json["status"],
//         message: json["message"] == null ? null : json["message"],
//         getSinglePlan: json["get_single_plan"] == null
//             ? null
//             : List<GetPlan>.from(
//                 json["get_single_plan"].map((x) => GetPlan.fromJson(x))),
//         getComboPlan: json["get_combo_plan"] == null
//             ? null
//             : List<GetPlan>.from(
//                 json["get_combo_plan"].map((x) => GetPlan.fromJson(x))),
//         getSinglePlan2: json["data"] == null
//             ? null
//             : List<GetPlan>.from(json["data"].map((x) => GetPlan.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status == null ? null : status,
//         "message": message == null ? null : message,
//         "get_single_plan": getSinglePlan == null
//             ? null
//             : List<dynamic>.from(getSinglePlan!.map((x) => x.toJson())),
//         "get_combo_plan": getComboPlan == null
//             ? null
//             : List<dynamic>.from(getComboPlan!.map((x) => x.toJson())),
//         "data": getSinglePlan2 == null
//             ? null
//             : List<dynamic>.from(getSinglePlan2!.map((x) => x.toJson())),
//       };
// }

// class GetPlan {
//   GetPlan({
//     this.id,
//     this.name,
//     this.image,
//     this.totalSubject,
//     this.subjectName,
//     this.subjectId,
//   });

//   int? id;
//   String? name;
//   String? image;
//   int? totalSubject;
//   String? subjectName;
//   dynamic subjectId;

//   factory GetPlan.fromJson(Map<String, dynamic> json) => GetPlan(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         image: json["image"] == null ? null : json["image"],
//         totalSubject:
//             json["total_subject"] == null ? null : json["total_subject"],
//         subjectName: json["subject_name"] == null ? null : json["subject_name"],
//         subjectId: json["subject_id"] == null ? null : json["subject_id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//         "image": image == null ? null : image,
//         "total_subject": totalSubject == null ? null : totalSubject,
//         "subject_name": subjectName == null ? null : subjectName,
//         "subject_id": subjectId == null ? null : subjectId,
//       };
// }
