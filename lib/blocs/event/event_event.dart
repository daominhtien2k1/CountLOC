import 'package:cosmetic_frontend/models/event_model.dart';
import 'package:equatable/equatable.dart';

abstract class EventEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EventsFetched extends EventEvent {
  final String searchBy;

  EventsFetched({required this.searchBy});
}