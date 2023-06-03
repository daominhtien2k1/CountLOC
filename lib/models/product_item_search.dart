class ProductSearchItem {
  final String id;
  final String slug;
  final String name;
  final ProductSearchItemImage image;
  final int reviews;
  final double rating;

  ProductSearchItem({
    required this.id,
    required this.slug,
    required this.name,
    required this.image,
    required this.reviews,
    required this.rating,
  });

  ProductSearchItem copyWith({String? id, String? slug, String? name, ProductSearchItemImage? image, int? reviews, double? rating}) {
    return ProductSearchItem(
        id: id ?? this.id,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        image: image ?? this.image,
        reviews: reviews ?? this.reviews,
        rating: rating ?? this.rating,
    );
  }

  factory ProductSearchItem.fromJson(Map<String, dynamic> json) {
    return ProductSearchItem(
        id: json["id"] as String,
        slug: json["slug"] as String,
        name: json["name"] as String,
        image: ProductSearchItemImage.fromJson(json["image"]),
        reviews: json["reviews"] as int,
        rating: json["rating"] as double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "slug": slug,
      "name": name,
      "image": image.toJson(),
      "reviews": reviews,
      "rating": rating
    };
  }

}

class ProductSearchItemImage {
  final String? filename;
  final String url;
  final String? publicId;

  ProductSearchItemImage({this.filename, required this.url, this.publicId});

  ProductSearchItemImage copyWith({String? filename, String? url, String? publicId}) {
    return ProductSearchItemImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory ProductSearchItemImage.fromJson(Map<String, dynamic> json) {
    return ProductSearchItemImage(
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
