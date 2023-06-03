class StatisticStar {
  final int reviews;
  final double rating;
  final int the5StarRatings;
  final int the4StarRatings;
  final int the3StarRatings;
  final int the2StarRatings;
  final int the1StarRatings;

  StatisticStar({
    required this.reviews,
    required this.rating,
    required this.the5StarRatings,
    required this.the4StarRatings,
    required this.the3StarRatings,
    required this.the2StarRatings,
    required this.the1StarRatings,
  });

  StatisticStar copyWith({
    int? reviews,
    double? rating,
    int? the5StarRatings,
    int? the4StarRatings,
    int? the3StarRatings,
    int? the2StarRatings,
    int? the1StarRatings,
  }) =>
      StatisticStar(
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
        the5StarRatings: the5StarRatings ?? this.the5StarRatings,
        the4StarRatings: the4StarRatings ?? this.the4StarRatings,
        the3StarRatings: the3StarRatings ?? this.the3StarRatings,
        the2StarRatings: the2StarRatings ?? this.the2StarRatings,
        the1StarRatings: the1StarRatings ?? this.the1StarRatings,
      );

  factory StatisticStar.fromJson(Map<String, dynamic> json) => StatisticStar(
    reviews: json["reviews"] as int,
    rating: json["rating"].toDouble(),
    the5StarRatings: json["5_star_ratings"] as int,
    the4StarRatings: json["4_star_ratings"] as int,
    the3StarRatings: json["3_star_ratings"] as int,
    the2StarRatings: json["2_star_ratings"] as int,
    the1StarRatings: json["1_star_ratings"] as int,
  );

  Map<String, dynamic> toJson() => {
    "reviews": reviews,
    "rating": rating,
    "5_star_ratings": the5StarRatings,
    "4_star_ratings": the4StarRatings,
    "3_star_ratings": the3StarRatings,
    "2_star_ratings": the2StarRatings,
    "1_star_ratings": the1StarRatings,
  };
}