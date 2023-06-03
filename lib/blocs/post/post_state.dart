import 'package:equatable/equatable.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

enum PostStatus {initial, loading, success, failure }

class PostState extends Equatable {
  PostState.initial(): status = PostStatus.initial, postList = PostList.initial(), hasReachedMax = false;
  PostState({required this.status, required this.postList, required this.hasReachedMax});

  final PostStatus status;
  final PostList postList;
  final bool hasReachedMax;

  PostState copyWith({
    PostStatus? status,
    PostList? postList,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      postList: postList ?? this.postList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return 'PostState{status: $status, postList: $postList, hasReachedMax: $hasReachedMax}';
  }

  @override
  List<Object> get props => [status, postList, hasReachedMax];
}
