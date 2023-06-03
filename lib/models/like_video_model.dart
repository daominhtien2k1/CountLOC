class LikeVideo {
  final String code;
  final String message;
  final int likes;

  LikeVideo({required this.code, required this.message, required this.likes});

  LikeVideo.nullData(): code = '', message = '', likes = 0;

  LikeVideo copyWith({String? code, String? message, int? likes}) {
    return LikeVideo(
        code: code ?? this.code,
        message: message ?? this.message,
        likes: likes ?? this.likes
    );
  }

  factory LikeVideo.fromJson(Map<String, dynamic> json) {
    return LikeVideo(
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