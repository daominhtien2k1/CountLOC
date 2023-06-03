class ProductDetail {
  final String id;
  final String name;
  final String origin;
  final int guarantee;
  final int expiredYear;
  final String description;
  final bool available;
  final int lowPrice;
  final int highPrice;
  final int loves;
  final bool isLoved;
  final bool isViewed;
  final Brand brand;
  final List<ProductDetailImage> images;
  final int reviews;
  final double rating;

  ProductDetail({
    required this.id,
    required this.name,
    required this.origin,
    required this.guarantee,
    required this.expiredYear,
    required this.description,
    required this.available,
    required this.lowPrice,
    required this.highPrice,
    required this.loves,
    required this.isLoved,
    required this.isViewed,
    required this.brand,
    required this.images,
    required this.reviews,
    required this.rating,
  });

  ProductDetail copyWith({
    String? id,
    String? name,
    String? origin,
    int? guarantee,
    int? expiredYear,
    String? description,
    bool? available,
    int? lowPrice,
    int? highPrice,
    int? loves,
    bool? isLoved,
    bool? isViewed,
    Brand? brand,
    List<ProductDetailImage>? images,
    int? reviews,
    double? rating,
  }) =>
      ProductDetail(
        id: id ?? this.id,
        name: name ?? this.name,
        origin: origin ?? this.origin,
        guarantee: guarantee ?? this.guarantee,
        expiredYear: expiredYear ?? this.expiredYear,
        description: description ?? this.description,
        available: available ?? this.available,
        lowPrice: lowPrice ?? this.lowPrice,
        highPrice: highPrice ?? this.highPrice,
        loves: loves ?? this.loves,
        isLoved: isLoved ?? this.isLoved,
        isViewed: isViewed ?? this.isViewed,
        brand: brand ?? this.brand,
        images: images ?? this.images,
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
      );


  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    id: json["id"] as String,
    name: json["name"] as String,
    origin: json["origin"] as String,
    guarantee: json["guarantee"] as int,
    expiredYear: json["expiredYear"] as int,
    description: json["description"] as String,
    available: json["available"] as bool,
    lowPrice: json["lowPrice"] as int,
    highPrice: json["highPrice"] as int,
    loves: json["loves"] as int,
    isLoved: json["isLoved"] as bool,
    isViewed: json["isViewed"] as bool,
    brand: Brand.fromJson(json["brand"]),
    images: List<ProductDetailImage>.from(json["images"].map((x) => ProductDetailImage.fromJson(x))),
    reviews: json["reviews"] as int,
    rating: json["rating"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "origin": origin,
    "guarantee": guarantee,
    "expiredYear": expiredYear,
    "description": description,
    "available": available,
    "lowPrice": lowPrice,
    "highPrice": highPrice,
    "loves": loves,
    "isLoved": isLoved,
    "isViewed": isViewed,
    "brand": brand.toJson(),
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "reviews": reviews,
    "rating": rating,
  };
}

class Brand {
  final String id;
  final String name;
  final String origin;
  final String description;
  final BrandImage image;

  Brand({
    required this.id,
    required this.name,
    required this.origin,
    required this.description,
    required this.image,
  });

  Brand copyWith({
    String? id,
    String? name,
    String? origin,
    String? description,
    BrandImage? image,
  }) =>
      Brand(
        id: id ?? this.id,
        name: name ?? this.name,
        origin: origin ?? this.origin,
        description: description ?? this.description,
        image: image ?? this.image,
      );

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    origin: json["origin"],
    description: json["description"],
    image: BrandImage.fromJson(json["image"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "origin": origin,
    "description": description,
    "image": image.toJson(),
  };
}

class BrandImage {
  final String? filename;
  final String url;
  final String? publicId;

  BrandImage({this.filename, required this.url, this.publicId});

  BrandImage copyWith({String? filename, String? url, String? publicId}) {
    return BrandImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory BrandImage.fromJson(Map<String, dynamic> json) {
    return BrandImage(
        filename: json['filename'] as String?,
        url: json['url'] as String,
        publicId: json['publicId'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if(filename != null) 'filename': filename,
      'url': url,
      if(publicId != null) 'publicId': publicId
    };
  }
}

class ProductDetailImage {
  final String? filename;
  final String url;
  final String? publicId;

  ProductDetailImage({this.filename, required this.url, this.publicId});

  ProductDetailImage copyWith({String? filename, String? url, String? publicId}) {
    return ProductDetailImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory ProductDetailImage.fromJson(Map<String, dynamic> json) {
    return ProductDetailImage(
        filename: json['filename'] as String?,
        url: json['url'] as String,
        publicId: json['publicId'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if(filename != null) 'filename': filename,
      'url': url,
      if(publicId != null) 'publicId': publicId
    };
  }
}