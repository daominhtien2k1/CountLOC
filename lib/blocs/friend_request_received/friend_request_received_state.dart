import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum FriendRequestReceivedStatus {initial, loading, success, failure }

class FriendRequestReceivedState extends Equatable {
  final FriendRequestReceivedList friendRequestReceivedList;
  final FriendRequestReceivedStatus status;

  FriendRequestReceivedState({required this.status, required this.friendRequestReceivedList});

  FriendRequestReceivedState.initial() : status = FriendRequestReceivedStatus.initial, friendRequestReceivedList = FriendRequestReceivedList.initial();

  FriendRequestReceivedState copyWith({FriendRequestReceivedStatus? status, FriendRequestReceivedList? friendRequestReceivedList}) {
    return FriendRequestReceivedState(
      status: status ?? this.status,
      friendRequestReceivedList: friendRequestReceivedList ?? this.friendRequestReceivedList,
    );
  }

  @override
  String toString() {
    return 'FriendRequestReceivedState{FriendRequestReceivedList: $friendRequestReceivedList}';
  }

  @override
  List<Object> get props => [friendRequestReceivedList];
}
