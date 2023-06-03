import 'package:equatable/equatable.dart';

class UnknownPeopleList {
  List<UnknownPerson> unknownPeople;

  UnknownPeopleList({
    required this.unknownPeople,
  });


  UnknownPeopleList.initial() : unknownPeople = List<UnknownPerson>.empty(growable: true);

  UnknownPeopleList copyWith({
    List<UnknownPerson>? listUnknownPeople,
  }) =>
      UnknownPeopleList(
        unknownPeople: listUnknownPeople ?? this.unknownPeople,
      );

  factory UnknownPeopleList.fromJson(Map<String, dynamic> json) => UnknownPeopleList(
    unknownPeople: List<UnknownPerson>.from(json["data"]["listUnknownPeople"].map((x) => UnknownPerson.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "ListUnknownPeople": List<dynamic>.from(unknownPeople.map((x) => x.toJson())),
  };
}

class UnknownPerson extends Equatable{
  UnknownPerson({
    required this.id,
    required this.name,
    required this.avatar,
  });

  final String id;
  final String name;
  final String avatar;

  UnknownPerson copyWith({
    String? id,
    String? name,
    String? avatar,
  }) =>
      UnknownPerson(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );

  factory UnknownPerson.fromJson(Map<String, dynamic> json) => UnknownPerson(
    id: json["id"],
    name: json["name"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "avatar": avatar,
  };

  @override
  List<Object?> get props => [id, name, avatar];
}
