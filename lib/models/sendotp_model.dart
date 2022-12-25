// To parse this JSON data, do
//
//     final sendOtpModel = sendOtpModelFromJson(jsonString);

import 'dart:convert';

SendOtpModel sendOtpModelFromJson(String str) =>
    SendOtpModel.fromJson(json.decode(str));

String sendOtpModelToJson(SendOtpModel data) => json.encode(data.toJson());

class SendOtpModel {
  SendOtpModel(
    this.status,
    this.message,
    this.userId,
  );

  bool? status;
  String? message;
  int? userId;

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
        (json["status"] == null) ? null : json["status"],
        (json["message"] == null) ? null : json["message"],
        (json["user_id"] == null) ? 0 : json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "user_id": (userId == null) ? null : userId,
      };
}
