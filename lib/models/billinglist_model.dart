// To parse this JSON data, do
//
//     final billingListModel = billingListModelFromJson(jsonString);

import 'dart:convert';

BillingListModel billingListModelFromJson(String str) =>
    BillingListModel.fromJson(json.decode(str));

String billingListModelToJson(BillingListModel data) =>
    json.encode(data.toJson());

class BillingListModel {
  BillingListModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<BillingInformationData>? data;

  factory BillingListModel.fromJson(Map<String, dynamic> json) =>
      BillingListModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: json["data"] == null
            ? []
            : List<BillingInformationData>.from(
                json["data"].map((x) => BillingInformationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BillingInformationData {
  BillingInformationData({
    this.id,
    this.userId,
    this.fullname,
    this.mobile,
    this.email,
    this.addressOne,
    this.addressTwo,
    this.addressThree,
    this.pincode,
    this.isDefaultAddress,
  });

  int? id;
  int? userId;
  String? fullname;
  String? mobile;
  String? email;
  String? addressOne;
  String? addressTwo;
  String? addressThree;
  String? pincode;
  int? isDefaultAddress;

  factory BillingInformationData.fromJson(Map<String, dynamic> json) =>
      BillingInformationData(
        id: (json["id"] == null) ? null : json["id"],
        userId: (json["user_id"] == null) ? null : json["user_id"],
        fullname: (json["fullname"] == null) ? null : json["fullname"],
        mobile: (json["mobile"] == null) ? null : json["mobile"],
        email: (json["email"] == null) ? null : json["email"],
        addressOne: (json["address_one"] == null) ? null : json["address_one"],
        addressTwo: (json["address_two"] == null) ? null : json["address_two"],
        addressThree:
            (json["address_three"] == null) ? null : json["address_three"],
        pincode: (json["pincode"] == null) ? null : json["pincode"],
        isDefaultAddress: (json["is_default_address"] == null)
            ? null
            : json["is_default_address"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "user_id": (userId == null) ? null : userId,
        "fullname": (fullname == null) ? null : fullname,
        "mobile": (mobile == null) ? null : mobile,
        "email": (email == null) ? null : email,
        "address_one": (addressOne == null) ? null : addressOne,
        "address_two": (addressTwo == null) ? null : addressTwo,
        "address_three": (addressThree == null) ? null : addressThree,
        "pincode": (pincode == null) ? null : pincode,
        "is_default_address":
            (isDefaultAddress == null) ? null : isDefaultAddress,
      };
}
