// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.message,
    this.data,
    this.apiToken,
  });

  bool? status;
  String? message;
  LoginData? data;
  String? apiToken;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        data: (json["data"] == null) ? null : LoginData.fromJson(json["data"]),
        apiToken: (json["api_token"] == null) ? null : json["api_token"],
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "data": (data == null) ? null : data!.toJson(),
        "api_token": (apiToken == null) ? null : apiToken,
      };
}

class LoginData {
  LoginData({
    this.id,
    this.firstname,
    this.lastname,
    this.mobile,
    this.email,
    this.roleId,
    this.status,
    this.image,
    this.isCategorySelected,
    this.isnotificationsend,
  });

  int? id;
  String? firstname;
  String? lastname;
  String? mobile;
  String? email;
  int? roleId;
  int? status;
  String? image;
  int? isCategorySelected;
  int? isnotificationsend;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: (json["id"] == null) ? null : json["id"],
        firstname: (json["firstname"] == null) ? '' : json["firstname"],
        lastname: (json["lastname"] == null) ? '' : json["lastname"],
        mobile: (json["mobile"] == null) ? '' : json["mobile"],
        email: (json["email"] == null) ? '' : json["email"],
        roleId: (json["role_id"] == null) ? null : json["role_id"],
        status: (json["status"] == null) ? null : json["status"],
        image: (json["image"] == null) ? '' : json["image"],
        isCategorySelected: (json["is_category_selected"] == null)
            ? 0
            : json["is_category_selected"],
        isnotificationsend: (json["isnotificationsend"] == null)
            ? 0
            : json["isnotificationsend"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "firstname": (firstname == null) ? '' : firstname,
        "lastname": (lastname == null) ? '' : lastname,
        "mobile": (mobile == null) ? '' : mobile,
        "email": (email == null) ? '' : email,
        "role_id": (roleId == null) ? null : roleId,
        "status": (status == null) ? null : status,
        "image": (image == null) ? '' : image,
        "is_category_selected":
            (isCategorySelected == null) ? 0 : isCategorySelected,
        "isnotificationsend":
            (isnotificationsend == null) ? 0 : isnotificationsend,
      };
}
