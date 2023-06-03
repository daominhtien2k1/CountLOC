// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class Review {
  final String id;
  final String classification;
  final List<CharacteristicReviewCriteria>? characteristicReviews;
  final int? rating;
  final String? title;
  final String? content;
  final String createdAt;
  final String updatedAt;
  final int usefuls;
  final int replies;
  final AuthorReview author;
  final bool isSettedUseful;
  final bool isBlocked;
  final bool canEdit;
  final bool banned;
  final bool canReply;
  final List<AttachedReviewImage>? images;
  final AttachedReviewVideo? video;

  Review({
    required this.id,
    required this.classification,
    this.characteristicReviews,
    this.rating,
    this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.usefuls,
    required this.replies,
    required this.author,
    required this.isSettedUseful,
    required this.isBlocked,
    required this.canEdit,
    required this.banned,
    required this.canReply,
    this.images,
    this.video
  });

  Review copyWith({
    String? id,
    String? classification,
    List<CharacteristicReviewCriteria>? characteristicReviews,
    int? rating,
    String? title,
    String? content,
    String? createdAt,
    String? updatedAt,
    int? usefuls,
    int? replies,
    AuthorReview? author,
    bool? isSettedUseful,
    bool? isBlocked,
    bool? canEdit,
    bool? banned,
    bool? canReply,
    List<AttachedReviewImage>? images,
  }) {
    return Review(
      id: id ?? this.id,
      classification: classification ?? this.classification,
      characteristicReviews: characteristicReviews ?? this.characteristicReviews,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      usefuls: usefuls ?? this.usefuls,
      replies: replies ?? this.replies,
      author: author ?? this.author,
      isSettedUseful: isSettedUseful ?? this.isSettedUseful,
      isBlocked: isBlocked ?? this.isBlocked,
      canEdit: canEdit ?? this.canEdit,
      banned: banned ?? this.banned,
      canReply: canReply ?? this.canReply,
      images: images ?? this.images,
    );
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    final imagesData = json["images"] as List<dynamic>?;
    final images = imagesData != null ? imagesData.map((imageData) =>
        AttachedReviewImage.fromJson(imageData)).toList() : null;

    final videoData = json["video"] as Map<String, dynamic>?;
    final video = videoData != null ? AttachedReviewVideo.fromJson(videoData): null;

    return Review(
      id: json["id"] as String,
      classification: json["classification"] as String,
      characteristicReviews: json["characteristic_review_results"] != null ? List<CharacteristicReviewCriteria>.from(json["characteristic_review_results"].map((x) => CharacteristicReviewCriteria.fromJson(x))) : null,
      rating: json["rating"] as int?,
      title: json["title"] as String?,
      content: json["content"] as String?,
      createdAt: json["createdAt"] as String,
      updatedAt: json["updatedAt"] as String,
      usefuls: json["usefuls"] as int,
      replies: json["replies"] as int,
      author: AuthorReview.fromJson(json["author"]),
      isSettedUseful: json["is_setted_useful"],
      isBlocked: json["is_blocked"] as bool,
      canEdit: json["can_edit"] as bool,
      banned: json["banned"] as bool,
      canReply: json["can_reply"] as bool,
      images: images,
      video: video,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "classification": classification,
      if(characteristicReviews!= null) "characteristic_review_results": List<dynamic>.from(characteristicReviews!.map((x) => x.toJson())),
      if(rating != null) "rating": rating,
      if(title != null) "title": title,
      if(content != null) "content": content,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "usefuls": usefuls,
      "replies": replies,
      "author": author.toJson(),
      "is_setted_useful": isSettedUseful,
      "is_blocked": isBlocked,
      "can_edit": canEdit,
      "banned": banned,
      "can_reply": canReply,
      if(images != null) "images": images!.map((image) => image.toJson()).toList(),
      if(video != null) "video": video!.toJson(),
    };
  }
}

class AuthorReview extends Equatable {
  final String id;
  final String name;
  final String avatar;

  AuthorReview({required this.id, required this.name, required this.avatar});

  AuthorReview copyWith({String? id, String? name, String? avatar}) {
    return AuthorReview(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
    );
  }

  factory AuthorReview.fromJson(Map<String, dynamic> json) {
    return AuthorReview(
      id: json["id"] as String,
      name: json["name"] as String,
      avatar: json["avatar"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "avatar": avatar,
    };
  }

  @override
  List<Object> get props {
    return [id, name, avatar];
  }

  @override
  String toString() => toJson().toString();

}

class CharacteristicReviewCriteria {
  final String characteristic;
  final int point;

  CharacteristicReviewCriteria({
    required this.characteristic,
    required this.point,
  });

  CharacteristicReviewCriteria copyWith({
    String? characteristic,
    int? point,
  }) =>
      CharacteristicReviewCriteria(
        characteristic: characteristic ?? this.characteristic,
        point: point ?? this.point,
      );

  factory CharacteristicReviewCriteria.fromJson(Map<String, dynamic> json) => CharacteristicReviewCriteria(
    characteristic: json["characteristic"],
    point: json["point"],
  );

  Map<String, dynamic> toJson() => {
    "characteristic": characteristic,
    "point": point,
  };
}

class AttachedReviewImage extends Equatable {
  final String? filename;
  final String url;
  final String? publicId;

  AttachedReviewImage({this.filename, required this.url, this.publicId});

  AttachedReviewImage copyWith(String? filename, String? url, String? publicId) {
    return AttachedReviewImage(
        filename: filename ?? this.filename,
        url: url ?? this.url,
        publicId: publicId ?? this.publicId
    );
  }

  factory AttachedReviewImage.fromJson(Map<String, dynamic> json) {
    return AttachedReviewImage(filename: json['filename'] as String?, url: json['url'] as String, publicId: json['publicId'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if(publicId != null) 'publicId': publicId
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [filename, url, publicId];

  @override
  String toString() => toJson().toString();
}

class AttachedReviewVideo extends Equatable {
  final String? filename;
  final String url;
  final String? publicId;

  AttachedReviewVideo({this.filename, required this.url, this.publicId});

  AttachedReviewVideo copyWith(String? filename, String? url, String? publicId) {
    return AttachedReviewVideo(
        filename: filename ?? this.filename,
        url: url ?? this.url,
        publicId: publicId ?? this.publicId
    );
  }

  factory AttachedReviewVideo.fromJson(Map<String, dynamic> json) {
    return AttachedReviewVideo(filename: json['filename'] as String?, url: json['url'] as String, publicId: json['publicId'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if(publicId != null) 'publicId': publicId
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [filename, url, publicId];

  @override
  String toString() => toJson().toString();
}