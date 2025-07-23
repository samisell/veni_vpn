class Token {
  final dynamic id;
  final dynamic userId;
  final String? tokenStatus;
  final dynamic initCredits;
  final dynamic creditsCount;
  final dynamic tokensBuy;
  final dynamic tokenCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Token({
    this.id,
    this.userId,
    this.tokenStatus,
    this.initCredits,
    this.creditsCount,
    this.tokensBuy,
    this.tokenCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    id: json["id"],
    userId: json["user_id"],
    tokenStatus: json["token_status"],
    initCredits: json["init_credits"],
    creditsCount: json["credits_count"],
    tokensBuy: json["tokens_buy"],
    tokenCount: json["token_count"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "token_status": tokenStatus,
    "init_credits": initCredits,
    "credits_count": creditsCount,
    "tokens_buy": tokensBuy,
    "token_count": tokenCount,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}