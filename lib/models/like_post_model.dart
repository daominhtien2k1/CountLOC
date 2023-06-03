class LikePost {
  final String code;
  final String message;
  final int likes;

  LikePost({required this.code, required this.message, required this.likes});

  LikePost.nullData(): code = '', message = '', likes = 0;

  LikePost copyWith({String? code, String? message, int? likes}) {
    return LikePost(
      code: code ?? this.code,
      message: message ?? this.message,
      likes: likes ?? this.likes
    );
  }

  factory LikePost.fromJson(Map<String, dynamic> json) {
    return LikePost(
      code: json["code"],
      message: json["message"],
      likes: json["data"]["likes"], // mấy test case lỗi, sẽ dính null, nên hết sức cẩn thận
    );
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "likes": likes,
  };

  @override
  String toString() => toJson().toString();
}