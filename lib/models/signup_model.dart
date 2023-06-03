// To parse this JSON data, do
//
//     final userChat = userChatFromJson(jsonString);

class Signup {
  Signup({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;

  Signup copyWith({
    String? code,
    String? message,
  }) =>
      Signup(
        code: code ?? this.code,
        message: message ?? this.message,
      );
  Signup.nullData(): code = '', message = '';
  factory Signup.fromJson(Map<String, dynamic> json) => Signup(
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}
