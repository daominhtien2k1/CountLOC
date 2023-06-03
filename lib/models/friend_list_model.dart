import 'package:equatable/equatable.dart';

class FriendList {
  List<Friend> friends;
  int count;

  FriendList({
    required this.friends,
    required this.count
  });


  FriendList.initial() : friends = List<Friend>.empty(growable: true), count = 0;

  FriendList copyWith({List<Friend>? friends, int? count}) {
    return FriendList(
      friends: friends ?? this.friends,
      count: count ?? this.count
    );
  }


  factory FriendList.fromJson(Map<String, dynamic> json) {
    return FriendList(
      friends: List<Friend>.from(json["data"]["friends"].map((f) => Friend.fromJson(f))),
      count: json["data"]["count"] as int
    );
  }

    Map<String, dynamic> toJson() {
      return {
        "friends": List<dynamic>.from(friends.map((f) => f.toJson())),
        "counts": count
      };
    }

}

class Friend extends Equatable{
  Friend({
    required this.friend,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  final String friend;
  final String name;
  final String avatar;
  final String createdAt;

  Friend copyWith({String? friend, String? name, String? avatar, String? createdAt,}) {
    return Friend(
      friend: friend ?? this.friend,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      friend: json["friend"] as String,
      name: json["name"] as String,
      avatar: json["avatar"] as String,
      createdAt: json["createdAt"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "friend": friend,
      "name": name,
      "avatar": avatar,
      "createdAt": createdAt,
    };
  }

  @override
  List<Object?> get props => [friend, name, avatar, createdAt];
}
