import 'package:cosmetic_frontend/models/review_model.dart';

class ReviewDetail {
  final String id;
  final String classification;
  final List<CharacteristicReviewCriteria>? characteristicReviews;
  final int? rating;
  final String? title;
  final String? content;
  final String createdAt;
  final String updatedAt;
  final List<SettedUsefulAccount> settedUsefulAccounts;
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

  ReviewDetail({
    required this.id,
    required this.classification,
    this.characteristicReviews,
    this.rating,
    this.title,
    this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.settedUsefulAccounts,
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

  ReviewDetail copyWith({
    String? id,
    String? classification,
    List<CharacteristicReviewCriteria>? characteristicReviews,
    int? rating,
    String? title,
    String? content,
    String? createdAt,
    String? updatedAt,
    List<SettedUsefulAccount>? settedUsefulAccounts,
    int? usefuls,
    int? replies,
    AuthorReview? author,
    bool? isSettedUseful,
    bool? isBlocked,
    bool? canEdit,
    bool? banned,
    bool? canReply,
    List<AttachedReviewImage>? images,
    AttachedReviewVideo? video
  }) {
    return ReviewDetail(
      id: id ?? this.id,
      classification: classification ?? this.classification,
      characteristicReviews: characteristicReviews ?? this.characteristicReviews,
      rating: rating ?? this.rating,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      settedUsefulAccounts: settedUsefulAccounts ?? this.settedUsefulAccounts,
      usefuls: usefuls ?? this.usefuls,
      replies: replies ?? this.replies,
      author: author ?? this.author,
      isSettedUseful: isSettedUseful ?? this.isSettedUseful,
      isBlocked: isBlocked ?? this.isBlocked,
      canEdit: canEdit ?? this.canEdit,
      banned: banned ?? this.banned,
      canReply: canReply ?? this.canReply,
      images: images ?? this.images,
      video: video ?? this.video
    );
  }

  factory ReviewDetail.fromJson(Map<String, dynamic> json) {
    final imagesData = json["images"] as List<dynamic>?;
    final images = imagesData != null ? imagesData.map((imageData) =>
        AttachedReviewImage.fromJson(imageData)).toList() : null;

    final videoData = json["video"] as Map<String, dynamic>?;
    final video = videoData != null ? AttachedReviewVideo.fromJson(videoData): null;

    return ReviewDetail(
      id: json["id"] as String,
      classification: json["classification"] as String,
      characteristicReviews: json["characteristic_review_results"] != null ? List<CharacteristicReviewCriteria>.from(json["characteristic_review_results"].map((x) => CharacteristicReviewCriteria.fromJson(x))) : null,
      rating: json["rating"] as int?,
      title: json["title"] as String?,
      content: json["content"] as String?,
      createdAt: json["createdAt"] as String,
      updatedAt: json["updatedAt"] as String,
      settedUsefulAccounts: List<SettedUsefulAccount>.from(json["settedUsefulAccounts"].map((x) => SettedUsefulAccount.fromJson(x))),
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
      "settedUsefulAccounts": List<dynamic>.from(settedUsefulAccounts.map((x) => x.toJson())),
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

class SettedUsefulAccount {
  final SettedUsefulAccountImage avatar;
  final String name;
  final String id; // _id: không được vì Named parameters can't start with an underscore

  SettedUsefulAccount({
    required this.avatar,
    required this.name,
    required this.id,
  });

  SettedUsefulAccount copyWith({
    SettedUsefulAccountImage? avatar,
    String? name,
    String? id,
  }) =>
      SettedUsefulAccount(
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory SettedUsefulAccount.fromJson(Map<String, dynamic> json) => SettedUsefulAccount(
    avatar: SettedUsefulAccountImage.fromJson(json["avatar"]),
    name: json["name"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar.toJson(),
    "name": name,
    "_id": id,
  };
}

class SettedUsefulAccountImage {
  SettedUsefulAccountImage({
    required this.url,
    this.publicId,
  });

  final String url;
  final String? publicId;

  SettedUsefulAccountImage copyWith({
    String? url,
    String? publicId,
  }) =>
      SettedUsefulAccountImage(
        url: url ?? this.url,
        publicId: publicId ?? this.publicId,
      );

  factory SettedUsefulAccountImage.fromJson(Map<String, dynamic> json) => SettedUsefulAccountImage(
    url: json["url"] as String,
    publicId: json["publicId"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    if(publicId != null) "publicId": publicId,
  };
}