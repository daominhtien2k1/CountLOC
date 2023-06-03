import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'friend_event.dart';
import 'friend_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  late final FriendRepository friendRepository;

  FriendBloc() : super(FriendState.initial()) {
    friendRepository = FriendRepository();
    on<FriendsFetched>(
      _onFriendsFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<FriendsOfAnotherUserFetched>(
      _onFriendsOfAnotherUserFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<FriendDelete>(
      _onFriendDelete,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFriendsFetched(
      FriendsFetched event, Emitter<FriendState> emit) async {
    try {
      emit(state.copyWith(status: FriendStatus.loading));
      final friendListData = await friendRepository.fetchFriends();
      emit(state.copyWith(status: FriendStatus.success, friendList: friendListData));

    } catch (_) {
      emit(state.copyWith(status: FriendStatus.failure));

    }
  }

  Future<void> _onFriendsOfAnotherUserFetched(
      FriendsOfAnotherUserFetched event, Emitter<FriendState> emit) async {
    try {
      final String id = event.id;
      final friendListData = await friendRepository.fetchFriendsOfAnotherUser(user_id: id);
      emit(state.copyWith(status: FriendStatus.success, friendList: friendListData));
    } catch (_) {
      emit(state.copyWith());
    }
  }

  Future<void> _onFriendDelete(FriendDelete event, Emitter<FriendState> emit) async {
    try {
      final Friend friend = event.friend;
      final isDeleted = await friendRepository.deleteFriend(personId: friend.friend);
      if(isDeleted) {
        final friendList = state.friendList;
        final friends = friendList.friends;
        int index = friends.indexOf(friend);
        state.friendList.friends.removeAt(index);
        int count = friends.length;
        emit(state.copyWith(friendList: FriendList(friends: friends, count: count)));
      }
    } catch (_) {
      emit(state.copyWith());
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    // print('#FRIEND BLOC OBSERVER: $error');
  }

  @override
  void onEvent(FriendEvent event) {
    super.onEvent(event);
    // print('#FRIEND BLOC OBSERVER: $event');
  }
}
