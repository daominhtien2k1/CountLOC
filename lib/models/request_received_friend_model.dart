import 'package:equatable/equatable.dart';

class FriendRequestReceivedList {
  List<FriendRequestReceived> listFriendRequestReceived;

  FriendRequestReceivedList({required this.listFriendRequestReceived,});

  FriendRequestReceivedList.initial() : listFriendRequestReceived = List<FriendRequestReceived>.empty(growable: true);

  FriendRequestReceivedList copyWith({List<FriendRequestReceived>? listFriendRequestReceived}) {
    return FriendRequestReceivedList(
      listFriendRequestReceived: listFriendRequestReceived ?? this.listFriendRequestReceived,
    );
  }

  factory FriendRequestReceivedList.fromJson(Map<String, dynamic> json) {
    return FriendRequestReceivedList(
      listFriendRequestReceived: List<FriendRequestReceived>.from(json["data"]["friendRequestReceived"].map((x) => FriendRequestReceived.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "friendRequestReceived": List<dynamic>.from(
            listFriendRequestReceived.map((x) => x.toJson())),
      };
}

class FriendRequestReceived extends Equatable{
  FriendRequestReceived({
    required this.fromUser,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  String fromUser;
  String name;
  String avatar;
  String createdAt;

  FriendRequestReceived copyWith({String? fromUser, String? name, String? avatar, String? createdAt}) {
    return FriendRequestReceived(
      fromUser: fromUser ?? this.fromUser,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
    );
  }


  factory FriendRequestReceived.fromJson(Map<String, dynamic> json) {
    return FriendRequestReceived(
      fromUser: json["fromUser"] as String,
      name: json["name"] as String,
      avatar: json["avatar"] as String,
      createdAt: json["createdAt"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "fromUser": fromUser,
      "name": name,
      "avatar": avatar,
      "createdAt": createdAt,
    };
  }

    @override
    List<Object?> get props => [fromUser, name, avatar, createdAt];

}
