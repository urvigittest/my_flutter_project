// To parse this JSON data, do
//
//     final mainCategoryModel = mainCategoryModelFromJson(jsonString);

import 'dart:convert';

MainCategoryModel mainCategoryModelFromJson(String str) =>
    MainCategoryModel.fromJson(json.decode(str));

String mainCategoryModelToJson(MainCategoryModel data) =>
    json.encode(data.toJson());

class MainCategoryModel {
  MainCategoryModel({
    this.status,
    this.message,
    this.link,
    this.data,
    this.carttotal,
  });

  bool? status;
  String? message;
  String? link;
  List<MainCategoryData>? data;
  int? carttotal;

  factory MainCategoryModel.fromJson(Map<String, dynamic> json) =>
      MainCategoryModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        link: (json["link"] == null) ? '' : json["link"],
        carttotal: (json["cart_total"] == null) ? 0 : json["cart_total"],
        data: (json["data"] == null)
            ? null
            : List<MainCategoryData>.from(
                json["data"].map((x) => MainCategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "link": (link == null) ? null : link,
        "cart_total": (carttotal == null) ? 0 : carttotal,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MainCategoryData {
  MainCategoryData(
    this.id,
    this.categoryid,
    this.name,
    this.categoryname,
    this.image,
    this.code,
    this.discount,
  );

  int? id;
  int? categoryid;
  String? name;
  String? categoryname;
  String? image;
  String? code;
  String? discount;

  factory MainCategoryData.fromJson(Map<String, dynamic> json) =>
      MainCategoryData(
        (json["id"] == null) ? 0 : json["id"],
        (json["category_id"] == null) ? 0 : json["category_id"],
        (json["name"] == null) ? null : json["name"],
        (json["category_name"] == null) ? null : json["category_name"],
        (json["image"] == null) ? '' : json["image"],
        (json["code"] == null) ? '' : json["code"],
        (json["discount"] == null) ? '0' : json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? 0 : id,
        "category_id": (categoryid == null) ? 0 : categoryid,
        "name": (name == null) ? null : name,
        "category_name": (categoryname == null) ? null : categoryname,
        "image": (image == null) ? '' : image,
        "code": (code == null) ? null : code,
        "discount": (discount == null) ? '0' : discount,
      };
}
