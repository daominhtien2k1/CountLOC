import 'package:cosmetic_frontend/models/event_model.dart';
import 'package:equatable/equatable.dart';

abstract class EventDetailEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EventDetailFetched extends EventDetailEvent {
  final String eventId;

  EventDetailFetched({required this.eventId});
}