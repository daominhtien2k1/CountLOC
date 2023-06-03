import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum PersonalPostStatus {initial, loading, success, failure }

class PersonalPostState extends Equatable {
  PersonalPostState.initial(): status = PersonalPostStatus.initial, postList = PostList.initial(), hasReachedMax = false;
  PersonalPostState({required this.status, required this.postList, required this.hasReachedMax});

  final PersonalPostStatus status;
  final PostList postList;
  final bool hasReachedMax;

  PersonalPostState copyWith({
    PersonalPostStatus? status,
    PostList? postList,
    bool? hasReachedMax,
  }) {
    return PersonalPostState(
      status: status ?? this.status,
      postList: postList ?? this.postList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return 'PersonalPostState{status: $status, postList: $postList, hasReachedMax: $hasReachedMax}';
  }

  @override
  List<Object> get props => [status, postList, hasReachedMax];
}
