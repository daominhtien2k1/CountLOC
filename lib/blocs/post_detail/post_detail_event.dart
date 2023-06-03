import 'package:equatable/equatable.dart';

abstract class PostDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostDetailFetched extends PostDetailEvent {
  final String postId;

  PostDetailFetched({required this.postId});
}

class PostDetailReload extends PostDetailEvent {
  final String postId;

  PostDetailReload({required this.postId});
}

class PostDetailLike extends PostDetailEvent {
  final String postId;
  PostDetailLike({required this.postId});
}