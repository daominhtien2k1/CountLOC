import 'package:cosmetic_frontend/blocs/event/event_event.dart';
import 'package:cosmetic_frontend/blocs/event/event_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository eventRepository;
  EventBloc({required this.eventRepository}): super(EventState.initial()) {

    on<EventsFetched>(_onEventsFetched);
  }

  Future<void> _onEventsFetched(EventsFetched eventFetch, Emitter<EventState> emit) async {
    try {
      emit(state.copyWith(eventStatus: EventStatus.loading));
      final EventList? eventList = await eventRepository.fetchEventList(searchBy: eventFetch.searchBy);
      if (eventList != null) {
        emit(EventState(eventStatus: EventStatus.success, eventList: eventList));
      }
    } catch (err) {
      emit(state.copyWith(eventStatus: EventStatus.failure));
    }
  }

}