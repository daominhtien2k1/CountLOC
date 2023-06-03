import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class FriendEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FriendsFetched extends FriendEvent {}

class FriendsOfAnotherUserFetched extends FriendEvent {
  final String id;
  FriendsOfAnotherUserFetched({required this.id});
}

class FriendDelete extends FriendEvent {
  final Friend friend;
  FriendDelete({required this.friend});
}
