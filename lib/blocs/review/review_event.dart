import 'package:cosmetic_frontend/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StatisticStarReviewFetched extends ReviewEvent {
  final String productId;

  StatisticStarReviewFetched({required this.productId});
}

class ReviewsFetched extends ReviewEvent {
  final String productId;

  ReviewsFetched({required this.productId});
}

class InstructionReviewsFetched extends ReviewEvent {
  final String productId;

  InstructionReviewsFetched({required this.productId});
}

abstract class ReviewAdd extends ReviewEvent {
  final String productId;
  final String classification;

  final List<XFile>? imageFileList;
  ReviewAdd({required this.productId, required this.classification, this.imageFileList});
}

class QuickReviewAdd extends ReviewAdd {
  final int rating;

  QuickReviewAdd({
    required String productId,
    required String classification,
    List<XFile>? imageFileList,
    required this.rating,
  }): super(
    productId: productId,
    classification: classification,
    imageFileList: imageFileList,
  );
}

class StandardReviewAdd extends ReviewAdd {
  final int rating;
  final String title;
  final String content;

  StandardReviewAdd({
    required String productId,
    required String classification,
    List<XFile>? imageFileList,
    required this.rating,
    required this.title,
    required this.content
  }): super(
    productId: productId,
    classification: classification,
    imageFileList: imageFileList,
  );
}

class DetailReviewAdd extends ReviewAdd {
  final int rating;
  final String title;
  final String content;
  final List<CharacteristicReviewCriteria> characteristicReviews;

  DetailReviewAdd({
    required String productId,
    required String classification,
    List<XFile>? imageFileList,
    required this.rating,
    required this.title,
    required this.content,
    required this.characteristicReviews
  }): super(
    productId: productId,
    classification: classification,
    imageFileList: imageFileList,
  );
}

class InstructionReviewAdd extends ReviewAdd {
  final String title;
  final String content;

  InstructionReviewAdd({
    required String productId,
    required String classification,
    List<XFile>? imageFileList,
    required this.title,
    required this.content
  }): super(
    productId: productId,
    classification: classification,
    imageFileList: imageFileList,
  );
}