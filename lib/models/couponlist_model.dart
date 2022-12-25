// To parse this JSON data, do
//
//     final couponListModel = couponListModelFromJson(jsonString);

import 'dart:convert';

CouponListModel couponListModelFromJson(String str) =>
    CouponListModel.fromJson(json.decode(str));

String couponListModelToJson(CouponListModel data) =>
    json.encode(data.toJson());

class CouponListModel {
  CouponListModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<CouponListData>? data;

  factory CouponListModel.fromJson(Map<String, dynamic> json) =>
      CouponListModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<CouponListData>.from(
                json["data"].map((x) => CouponListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CouponListData {
  CouponListData({
    this.id,
    this.name,
    this.code,
    this.discountType,
    this.discountValue,
    this.maximumDiscountAmount,
    this.description,
    this.startDate,
    this.endDate,
  });

  int? id;
  String? name;
  String? code;
  int? discountType;
  int? discountValue;
  int? maximumDiscountAmount;
  String? description;
  DateTime? startDate;
  DateTime? endDate;

  factory CouponListData.fromJson(Map<String, dynamic> json) => CouponListData(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? '' : json["name"],
        code: (json["code"] == null) ? '' : json["code"],
        discountType:
            (json["discount_type"] == null) ? 0 : json["discount_type"],
        discountValue:
            (json["discount_value"] == null) ? 0 : json["discount_value"],
        maximumDiscountAmount: (json["maximum_discount_amount"] == null)
            ? 0
            : json["maximum_discount_amount"],
        description: (json["description"] == null) ? '' : json["description"],
        startDate: json["start_date"] == null
            ? DateTime.parse('0000-00-00 00:00:00')
            : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null
            ? DateTime.parse('0000-00-00 00:00:00')
            : DateTime.parse(json["end_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? null : name,
        "code": (code == null) ? null : code,
        "discount_type": (discountType == null) ? null : discountType,
        "discount_value": (discountValue == null) ? null : discountValue,
        "maximum_discount_amount":
            (maximumDiscountAmount == null) ? null : maximumDiscountAmount,
        "description": (description == null) ? null : description,
        "start_date": startDate == null
            ? null
            : "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date": endDate == null
            ? null
            : "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
      };
}
