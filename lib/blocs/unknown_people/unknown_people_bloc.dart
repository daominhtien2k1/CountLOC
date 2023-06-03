import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'unknown_people_event.dart';
import 'unknown_people_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class UnknownPeopleBloc extends Bloc<UnknownPeopleEvent, UnknownPeopleState> {
  late final UnknownPeopleRepository unknownPeopleRepository;

  UnknownPeopleBloc() : super(UnknownPeopleState.initial()) {
    unknownPeopleRepository = UnknownPeopleRepository();
    on<ListUnknownPeopleFetched>(
      _onListUnknownPeopleFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<FriendRequestSend>(
      _onFriendRequestSend,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onListUnknownPeopleFetched(
      ListUnknownPeopleFetched event, Emitter<UnknownPeopleState> emit) async {
    try {
      emit(state.copyWith(status: UnknownPeopleStatus.loading));
      final unknownPeopleListData = await unknownPeopleRepository.fetchListUnknownPeople();
      emit(state.copyWith(status: UnknownPeopleStatus.success, unknownPeopleList: unknownPeopleListData));
    } catch (_) {
      emit(state.copyWith(status: UnknownPeopleStatus.failure));

    }
  }

  Future<void> _onFriendRequestSend(FriendRequestSend event,
      Emitter<UnknownPeopleState> emit) async {
    try {
      final UnknownPerson unknownPerson = event.unknownPerson;
      final isSent = await unknownPeopleRepository.setRequestFriend(receiverId: unknownPerson.id);
      if (isSent) {
        final unknownPeopleList = state.unknownPeopleList;
        final List<UnknownPerson> unknownPeople = unknownPeopleList.unknownPeople;
        int index = unknownPeople.indexOf(unknownPerson);
        state.unknownPeopleList.unknownPeople.removeAt(index);
        emit(state.copyWith(unknownPeopleList: UnknownPeopleList(unknownPeople: unknownPeople)));
      }
    } catch (_) {

    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
  }

  @override
  void onEvent(UnknownPeopleEvent event) {
    super.onEvent(event);
  }
}
