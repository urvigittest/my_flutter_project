// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.status,
    this.message,
    this.studentCart,
    this.gst,
  });

  bool? status;
  String? message;
  List<StudentCart>? studentCart;
  Gst? gst;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        studentCart: json["student_cart"] == null
            ? []
            : List<StudentCart>.from(
                json["student_cart"].map((x) => StudentCart.fromJson(x))),
        gst: json["gst"] == null ? null : Gst.fromJson(json["gst"]),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "student_cart": studentCart == null
            ? []
            : List<dynamic>.from(studentCart!.map((x) => x.toJson())),
        "gst": gst == null ? null : gst!.toJson(),
      };
}

class Gst {
  Gst({
    this.cgst,
    this.sgst,
    this.igst,
  });

  int? cgst;
  int? sgst;
  int? igst;

  factory Gst.fromJson(Map<String, dynamic> json) => Gst(
        cgst: (json["cgst"] == null) ? 0 : json["cgst"],
        sgst: (json["sgst"] == null) ? 0 : json["sgst"],
        igst: (json["igst"] == null) ? 0 : json["igst"],
      );

  Map<String, dynamic> toJson() => {
        "cgst": (cgst == null) ? 0 : cgst,
        "sgst": (sgst == null) ? 0 : sgst,
        "igst": (igst == null) ? 0 : igst,
      };
}

class StudentCart {
  StudentCart({
    this.id,
    this.userId,
    this.subscriptionId,
    this.name,
    this.duration,
    this.dummyPrice,
    this.price,
    this.type,
    this.image,
  });

  int? id;
  int? userId;
  int? subscriptionId;
  String? name;
  int? duration;
  int? dummyPrice;
  int? price;
  String? type;
  String? image;

  factory StudentCart.fromJson(Map<String, dynamic> json) => StudentCart(
        id: (json["id"] == null) ? null : json["id"],
        userId: (json["user_id"] == null) ? null : json["user_id"],
        subscriptionId:
            (json["subscription_id"] == null) ? null : json["subscription_id"],
        name: (json["name"] == null) ? '' : json["name"],
        duration: (json["duration"] == null) ? 0 : json["duration"],
        dummyPrice: (json["dummy_price"] == null) ? 0 : json["dummy_price"],
        price: (json["price"] == null) ? 0 : json["price"],
        type: (json["type"] == null) ? '' : json["type"],
        image: (json["image"] == null) ? '' : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "user_id": (userId == null) ? null : userId,
        "subscription_id": (subscriptionId == null) ? null : subscriptionId,
        "name": (name == null) ? '' : name,
        "duration": (duration == null) ? 0 : duration,
        "dummy_price": (dummyPrice == null) ? 0 : dummyPrice,
        "price": (price == null)? 0 : price,
        "type": (type == null) ? '' : type,
        "image": (image == null) ? '' : image,
      };
}
