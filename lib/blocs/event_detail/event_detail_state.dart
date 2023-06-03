import 'package:equatable/equatable.dart';

import '../../models/models.dart';

enum EventDetailStatus {initial, loading, success, failure }

class EventDetailState {
  EventDetailStatus eventDetailStatus;
  EventDetail? eventDetail;

  EventDetailState({required this.eventDetailStatus, required this.eventDetail});

  EventDetailState.initial(): eventDetailStatus = EventDetailStatus.initial, eventDetail = null;

  EventDetailState copyWith({EventDetailStatus? eventDetailStatus, EventDetail? eventDetail}) {
    return EventDetailState(
        eventDetailStatus: eventDetailStatus ?? this.eventDetailStatus,
        eventDetail: eventDetail ?? this.eventDetail
    );
  }

}