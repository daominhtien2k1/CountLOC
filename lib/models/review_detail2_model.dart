import 'package:cosmetic_frontend/models/models.dart';

class ReviewDetail2 {
  final String id;
  final ProductInDetailReview product;
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

  ReviewDetail2({
    required this.id,
    required this.product,
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

  ReviewDetail2 copyWith({
    String? id,
    ProductInDetailReview? product,
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
  }) =>
      ReviewDetail2(
        id: id ?? this.id,
        product: product ?? this.product,
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

  factory ReviewDetail2.fromJson(Map<String, dynamic> json) {
    final imagesData = json["images"] as List<dynamic>?;
    final images = imagesData != null ? imagesData.map((imageData) =>
        AttachedReviewImage.fromJson(imageData)).toList() : null;

    final videoData = json["video"] as Map<String, dynamic>?;
    final video = videoData != null ? AttachedReviewVideo.fromJson(videoData): null;
    return ReviewDetail2(
      id: json["id"],
      product: ProductInDetailReview.fromJson(json["product"]),
      classification: json["classification"] as String,
      characteristicReviews: json["characteristic_review_results"] != null
          ? List<CharacteristicReviewCriteria>.from(
          json["characteristic_review_results"].map((x) =>
              CharacteristicReviewCriteria.fromJson(x)))
          : null,
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

  Map<String, dynamic> toJson() => {
    "id": id,
    "product": product.toJson(),
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

class ProductInDetailReview {
  final String id;
  final String name;
  final List<AttachedReviewImage> images;

  ProductInDetailReview({
    required this.id,
    required this.name,
    required this.images,
  });

  ProductInDetailReview copyWith({
    String? id,
    String? name,
    List<AttachedReviewImage>? images,
  }) =>
      ProductInDetailReview(
        id: id ?? this.id,
        name: name ?? this.name,
        images: images ?? this.images,
      );

  factory ProductInDetailReview.fromJson(Map<String, dynamic> json) => ProductInDetailReview(
    id: json["_id"],
    name: json["name"],
    images: List<AttachedReviewImage>.from(json["images"].map((x) => AttachedReviewImage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
  };
}
