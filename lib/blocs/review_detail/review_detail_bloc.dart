import 'package:cosmetic_frontend/blocs/review_detail/review_detail_event.dart';
import 'package:cosmetic_frontend/blocs/review_detail/review_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

class ReviewDetailBloc extends Bloc<ReviewDetailEvent, ReviewDetailState> {
  late final ReviewRepository reviewRepository;

  ReviewDetailBloc({required this.reviewRepository}): super(ReviewDetailState.init()) {
    on<ReviewDetailFetched>(_onReviewDetailFetched);
  }

  Future<void> _onReviewDetailFetched(ReviewDetailFetched event, Emitter<ReviewDetailState> emitter) async {
    try {
      final reviewId = event.reviewId;
      emit(state.copyWith(reviewDetailStatus: ReviewDetailStatus.loading));
      final reviewDetail = await reviewRepository.fetchDetailReview(reviewId: reviewId);
      emit(state.copyWith(reviewDetailStatus: ReviewDetailStatus.success, reviewDetail2: reviewDetail));
    } catch (err) {
      emit(state.copyWith(reviewDetailStatus: ReviewDetailStatus.failure));
    }
  }

}