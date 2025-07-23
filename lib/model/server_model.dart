import 'dart:convert';

ServerModel serverModelFromJson(String str) => ServerModel.fromJson(json.decode(str));

String serverModelToJson(ServerModel data) => json.encode(data.toJson());

class ServerModel {
  final String? status;
  final String? message;
  final Pagination? pagination;
  final List<Server>? data;

  ServerModel({
    this.status,
    this.message,
    this.pagination,
    this.data,
  });

  factory ServerModel.fromJson(Map<String, dynamic> json) => ServerModel(
    status: json["status"],
    message: json["message"],
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null ? [] : List<Server>.from(json["data"]!.map((x) => Server.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "pagination": pagination?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Server {
  final dynamic id;
  final dynamic countryId;
  final String? vpnCountry;
  final String? name;
  final String? vpnCredentialsUsername;
  final String? vpnCredentialsPassword;
  final String? udpConfiguration;
  final String? tcpConfiguration;
  final String? accessType;
  final dynamic status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Country? country;

  Server({
    this.id,
    this.countryId,
    this.vpnCountry,
    this.name,
    this.vpnCredentialsUsername,
    this.vpnCredentialsPassword,
    this.udpConfiguration,
    this.tcpConfiguration,
    this.accessType,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.country,
  });

  factory Server.fromJson(Map<String, dynamic> json) => Server(
    id: json["id"],
    countryId: json["country_id"],
    vpnCountry: json["vpn_country"],
    name: json["name"],
    vpnCredentialsUsername: json["vpn_credentials_username"],
    vpnCredentialsPassword: json["vpn_credentials_password"],
    udpConfiguration: json["udp_configuration"],
    tcpConfiguration: json["tcp_configuration"],
    accessType: json["access_type"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "country_id": countryId,
    "vpn_country": vpnCountry,
    "name": name,
    "vpn_credentials_username": vpnCredentialsUsername,
    "vpn_credentials_password": vpnCredentialsPassword,
    "udp_configuration": udpConfiguration,
    "tcp_configuration": tcpConfiguration,
    "access_type": accessType,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "country": country?.toJson(),
  };
}

class Pagination {
  final dynamic totalItems;
  final dynamic itemsPerPage;
  final dynamic currentPage;
  final dynamic totalPages;

  Pagination({
    this.totalItems,
    this.itemsPerPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    totalItems: json["total_items"],
    itemsPerPage: json["items_per_page"],
    currentPage: json["current_page"],
    totalPages: json["total_pages"],
  );

  Map<String, dynamic> toJson() => {
    "total_items": totalItems,
    "items_per_page": itemsPerPage,
    "current_page": currentPage,
    "total_pages": totalPages,
  };
}

class Country {
  final int? id;
  final String? name;
  final String? icon;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Country({
    this.id,
    this.name,
    this.icon,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
    status: json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}