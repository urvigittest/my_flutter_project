// To parse this JSON data, do
//
//     final couponApplyModel = couponApplyModelFromJson(jsonString);

import 'dart:convert';

CouponApplyModel couponApplyModelFromJson(String str) =>
    CouponApplyModel.fromJson(json.decode(str));

String couponApplyModelToJson(CouponApplyModel data) =>
    json.encode(data.toJson());

class CouponApplyModel {
  CouponApplyModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory CouponApplyModel.fromJson(Map<String, dynamic> json) =>
      CouponApplyModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.code,
    this.discount,
  });

  int? id;
  String? code;
  dynamic discount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: (json["id"] == null) ? null : json["id"],
        code: (json["code"] == null) ? null : json["code"],
        discount: (json["discount"] == null) ? 0 : json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "code": (code == null) ? null : code,
        "discount": (discount == null) ? 0 : discount,
      };
}
