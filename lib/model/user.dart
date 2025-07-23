import 'product_package_model.dart';

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final int? isVerified;
  final String? loginMode;
  final String? deviceId;
  final dynamic profileImage;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserPackageDetails? userPackageDetails;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.isVerified,
    this.loginMode,
    this.deviceId,
    this.profileImage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userPackageDetails,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    isVerified: json["is_verified"],
    loginMode: json["login_mode"],
    deviceId: json["device_id"],
    profileImage: json["profile_image"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userPackageDetails: json["user_package_details"] == null ? null : UserPackageDetails.fromJson(json["user_package_details"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "is_verified": isVerified,
    "login_mode": loginMode,
    "device_id": deviceId,
    "profile_image": profileImage,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_package_details": userPackageDetails?.toJson(),
  };
}

class UserPackageDetails {
  final int? id;
  final int? userId;
  final int? packageId;
  final int? packageDuration;
  final DateTime? purchasedAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? packageName;

  UserPackageDetails({
    this.id,
    this.userId,
    this.packageId,
    this.packageDuration,
    this.purchasedAt,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
    this.packageName,
  });

  factory UserPackageDetails.fromJson(Map<String, dynamic> json) => UserPackageDetails(
    id: json["id"],
    userId: json["user_id"],
    packageId: json["package_id"],
    packageDuration: json["package_duration"],
    purchasedAt: json["purchased_at"] == null ? null : DateTime.parse(json["purchased_at"]),
    expiresAt: json["expires_at"] == null ? null : DateTime.parse(json["expires_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    packageName: json["package_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "package_id": packageId,
    "package_duration": packageDuration,
    "purchased_at": purchasedAt?.toIso8601String(),
    "expires_at": expiresAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "package_name": packageName,
  };
}
