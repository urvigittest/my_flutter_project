// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/state_manager.dart';

NotificationListModel notificationListModelFromJson(String str) =>
    NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) =>
    json.encode(data.toJson());

class NotificationListModel {
  NotificationListModel({
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
  List<NotificationData>? data;
  int? lastPage;
  int? total;
  int? from;
  int? to;
  int? perPage;
  int? currentPage;

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      NotificationListModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<NotificationData>.from(
                json["data"].map((x) => NotificationData.fromJson(x))),
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

class NotificationData {
  NotificationData({
    this.id,
    this.notificationId,
    this.title,
    this.message,
    this.isRead,
    this.image,
  });

  int? id;
  int? notificationId;
  String? title;
  String? message;
  String? image;
  int? isRead;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"] == null ? null : json["id"],
        notificationId:
            json["notification_id"] == null ? null : json["notification_id"],
        title: json["title"] == null ? '' : json["title"],
        message: json["message"] == null ? '' : json["message"],
        image: json["image"] == null ? '' : json["image"],
        isRead: json["is_read"] == null ? 0 : json["is_read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "notification_id": notificationId == null ? null : notificationId,
        "title": title == null ? '' : title,
        "message": message == null ? '' : message,
        "image": image == null ? '' : image,
        "is_read": isRead == null ? 0 : isRead,
      };
}
