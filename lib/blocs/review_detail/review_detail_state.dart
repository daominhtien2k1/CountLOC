import '../../models/models.dart';

enum ReviewDetailStatus {initial, loading, success, failure }

class ReviewDetailState {
  ReviewDetailStatus reviewDetailStatus;
  ReviewDetail2? reviewDetail;

  ReviewDetailState({required this.reviewDetailStatus, this.reviewDetail});

  ReviewDetailState.init(): reviewDetailStatus = ReviewDetailStatus.initial, reviewDetail = null;

  ReviewDetailState copyWith({ReviewDetailStatus? reviewDetailStatus, ReviewDetail2? reviewDetail2 }) {
    return ReviewDetailState(
      reviewDetailStatus: reviewDetailStatus ?? this.reviewDetailStatus,
      reviewDetail: reviewDetail2 ?? this.reviewDetail
    );
  }
}