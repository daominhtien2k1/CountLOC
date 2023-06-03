import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum EventStatus {initial, loading, success, failure }

class EventState {
  EventStatus eventStatus;
  EventList eventList;

  EventState({required this.eventStatus, required this.eventList});

  EventState.initial(): eventStatus = EventStatus.initial, eventList = EventList.initial();

  EventState copyWith({EventStatus? eventStatus, EventList? eventList}) {
    return EventState(
        eventStatus: eventStatus ?? this.eventStatus,
        eventList: eventList ?? this.eventList
    );
  }

}