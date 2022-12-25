// To parse this JSON data, do
//
//     final blogModel = blogModelFromJson(jsonString);

import 'dart:convert';

BlogModel blogModelFromJson(String str) => BlogModel.fromJson(json.decode(str));

String blogModelToJson(BlogModel data) => json.encode(data.toJson());

class BlogModel {
  BlogModel(
    this.status,
    this.message,
    this.data,
  );

  bool? status;
  String? message;
  BlogData? data;

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
        (json["status"] == null) ? null : json["status"],
        (json["message"] == null) ? null : json["message"],
        json["data"] == null ? null : BlogData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class BlogData {
  BlogData({
    this.id,
    this.name,
    this.shortDescription,
    this.image,
    this.longDescription,
  });

  int? id;
  String? name;
  String? shortDescription;
  String? image;
  String? longDescription;

  factory BlogData.fromJson(Map<String, dynamic> json) => BlogData(
        id: (json["id"] == null) ? null : json["id"],
        name: (json["name"] == null) ? null : json["name"],
        shortDescription: (json["short_description"] == null)
            ? null
            : json["short_description"],
        image: (json["image"] == null) ? null : json["image"],
        longDescription: (json["long_description"] == null)
            ? null
            : json["long_description"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "name": (name == null) ? null : name,
        "short_description":
            (shortDescription == null) ? null : shortDescription,
        "image": (image == null) ? null : image,
        "long_description": (longDescription == null) ? null : longDescription,
      };
}
