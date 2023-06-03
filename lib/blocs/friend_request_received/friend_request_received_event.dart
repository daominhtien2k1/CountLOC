import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class FriendRequestReceivedEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ListFriendRequestReceivedFetched extends FriendRequestReceivedEvent {}

class FriendRequestReceivedAccept extends FriendRequestReceivedEvent {
  final FriendRequestReceived friendRequestReceived;
  FriendRequestReceivedAccept({required this.friendRequestReceived});
}

class FriendRequestReceivedDelete extends FriendRequestReceivedEvent {
  final FriendRequestReceived friendRequestReceived;
  FriendRequestReceivedDelete({required this.friendRequestReceived});
}