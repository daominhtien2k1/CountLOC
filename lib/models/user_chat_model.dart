// To parse this JSON data, do
//
//     final userChat = userChatFromJson(jsonString);

import 'dart:convert';

class UserChat {
  UserChat({
    required this.idUser,
    required this.name,
    required this.imageUrl,
    this.isOnline = false,
  });

  final String idUser;
  final String name;
  final String imageUrl;
  final bool isOnline;

  UserChat copyWith({
    String? idUser,
    String? name,
    String? imageUrl,
    bool? isOnline,
  }) =>
      UserChat(
        idUser: idUser ?? this.idUser,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        isOnline: isOnline ?? this.isOnline,
      );

  factory UserChat.fromJson(Map<String, dynamic> json) => UserChat(
    idUser: json["idUser"],
    name: json["name"],
    imageUrl: json["imageUrl"],
    isOnline: json["isOnline"],
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "name": name,
    "imageUrl": imageUrl,
    "isOnline": isOnline,
  };
}
