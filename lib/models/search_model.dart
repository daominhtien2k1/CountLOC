class SaveSearch {
  SaveSearch({
    required this.id,
    required this.accountId,
    required this.keyword,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String accountId;
  final String keyword;
  final String createdAt;
  final String updatedAt;

  SaveSearch copyWith({
    String? id,
    String? accountId,
    String? keyword,
    String? createdAt,
    String? updatedAt,
  }) =>
      SaveSearch(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        keyword: keyword ?? this.keyword,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SaveSearch.fromJson(Map<String, dynamic> json) => SaveSearch(
    id: json["_id"],
    accountId: json["account_id"],
    keyword: json["keyword"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "account_id": accountId,
    "keyword": keyword,
    "createdAt": createdAt,
    "updatedAt": updatedAt
  };
}
