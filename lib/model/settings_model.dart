import 'dart:convert';

SettingsModel settingsModelFromJson(String str) => SettingsModel.fromJson(json.decode(str));

String settingsModelToJson(SettingsModel data) => json.encode(data.toJson());

class SettingsModel {
  final String? status;
  final String? message;
  final Data? data;

  SettingsModel({
    this.status,
    this.message,
    this.data,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final int? id;
  final String? loginSystemType;
  final dynamic faqUrl;
  final dynamic contactUsUrl;
  final dynamic privacyPolicyUrl;
  final dynamic termsAndConditionsUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.loginSystemType,
    this.faqUrl,
    this.contactUsUrl,
    this.privacyPolicyUrl,
    this.termsAndConditionsUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    loginSystemType: json["login_system_type"],
    faqUrl: json["faq_url"],
    contactUsUrl: json["contact_us_url"],
    privacyPolicyUrl: json["privacy_policy_url"],
    termsAndConditionsUrl: json["terms_and_conditions_url"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "login_system_type": loginSystemType,
    "faq_url": faqUrl,
    "contact_us_url": contactUsUrl,
    "privacy_policy_url": privacyPolicyUrl,
    "terms_and_conditions_url": termsAndConditionsUrl,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
