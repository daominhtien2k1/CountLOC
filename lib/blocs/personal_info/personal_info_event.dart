import 'package:equatable/equatable.dart';

abstract class PersonalInfoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PersonalInfoFetched extends PersonalInfoEvent {}

class PersonalInfoOfAnotherUserFetched extends PersonalInfoEvent {
  final String id;
  PersonalInfoOfAnotherUserFetched({required this.id});
}

class SetNameUser extends PersonalInfoEvent {
  final String name;
  SetNameUser({required this.name});
}

class SetDescriptionUser extends PersonalInfoEvent {
  final String description;
  SetDescriptionUser({required this.description});
}
class SetCityUser extends PersonalInfoEvent {
  final String city;
  SetCityUser({required this.city});
}
class SetCountryUser extends PersonalInfoEvent {
  final String country;
  SetCountryUser({required this.country});
}

