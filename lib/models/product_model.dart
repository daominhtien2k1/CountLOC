import 'dart:convert';

// Product ở mục Nhiều người quan tâm,
class Product {
  final String id;
  final String slug;
  final String name;
  final ProductImage image;
  final int reviews;
  final double rating;
  final int loves;

  Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    required this.reviews,
    required this.rating,
    required this.loves
  });

  Product copyWith({String? id, String? slug, String? name, ProductImage? image, int? reviews, double? rating, int? loves}) {
    return Product(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      image: image ?? this.image,
      reviews: reviews ?? this.reviews,
      rating: rating ?? this.rating,
      loves: loves ?? this.loves
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] as String,
      slug: json["slug"] as String,
      name: json["name"] as String,
      image: ProductImage.fromJson(json["image"]),
      reviews: json["reviews"] as int,
      rating: json["rating"] as double,
      loves: json["loves"] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "slug": slug,
      "name": name,
      "image": image.toJson(),
      "reviews": reviews,
      "rating": rating,
      "loves": loves
    };
  }

}

class ProductImage {
  final String? filename;
  final String url;
  final String? publicId;

  ProductImage({this.filename, required this.url, this.publicId});

  ProductImage copyWith({String? filename, String? url, String? publicId}) {
    return ProductImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
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
