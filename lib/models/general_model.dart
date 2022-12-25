// To parse this JSON data, do
//
//     final generalModel = generalModelFromJson(jsonString);

import 'dart:convert';

GeneralModel generalModelFromJson(String str) =>
    GeneralModel.fromJson(json.decode(str));

String generalModelToJson(GeneralModel data) => json.encode(data.toJson());

class GeneralModel {
  GeneralModel({
    this.status,
    this.message,
    this.imagePath,
  });

  bool? status;
  String? message;
  String? imagePath;

  factory GeneralModel.fromJson(Map<String, dynamic> json) => GeneralModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        imagePath: json["image_path"] == null ? '' : json["image_path"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "image_path": imagePath == null ? '' : imagePath,
      };
}
