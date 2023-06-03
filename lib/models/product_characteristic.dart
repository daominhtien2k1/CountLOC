class ProductCharacteristic {
  final int totalReviews;
  final List<Criteria> listCriteria;

  ProductCharacteristic({
    required this.totalReviews,
    required this.listCriteria,
  });

  ProductCharacteristic copyWith({
    int? totalReviews,
    List<Criteria>? listCriteria,
  }) =>
      ProductCharacteristic(
        totalReviews: totalReviews ?? this.totalReviews,
        listCriteria: listCriteria ?? this.listCriteria,
      );

  factory ProductCharacteristic.fromJson(Map<String, dynamic> json) => ProductCharacteristic(
    totalReviews: json["totalReviews"] as int,
    listCriteria: List<Criteria>.from(json["listCriteria"].map((x) => Criteria.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalReviews": totalReviews,
    "listCriteria": List<dynamic>.from(listCriteria.map((x) => x.toJson())),
  };
}

class Criteria {
  final String characteristicId;
  final String criteria;
  final int totalPoint;
  final double averagePoint;

  Criteria({
    required this.characteristicId,
    required this.criteria,
    required this.totalPoint,
    required this.averagePoint,
  });

  Criteria copyWith({
    String? characteristicId,
    String? criteria,
    int? totalPoint,
    double? averagePoint,
  }) =>
      Criteria(
        characteristicId: characteristicId ?? this.characteristicId,
        criteria: criteria ?? this.criteria,
        totalPoint: totalPoint ?? this.totalPoint,
        averagePoint: averagePoint ?? this.averagePoint,
      );

  factory Criteria.fromJson(Map<String, dynamic> json) => Criteria(
    characteristicId: json["characteristic_id"] as String,
    criteria: json["criteria"] as String,
    totalPoint: json["totalPoint"] as int,
    averagePoint: json["averagePoint"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "characteristic_id": characteristicId,
    "criteria": criteria,
    "totalPoint": totalPoint,
    "averagePoint": averagePoint,
  };
}
