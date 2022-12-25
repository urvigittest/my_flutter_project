// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  HomeModel({
    this.status,
    this.message,
    this.getSlider,
    this.subcategory,
    this.selectedCategoryList,
    this.userSubscription,
    this.unreadNotification,
  });

  bool? status;
  String? message;
  List<GetSlider>? getSlider;
  List<Subcategory>? subcategory;
  List<SelectedCategoryList>? selectedCategoryList;
  UserSubscription? userSubscription;
  int? unreadNotification;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        getSlider: json["get_slider"] == null
            ? []
            : List<GetSlider>.from(
                json["get_slider"].map((x) => GetSlider.fromJson(x))),
        subcategory: json["subcategory"] == null
            ? []
            : List<Subcategory>.from(
                json["subcategory"].map((x) => Subcategory.fromJson(x))),
        selectedCategoryList: json["selected_category_list"] == null
            ? []
            : List<SelectedCategoryList>.from(json["selected_category_list"]
                .map((x) => SelectedCategoryList.fromJson(x))),
        userSubscription: json["user_subscription"] == null
            ? null
            : UserSubscription.fromJson(json["user_subscription"]),
        unreadNotification: json["unread_notification"] == null
            ? 0
            : json["unread_notification"],
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "get_slider": getSlider == null
            ? []
            : List<dynamic>.from(getSlider!.map((x) => x.toJson())),
        "subcategory": subcategory == null
            ? []
            : List<dynamic>.from(subcategory!.map((x) => x.toJson())),
        "selected_category_list": selectedCategoryList == null
            ? []
            : List<dynamic>.from(selectedCategoryList!.map((x) => x.toJson())),
        "user_subscription":
            userSubscription == null ? null : userSubscription!.toJson(),
        "unread_notification":
            unreadNotification == null ? 0 : unreadNotification,
      };
}

class GetSlider {
  GetSlider({
    this.id,
    this.title,
    this.image,
  });

  int? id;
  String? title;
  String? image;

  factory GetSlider.fromJson(Map<String, dynamic> json) => GetSlider(
        id: (json["id"] == null) ? null : json["id"],
        title: (json["title"] == null) ? null : json["title"],
        image: (json["image"] == null) ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "title": (title == null) ? null : title,
        "image": (image == null) ? null : image,
      };
}

class SelectedCategoryList {
  SelectedCategoryList({
    this.categoryId,
    this.categoryName,
  });

  int? categoryId;
  String? categoryName;

  factory SelectedCategoryList.fromJson(Map<String, dynamic> json) =>
      SelectedCategoryList(
        categoryId: (json["category_id"] == null) ? null : json["category_id"],
        categoryName:
            (json["category_name"] == null) ? null : json["category_name"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": (categoryId == null) ? null : categoryId,
        "category_name": (categoryName == null) ? null : categoryName,
      };
}

class Subcategory {
  Subcategory({
    this.subCategoryId,
    this.subCategoryName,
    this.subCategoryImage,
  });

  int? subCategoryId;
  String? subCategoryName;
  String? subCategoryImage;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        subCategoryId:
            (json["sub_category_id"] == null) ? null : json["sub_category_id"],
        subCategoryName: (json["sub_category_name"] == null)
            ? null
            : json["sub_category_name"],
        subCategoryImage: (json["sub_category_image"] == null)
            ? null
            : json["sub_category_image"],
      );

  Map<String, dynamic> toJson() => {
        "sub_category_id": (subCategoryId == null) ? null : subCategoryId,
        "sub_category_name": (subCategoryName == null) ? null : subCategoryName,
        "sub_category_image":
            (subCategoryImage == null) ? null : subCategoryImage,
      };
}

class UserSubscription {
  UserSubscription({
    this.totalPractice,
    this.totalPyq,
    this.totalTest,
  });

  int? totalPractice;
  int? totalPyq;
  int? totalTest;

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      UserSubscription(
        totalPractice:
            (json["total_practice"] == null) ? null : json["total_practice"],
        totalPyq: (json["total_pyq"] == null) ? null : json["total_pyq"],
        totalTest: (json["total_test"] == null) ? null : json["total_test"],
      );

  Map<String, dynamic> toJson() => {
        "total_practice": (totalPractice == null) ? null : totalPractice,
        "total_pyq": (totalPyq == null) ? null : totalPyq,
        "total_test": (totalTest == null) ? null : totalTest,
      };
}
