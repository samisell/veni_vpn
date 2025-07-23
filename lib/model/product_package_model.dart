import 'dart:convert';

ProductPackageModel productPackageModelFromJson(String str) => ProductPackageModel.fromJson(json.decode(str));

String productPackageModelToJson(ProductPackageModel data) => json.encode(data.toJson());

class ProductPackageModel {
  final String? status;
  final String? message;
  final List<ProductPackage>? data;

  ProductPackageModel({
    this.status,
    this.message,
    this.data,
  });

  factory ProductPackageModel.fromJson(Map<String, dynamic> json) => ProductPackageModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ProductPackage>.from(json["data"]!.map((x) => ProductPackage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ProductPackage {
  final dynamic id;
  final String? packageName;
  final String? productId;
  final dynamic packageDuration;
  final String? packagePrice;
  final dynamic status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductPackage({
    this.id,
    this.packageName,
    this.productId,
    this.packageDuration,
    this.packagePrice,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductPackage.fromJson(Map<String, dynamic> json) => ProductPackage(
    id: json["id"],
    packageName: json["package_name"],
    productId: json["product_id"],
    packageDuration: json["package_duration"],
    packagePrice: json["package_price"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "package_name": packageName,
    "product_id": productId,
    "package_duration": packageDuration,
    "package_price": packagePrice,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
