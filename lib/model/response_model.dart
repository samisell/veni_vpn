import 'dart:convert';

class ResponseModel {
  final bool _isSuccess;
  final String? _message;
  final int? _code;
  ResponseModel(this._isSuccess, this._message, [this._code]);


  String? get message => _message;
  int? get code => _code;
  bool get isSuccess => _isSuccess;
}
Response1Model response1ModelFromJson(String str) => Response1Model.fromJson(json.decode(str));

String response1ModelToJson(Response1Model data) => json.encode(data.toJson());

class Response1Model {
  final String? status;
  final String? message;

  Response1Model({
    this.status,
    this.message,
  });

  factory Response1Model.fromJson(Map<String, dynamic> json) => Response1Model(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
