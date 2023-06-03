import 'package:equatable/equatable.dart';

// sử dụng Equatable thì các trường bắt buộc là final
class AuthUser extends Equatable{
  final String code;
  final String message;
  // logic muốn để các trường null tùy theo trong 1 loại request api, nên các trường thuộc tính AuthUser model không null
  // nếu để hết thành String? có lẽ là cách tiếp cận tồi tệ hơn
  final String id;
  final String name;
  final String token;
  final String avatar;
  final bool active;

  AuthUser({
    required this.code,
    required this.message,
    required this.id,
    required this.name,
    required this.token,
    required this.avatar,
    required this.active,
  });

  AuthUser.initial() : code = '', message = '', id = '', name = '', token = '', avatar = '', active = false;
  AuthUser.nullData(): code = '', message = '', id = '', name = '', token = '', avatar = '', active = false;

  AuthUser copyWith({String? code, String? message, String? id, String? name, String? token, String? avatar, bool? active}) {
    return AuthUser(
      code: code ?? this.code,
      message: message ?? this.message,
      id: id ?? this.id,
      name: name ?? this.name,
      token: token ?? this.token,
      avatar: avatar ?? this.avatar,
      active: active ?? this.active,
    );
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final authUserData = json['data'];
    return AuthUser(
      code: json["code"] as String,
      message: json["message"] as String,
      id: authUserData["id"] as String,
      name: authUserData["name"] as String,
      token: authUserData["token"] as String,
      avatar: authUserData["avatar"] ?? "https://kansai-resilience-forum.jp/wp-content/uploads/2019/02/IAFOR-Blank-Avatar-Image-1.jpg" as String,
      active: authUserData["active"] as bool,
    );
  }
    Map<String, dynamic> toJson() => {
      "code": code,
      "message": message,
      "id": id,
      "name": name,
      "token": token,
      "avatar": avatar,
      "active": active,
    };

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, token, avatar, active];

  @override
  String toString() => toJson().toString();
}
