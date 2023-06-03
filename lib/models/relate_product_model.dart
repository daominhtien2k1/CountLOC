import 'dart:convert';

// Product ở mục Nhiều người quan tâm,
class RelateProduct {
  final String id;
  final String brandName;
  final String name;
  final RelateProductImage image;
  final int reviews;
  final double rating;
  final int loves;

  RelateProduct({
    required this.id,
    required this.brandName,
    required this.name,
    required this.image,
    required this.reviews,
    required this.rating,
    required this.loves
  });

  RelateProduct copyWith({String? id, String? slug, String? name, RelateProductImage? image, int? reviews, double? rating, int? loves}) {
    return RelateProduct(
        id: id ?? this.id,
        brandName: slug ?? this.brandName,
        name: name ?? this.name,
        image: image ?? this.image,
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
        loves: loves ?? this.loves
    );
  }

  factory RelateProduct.fromJson(Map<String, dynamic> json) {
    return RelateProduct(
        id: json["id"] as String,
        brandName: json["brand_name"] as String,
        name: json["name"] as String,
        image: RelateProductImage.fromJson(json["image"]),
        reviews: json["reviews"] as int,
        rating: json["rating"] as double,
        loves: json["loves"] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "brand_name": brandName,
      "name": name,
      "image": image.toJson(),
      "reviews": reviews,
      "rating": rating,
      "loves": loves
    };
  }

}

class RelateProductImage {
  final String? filename;
  final String url;
  final String? publicId;

  RelateProductImage({this.filename, required this.url, this.publicId});

  RelateProductImage copyWith({String? filename, String? url, String? publicId}) {
    return RelateProductImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory RelateProductImage.fromJson(Map<String, dynamic> json) {
    return RelateProductImage(
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
