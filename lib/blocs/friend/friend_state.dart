import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum FriendStatus {initial, loading, success, failure }

class FriendState extends Equatable {
  final FriendList friendList;
  final FriendStatus status;

  FriendState({required this.friendList, required this.status});

  FriendState.initial() : friendList = FriendList.initial(), status = FriendStatus.initial;

  FriendState copyWith({FriendList? friendList, FriendStatus? status}) {
    return FriendState(
      friendList: friendList ?? this.friendList,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [friendList];
}
