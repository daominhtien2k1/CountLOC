import 'package:equatable/equatable.dart';

class Carousel extends Equatable {
  final String? filename;
  final String url;
  final String? publicId;

  Carousel({this.filename, required this.url, this.publicId});

  Carousel copyWith(String? filename, String? url, String? publicId) {
    return Carousel(
        filename: filename ?? this.filename,
        url: url ?? this.url,
        publicId: publicId ?? this.publicId
    );
  }

  factory Carousel.fromJson(Map<String, dynamic> json) {
    return Carousel(filename: json['filename'] as String?, url: json['url'] as String, publicId: json['publicId'] as String?);
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