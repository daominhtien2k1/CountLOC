
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import 'event_detail_event.dart';
import 'event_detail_state.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final EventRepository eventRepository;
  EventDetailBloc({required this.eventRepository}): super(EventDetailState.initial()) {

    on<EventDetailFetched>(_onEventDetailFetched);
  }

  Future<void> _onEventDetailFetched(EventDetailFetched event, Emitter<EventDetailState> emit) async {
    try {
      emit(state.copyWith(eventDetailStatus: EventDetailStatus.loading));
      final eventId = event.eventId;
      final eventDetail = await eventRepository.fetchDetailEvent(eventId: eventId);
      if (eventDetail != null) {
        emit(EventDetailState(eventDetailStatus: EventDetailStatus.success, eventDetail: eventDetail));
      }
    } catch (err) {
      emit(EventDetailState(eventDetailStatus: EventDetailStatus.failure, eventDetail: null));
    }
  }

}