class Comment {
  final String id;
  final String comment;
  final String createdAt;
  final Poster poster;

  Comment({required this.id, required this.comment, required this.createdAt, required this.poster,});

  Comment copyWith({String? id, String? comment, String? created, Poster? poster}) {
    return Comment(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      createdAt: created ?? this.createdAt,
      poster: poster ?? this.poster,
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json["id"],
      comment: json["comment"],
      createdAt: json["createdAt"],
      poster: Poster.fromJson(json["poster"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "comment": comment,
      "createdAt": createdAt,
      "poster": poster.toJson(),
    };
  }
}

class Poster {
  final String id;
  final String name;
  final String avatar;

  Poster({required this.id, required this.name, required this.avatar});

  Poster copyWith({String? id, String? name, String? avatar}) {
    return Poster(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  factory Poster.fromJson(Map<String, dynamic> json) {
    return Poster(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "avatar": avatar,
    };
  }

}
