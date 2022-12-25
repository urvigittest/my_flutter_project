// To parse this JSON data, do
//
//     final model = modelFromJson(jsonString);

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  OrderHistoryModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<OrderHistoryData>? data;

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) =>
      OrderHistoryModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<OrderHistoryData>.from(
                json["data"].map((x) => OrderHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class OrderHistoryData {
  OrderHistoryData({
    this.id,
    this.totalAmount,
    this.orderidenc,
    this.createdAt,
  });

  int? id;
  double? totalAmount;
  String? orderidenc;
  DateTime? createdAt;

  factory OrderHistoryData.fromJson(Map<String, dynamic> json) =>
      OrderHistoryData(
        id: json["id"] == null ? null : json["id"],
        orderidenc: json["order_id_enc"] == null ? '' : json["order_id_enc"],
        totalAmount: json["total_amount"] == null
            ? null
            : json["total_amount"].toDouble(),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "total_amount": totalAmount == null ? null : totalAmount,
        "order_id_enc": orderidenc == null ? null : orderidenc,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
      };
}
