import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cosmetic_frontend/blocs/review/review_event.dart';
import 'package:cosmetic_frontend/blocs/review/review_state.dart';
import '../../repositories/repositories.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  late final ReviewRepository reviewRepository;

  ReviewBloc({required this.reviewRepository}): super(ReviewState.init()) {
    on<StatisticStarReviewFetched>(_onStatisticStarReviewFetched);
    on<ReviewsFetched>(_onReviewFetched);
    on<InstructionReviewsFetched>(_onInstructionReviewsFetched);
    on<QuickReviewAdd>(_onQuickReviewAdd);
    on<StandardReviewAdd>(_onStandardReviewAdd);
    on<InstructionReviewAdd>(_onInstructionReviewAdd);
  }

  Future<void> _onStatisticStarReviewFetched(StatisticStarReviewFetched event, Emitter<ReviewState> emitter) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(reviewStatus: ReviewStatus.loading));
      final statisticStar = await reviewRepository.fetchListReviewsStar(productId: productId);
      emit(state.copyWith(reviewStatus: ReviewStatus.success, statisticStar: statisticStar));
    } catch(error) {
      emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }

  Future<void> _onReviewFetched(ReviewsFetched event, Emitter<ReviewState> emitter) async {
    try {
      final productId = event.productId;
      emit(state.copyWith(reviewStatus: ReviewStatus.loading));
      final reviews = await reviewRepository.fetchReviews(productId: productId);
      emit(state.copyWith(reviewStatus: ReviewStatus.success, reviews: reviews));
    } catch(error) {
      emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }

  Future<void> _onInstructionReviewsFetched(InstructionReviewsFetched event, Emitter<ReviewState> emitter) async {
    try {
      final productId = event.productId;
      final instructionReviews = await reviewRepository.fetchInstructionReviews(productId: productId);
      emit(state.copyWith(reviewStatus: ReviewStatus.success, instructionReviews: instructionReviews));
    } catch(error) {
      // emit(state.copyWith(reviewStatus: ReviewStatus.failure));
    }
  }

  Future<void> _onQuickReviewAdd(QuickReviewAdd event, Emitter<ReviewState> emitter) async {
    try {
      final String productId = event.productId;
      final String classification = event.classification;
      final int rating = event.rating;
      final newQuickReview = await reviewRepository.addReview(
          productId: productId, classification: classification, rating: rating);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onStandardReviewAdd(StandardReviewAdd event, Emitter<ReviewState> emitter) async {
    try {
      final String productId = event.productId;
      final String classification = event.classification;
      final int rating = event.rating;
      final String title = event.title;
      final String content = event.content;
      final newStandardReview = await reviewRepository.addReview(
          productId: productId, classification: classification, rating: rating, title: title, content: content);

    } catch (e) {
      print(e);
    }
  }

  Future<void> _onInstructionReviewAdd(InstructionReviewAdd event, Emitter<ReviewState> emitter) async {
    try {
      final String productId = event.productId;
      final String classification = event.classification;
      final String title = event.title;
      final String content = event.content;
      final newInstructionReview = await reviewRepository.addReview(
          productId: productId, classification: classification, title: title, content: content);

    } catch (e) {
      print(e);
    }
  }
}