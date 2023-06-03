import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'friend_request_received_event.dart';
import 'friend_request_received_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class FriendRequestReceivedBloc extends Bloc<FriendRequestReceivedEvent, FriendRequestReceivedState> {
  late final FriendRequestReceivedRepository friendRequestReceivedRepository;

  FriendRequestReceivedBloc() : super(FriendRequestReceivedState.initial()) {
    friendRequestReceivedRepository = FriendRequestReceivedRepository();
    on<ListFriendRequestReceivedFetched>(
      _onListFriendRequestReceivedFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<FriendRequestReceivedAccept>(
      _onFriendRequestReceivedAccept,
      transformer: throttleDroppable(throttleDuration),
    );

    on<FriendRequestReceivedDelete>(
      _onFriendRequestReceivedDelete,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onListFriendRequestReceivedFetched(
      ListFriendRequestReceivedFetched event,
      Emitter<FriendRequestReceivedState> emit) async {
    try {
      emit(state.copyWith(status: FriendRequestReceivedStatus.loading));
      final listFriendRequestReceivedData = await friendRequestReceivedRepository.fetchListFriendRequestReceived();
      emit(state.copyWith(status: FriendRequestReceivedStatus.success, friendRequestReceivedList: listFriendRequestReceivedData));
    } catch (_) {
      emit(state.copyWith(status: FriendRequestReceivedStatus.failure));
    }
  }

  Future<void> _onFriendRequestReceivedAccept(FriendRequestReceivedAccept event,
      Emitter<FriendRequestReceivedState> emit) async {
    try {
      final FriendRequestReceived friendRequestReceived = event.friendRequestReceived;
      final isAcceptSuccess = await friendRequestReceivedRepository.setAcceptFriend(senderId: friendRequestReceived.fromUser);
      if (isAcceptSuccess) {
        final friendRequestReceivedList = state.friendRequestReceivedList as FriendRequestReceivedList;
        final listFriendRequestReceived = friendRequestReceivedList.listFriendRequestReceived as List<FriendRequestReceived>;
        int index = listFriendRequestReceived.indexOf(friendRequestReceived);
        state.friendRequestReceivedList.listFriendRequestReceived.removeAt(index);
        emit(state.copyWith(friendRequestReceivedList: FriendRequestReceivedList(listFriendRequestReceived: listFriendRequestReceived)));
      }

    } catch (_) {

    }
  }

  Future<void> _onFriendRequestReceivedDelete(FriendRequestReceivedDelete event,
      Emitter<FriendRequestReceivedState> emit) async {
    try {
      final FriendRequestReceived friendRequestReceived = event.friendRequestReceived;
      final isAcceptSuccess = await friendRequestReceivedRepository.delRequestFriend(senderId: friendRequestReceived.fromUser);
      if (isAcceptSuccess) {
        final friendRequestReceivedList = state.friendRequestReceivedList as FriendRequestReceivedList;
        final listFriendRequestReceived = friendRequestReceivedList.listFriendRequestReceived as List<FriendRequestReceived>;
        int index = listFriendRequestReceived.indexOf(friendRequestReceived);
        state.friendRequestReceivedList.listFriendRequestReceived.removeAt(index);
        emit(state.copyWith(friendRequestReceivedList: FriendRequestReceivedList(listFriendRequestReceived: listFriendRequestReceived)));
      }
    } catch (_) {

    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  @override
  void onEvent(FriendRequestReceivedEvent event) {
    super.onEvent(event);
  }
}
