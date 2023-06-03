import 'package:cosmetic_frontend/models/models.dart';

enum ReviewStatus {initial, loading, success, failure }

class ReviewState {
  ReviewStatus reviewStatus;
  List<Review>? reviews;
  List<Review>? instructionReviews;
  StatisticStar? statisticStar;
  ReviewState({required this.reviewStatus, this.reviews, this.instructionReviews, this.statisticStar});

  ReviewState.init(): reviewStatus = ReviewStatus.initial, reviews = null, instructionReviews = null, statisticStar = null;

  ReviewState copyWith({ReviewStatus? reviewStatus, List<Review>? reviews, List<Review>? instructionReviews, StatisticStar? statisticStar}) {
    return ReviewState(
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviews: reviews ?? this.reviews,
      instructionReviews: instructionReviews ?? this.instructionReviews,
      statisticStar: statisticStar ?? this.statisticStar
    );
  }
}
