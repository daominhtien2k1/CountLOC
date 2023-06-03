import 'models.dart';

class PostDetail {
  final String id;
  final String described;
  final String createdAt;
  final String updatedAt;
  final List<LikedAccount> likedAccounts;
  final int likes;
  final int comments;
  final Author author;
  final bool isLiked;
  final String? status;
  final bool isBlocked;
  final bool canEdit;
  final bool banned;
  final bool canComment;
  final List<Image>? images;
  final Video? video;
  final String classification;

  PostDetail({
    required this.id,
    required this.described,
    required this.createdAt,
    required this.updatedAt,
    required this.likedAccounts,
    required this.likes,
    required this.comments,
    required this.author,
    required this.isLiked,
    this.status,
    required this.isBlocked,
    required this.canEdit,
    required this.banned,
    required this.canComment,
    this.images,
    this.video,
    required this.classification
  });

  PostDetail copyWith({
    String? id,
    String? described,
    String? createdAt,
    String? updatedAt,
    List<LikedAccount>? likedAccounts,
    int? likes,
    int? comments,
    Author? author,
    bool? isLiked,
    String? status,
    bool? isBlocked,
    bool? canEdit,
    bool? banned,
    bool? canComment,
    String? classification,
    List<Image>? images,
    Video? video
  }) =>
      PostDetail(
        id: id ?? this.id,
        described: described ?? this.described,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        likedAccounts: likedAccounts ?? this.likedAccounts,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        author: author ?? this.author,
        isLiked: isLiked ?? this.isLiked,
        status: status ?? this.status,
        isBlocked: isBlocked ?? this.isBlocked,
        canEdit: canEdit ?? this.canEdit,
        banned: banned ?? this.banned,
        canComment: canComment ?? this.canComment,
        classification: classification ?? this.classification,
        images: images ?? this.images,
        video: video ?? this.video
      );

  factory PostDetail.fromJson(Map<String, dynamic> json) {
    final imagesData = json["images"] as List<dynamic>?;
    final images = imagesData != null ? imagesData.map((imageData) =>
        Image.fromJson(imageData)).toList() : null;

    final videoData = json["video"] as Map<String, dynamic>?;
    final video = videoData != null ? Video.fromJson(videoData): null;
    return PostDetail(
        id: json["id"] as String,
        described: json["described"] as String,
        createdAt: json["createdAt"] as String,
        updatedAt: json["updatedAt"] as String,
        likedAccounts: List<LikedAccount>.from(json["likedAccounts"].map((x) => LikedAccount.fromJson(x))),
        likes: json["likes"] as int,
        comments: json["comments"] as int,
        author: Author.fromJson(json["author"]),
        isLiked: json["is_liked"] as bool,
        status: json["status"] as String?,
        isBlocked: json["is_blocked"] as bool,
        canEdit: json["can_edit"] as bool,
        banned: json["banned"] as bool,
        canComment: json["can_comment"] as bool,
        classification: json["classification"] as String,
        images: images,
        video: video
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "described": described,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "likedAccounts": List<dynamic>.from(likedAccounts.map((x) => x.toJson())),
    "likes": likes,
    "comments": comments,
    "author": author.toJson(),
    "is_liked": isLiked,
    "status": status,
    "is_blocked": isBlocked,
    "can_edit": canEdit,
    "banned": banned,
    "can_comment": canComment,
    if(images != null) "images": images!.map((image) => image.toJson()).toList(),
    if(video != null) "video": video!.toJson(),
    "classification": classification
  };

  @override
  String toString() => toJson().toString();
}


class Image {
  Image({
    required this.url,
    this.publicId,
  });

  final String url;
  final String? publicId;

  Image copyWith({
    String? url,
    String? publicId,
  }) =>
      Image(
        url: url ?? this.url,
        publicId: publicId ?? this.publicId,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    url: json["url"] as String,
    publicId: json["publicId"] as String?,
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    if(publicId != null) "publicId": publicId,
  };
}

class Video {
  final String url;
  final String? publicId;

  Video({required this.url, this.publicId});

  Video copyWith(String? url, String? publicId) {
    return Video(
        url: url ?? this.url,
        publicId: publicId ?? this.publicId
    );
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(url: json['url'] as String, publicId: json['publicId'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      if(publicId != null) 'publicId': publicId
    };
  }

  @override
  String toString() => toJson().toString();
}

class LikedAccount {
  final Image avatar;
  final String name;
  final String id; // _id: không được vì Named parameters can't start with an underscore

  LikedAccount({
    required this.avatar,
    required this.name,
    required this.id,
  });

  LikedAccount copyWith({
    Image? avatar,
    String? name,
    String? id,
  }) =>
      LikedAccount(
        avatar: avatar ?? this.avatar,
        name: name ?? this.name,
        id: id ?? this.id,
      );

  factory LikedAccount.fromJson(Map<String, dynamic> json) => LikedAccount(
    avatar: Image.fromJson(json["avatar"]),
    name: json["name"],
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "avatar": avatar.toJson(),
    "name": name,
    "_id": id,
  };
}
