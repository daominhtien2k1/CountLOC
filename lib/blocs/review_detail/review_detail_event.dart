import 'package:equatable/equatable.dart';

abstract class ReviewDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ReviewDetailFetched extends ReviewDetailEvent {
  final String reviewId;

  ReviewDetailFetched({required this.reviewId});
}

class ReviewDetailReload extends ReviewDetailEvent {
  final String reviewId;

  ReviewDetailReload({required this.reviewId});
}

class ReviewDetailReloadSettedUseful extends ReviewDetailEvent {
  final String reviewId;

  ReviewDetailReloadSettedUseful({required this.reviewId});
}