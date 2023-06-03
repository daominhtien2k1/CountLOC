import 'package:equatable/equatable.dart';

import '../../models/list_unknown_people_model.dart';

abstract class UnknownPeopleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ListUnknownPeopleFetched extends UnknownPeopleEvent {}

class FriendRequestSend extends UnknownPeopleEvent {
  final UnknownPerson unknownPerson;
  FriendRequestSend({required this.unknownPerson});
}
