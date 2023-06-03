import 'package:equatable/equatable.dart';

import '../../models/list_unknown_people_model.dart';

enum UnknownPeopleStatus {initial, loading, success, failure }

class UnknownPeopleState extends Equatable {
  final UnknownPeopleStatus status;
  final UnknownPeopleList unknownPeopleList;

  UnknownPeopleState({required this.status, required this.unknownPeopleList});

  UnknownPeopleState.initial() : status = UnknownPeopleStatus.initial, unknownPeopleList = UnknownPeopleList.initial();

  UnknownPeopleState copyWith({
    UnknownPeopleStatus? status,
    UnknownPeopleList? unknownPeopleList,
  }) {
    return UnknownPeopleState(
      status: status ?? this.status,
      unknownPeopleList: unknownPeopleList ?? this.unknownPeopleList
    );
  }

  @override
  List<Object> get props => [status, unknownPeopleList];
}
