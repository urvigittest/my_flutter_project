// // To parse this JSON data, do
// //
// //     final idStringNameModel = idStringNameModelFromJson(jsonString);

// import 'dart:convert';

// List<IdStringNameModel> idStringNameModelFromJson(String str) =>
//     List<IdStringNameModel>.from(
//         json.decode(str).map((x) => IdStringNameModel.fromJson(x)));

// String idStringNameModelToJson(List<IdStringNameModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class IdStringNameModel {
//   IdStringNameModel({
//     this.id,
//     this.name,
//   });

//   String? id;
//   String? name;

//   factory IdStringNameModel.fromJson(Map<String, dynamic> json) =>
//       IdStringNameModel(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id == null ? null : id,
//         "name": name == null ? null : name,
//       };
// }

// To parse this JSON data, do
//
//     final idStringNameModel = idStringNameModelFromJson(jsonString);

import 'dart:convert';

List<IdStringNameModel> idStringNameModelFromJson(String str) =>
    List<IdStringNameModel>.from(
        json.decode(str).map((x) => IdStringNameModel.fromJson(x)));

String idStringNameModelToJson(List<IdStringNameModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class IdStringNameModel {
  IdStringNameModel({
    this.id,
    this.brand,
    this.name,
    this.isSelected,
    this.price,
    this.priceSign,
    this.currency,
    this.imageLink,
    this.productLink,
    this.websiteLink,
    this.description,
    this.rating,
    this.category,
    this.productType,
    this.tagList,
    this.createdAt,
    this.updatedAt,
    this.productApiUrl,
    this.apiFeaturedImage,
    this.productColors,
  });

  int? id;
  Brand? brand;
  String? name;
  bool? isSelected;
  String? price;
  dynamic priceSign;
  dynamic currency;
  String? imageLink;
  String? productLink;
  String? websiteLink;
  String? description;
  double? rating;
  String? category;
  String? productType;
  List<dynamic>? tagList;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? productApiUrl;
  String? apiFeaturedImage;
  List<ProductColor>? productColors;

  factory IdStringNameModel.fromJson(Map<String, dynamic> json) =>
      IdStringNameModel(
        id: (json["id"] == null) ? null : json["id"],
        brand: (json["brand"] == null) ? null : brandValues.map![json["brand"]],
        name: (json["name"] == null) ? null : json["name"],
        price: (json["price"] == null) ? null : json["price"],
        isSelected: (json["isSelected"] == null) ? false : json["isSelected"],
        priceSign: json["price_sign"],
        currency: json["currency"],
        imageLink: (json["image_link"] == null) ? null : json["image_link"],
        productLink:
            (json["product_link"] == null) ? null : json["product_link"],
        websiteLink:
            (json["website_link"] == null) ? null : json["website_link"],
        description: (json["description"] == null) ? null : json["description"],
        rating: (json["rating"] == null) ? null : json["rating"].toDouble(),
        category: (json["category"] == null) ? null : json["category"],
        productType:
            (json["product_type"] == null) ? null : json["product_type"],
        tagList: json["tag_list"] == null
            ? null
            : List<dynamic>.from(json["tag_list"].map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        productApiUrl:
            (json["product_api_url"] == null) ? null : json["product_api_url"],
        apiFeaturedImage: (json["api_featured_image"] == null)
            ? null
            : json["api_featured_image"],
        productColors: json["product_colors"] == null
            ? null
            : List<ProductColor>.from(
                json["product_colors"].map((x) => ProductColor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": (id == null) ? null : id,
        "brand": (brand == null) ? null : brandValues.reverse![brand],
        "name": (name == null) ? null : name,
        "isSelected": (isSelected == null) ? false : isSelected,
        "price": (price == null) ? null : price,
        "price_sign": priceSign,
        "currency": currency,
        "image_link": (imageLink == null) ? null : imageLink,
        "product_link": (productLink == null) ? null : productLink,
        "website_link": (websiteLink == null) ? null : websiteLink,
        "description": (description == null) ? null : description,
        "rating": (rating == null) ? null : rating,
        "category": (category == null) ? null : category,
        "product_type": (productType == null) ? null : productType,
        "tag_list":
            tagList == null ? null : List<dynamic>.from(tagList!.map((x) => x)),
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "product_api_url": (productApiUrl == null) ? null : productApiUrl,
        "api_featured_image":
            (apiFeaturedImage == null) ? null : apiFeaturedImage,
        "product_colors": productColors == null
            ? null
            : List<dynamic>.from(productColors!.map((x) => x.toJson())),
      };
}

enum Brand { MAYBELLINE }

final brandValues = EnumValues({"maybelline": Brand.MAYBELLINE});

class ProductColor {
  ProductColor({
    this.hexValue,
    this.colourName,
  });

  String? hexValue;
  String? colourName;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        hexValue: (json["hex_value"] == null) ? null : json["hex_value"],
        colourName: (json["colour_name"] == null) ? null : json["colour_name"],
      );

  Map<String, dynamic> toJson() => {
        "hex_value": (hexValue == null) ? null : hexValue,
        "colour_name": (colourName == null) ? null : colourName,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
