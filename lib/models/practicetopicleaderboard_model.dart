// To parse this JSON data, do
//
//     final practiceTopicLeaderBoardModel = practiceTopicLeaderBoardModelFromJson(jsonString);

import 'dart:convert';

PracticeTopicLeaderBoardModel practiceTopicLeaderBoardModelFromJson(
        String str) =>
    PracticeTopicLeaderBoardModel.fromJson(json.decode(str));

String practiceTopicLeaderBoardModelToJson(
        PracticeTopicLeaderBoardModel data) =>
    json.encode(data.toJson());

class PracticeTopicLeaderBoardModel {
  PracticeTopicLeaderBoardModel({
    this.status,
    this.message,
    this.data,
    this.lastPage,
    this.total,
    this.from,
    this.to,
    this.perPage,
    this.currentPage,
    this.isCurrentUserInArray,
    this.currentUser,
    this.topThreeUser,
  });

  bool? status;
  String? message;
  List<CurrentUser>? data;
  int? lastPage;
  int? total;
  int? from;
  int? to;
  int? perPage;
  int? currentPage;
  int? isCurrentUserInArray;
  CurrentUser? currentUser;
  List<CurrentUser>? topThreeUser;

  factory PracticeTopicLeaderBoardModel.fromJson(Map<String, dynamic> json) =>
      PracticeTopicLeaderBoardModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<CurrentUser>.from(
                json["data"].map((x) => CurrentUser.fromJson(x))),
        lastPage: (json["last_page"] == null) ? 0 : json["last_page"],
        total: (json["total"] == null) ? 0 : json["total"],
        from: (json["from"] == null) ? 0 : json["from"],
        to: (json["to"] == null) ? 0 : json["to"],
        perPage: (json["per_page"] == null) ? 0 : json["per_page"],
        currentPage: (json["current_page"] == null) ? 0 : json["current_page"],
        isCurrentUserInArray: (json["is_current_user_in_array"] == null)
            ? 0
            : json["is_current_user_in_array"],
        currentUser: json["current_user"] == null
            ? null
            : CurrentUser.fromJson(json["current_user"]),
        topThreeUser: json["top_three_user"] == null
            ? []
            : List<CurrentUser>.from(
                json["top_three_user"].map((x) => CurrentUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "last_page": (lastPage == null) ? 0 : lastPage,
        "total": (total == null) ? 0 : total,
        "from": (from == null) ? 0 : from,
        "to": (to == null) ? 0 : to,
        "per_page": (perPage == null) ? 0 : perPage,
        "current_page": (currentPage == null) ? 0 : currentPage,
        "is_current_user_in_array":
            (isCurrentUserInArray == null) ? 0 : isCurrentUserInArray,
        "current_user": currentUser == null ? null : currentUser!.toJson(),
        "top_three_user": topThreeUser == null
            ? []
            : List<dynamic>.from(topThreeUser!.map((x) => x.toJson())),
      };
}

class CurrentUser {
  CurrentUser({
    this.id,
    this.rankNo,
    this.fullname,
    this.image,
    this.percentage,
  });

  int? id;
  int? rankNo;
  String? fullname;

  String? image;
  dynamic percentage;

  factory CurrentUser.fromJson(Map<String, dynamic> json) => CurrentUser(
        id: (json["id"] == null) ? null : json["id"],
        rankNo: (json["rank_no"] == null) ? 0 : json["rank_no"],
        fullname: (json["fullname"] == null) ? '' : json["fullname"],
        image: (json["image"] == null) ? '' : json["image"],
        percentage:
            (json["percentage"] == null) ? 0 : double.parse(json["percentage"]),
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "rank_no": (rankNo == null) ? 0 : rankNo,
        "fullname": (fullname == null) ? '' : fullname,
        "image": (image == null) ? '' : image,
        "percentage": (percentage == null) ? 0 : percentage,
      };
}



// // To parse this JSON data, do
// //
// //     final practiceTopicLeaderBoardModel = practiceTopicLeaderBoardModelFromJson(jsonString);

// import 'dart:convert';

// PracticeTopicLeaderBoardModel practiceTopicLeaderBoardModelFromJson(
//         String str) =>
//     PracticeTopicLeaderBoardModel.fromJson(json.decode(str));

// String practiceTopicLeaderBoardModelToJson(
//         PracticeTopicLeaderBoardModel data) =>
//     json.encode(data.toJson());

// class PracticeTopicLeaderBoardModel {
//   PracticeTopicLeaderBoardModel({
//     this.status,
//     this.message,
//     this.data,
//     this.lastPage,
//     this.total,
//     this.from,
//     this.to,
//     this.perPage,
//     this.currentPage,
//   });

//   bool? status;
//   String? message;
//   List<PracticeTopicLeaderBoardData>? data;
//   int? lastPage;
//   int? total;
//   int? from;
//   int? to;
//   int? perPage;
//   int? currentPage;

//   factory PracticeTopicLeaderBoardModel.fromJson(Map<String, dynamic> json) =>
//       PracticeTopicLeaderBoardModel(
//         status: json["status"] == null ? null : json["status"],
//         message: json["message"] == null ? null : json["message"],
//         data: json["data"] == null
//             ? null
//             : List<PracticeTopicLeaderBoardData>.from(json["data"]
//                 .map((x) => PracticeTopicLeaderBoardData.fromJson(x))),
//         lastPage: json["last_page"] == null ? null : json["last_page"],
//         total: json["total"] == null ? 0 : json["total"],
//         from: json["from"] == null ? 0 : json["from"],
//         to: json["to"] == null ? 0 : json["to"],
//         perPage: json["per_page"] == null ? 0 : json["per_page"],
//         currentPage: json["current_page"] == null ? 0 : json["current_page"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status == null ? null : status,
//         "message": message == null ? null : message,
//         "data": data == null
//             ? null
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//         "last_page": lastPage == null ? 0 : lastPage,
//         "total": total == null ? 0 : total,
//         "from": from == null ? 0 : from,
//         "to": to == null ? 0 : to,
//         "per_page": perPage == null ? 0 : perPage,
//         "current_page": currentPage == null ? 0 : currentPage,
//       };
// }

// class PracticeTopicLeaderBoardData {
//   PracticeTopicLeaderBoardData({
//     this.id,
//     this.rankNo,
//     this.fullname,
//     this.image,
//     this.percentage,
//     this.currentUserTop,
//   });

//   int? id;
//   int? rankNo;
//   String? fullname;
//   dynamic image;
//   String? percentage;
//   int? currentUserTop;

//   factory PracticeTopicLeaderBoardData.fromJson(Map<String, dynamic> json) =>
//       PracticeTopicLeaderBoardData(
//         id: json["id"] == null ? null : json["id"],
//         rankNo: json["rank_no"] == null ? 0 : json["rank_no"],
//         fullname: json["fullname"] == null ? '' : json["fullname"],
//         image: json["image"] == null ? '' : json["image"],
//         percentage: json["percentage"] == null ? '0' : json["percentage"],
//         currentUserTop:
//             json["current_user_top"] == null ? 0 : json["current_user_top"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "rank_no": rankNo == null ? 0 : rankNo,
//         "fullname": fullname == null ? '' : fullname,
//         "image": image == null ? '' : image,
//         "percentage": percentage == null ? '0' : percentage,
//         "current_user_top": currentUserTop == null ? 0 : currentUserTop,
//       };
// }
