class EventDetail {
  final EventDetailImage image;
  final String title;
  final String time;
  final String participationCondition;
  final String description;

  EventDetail({required this.image, required this.title, required this.time, required this.participationCondition, required this.description,});

  EventDetail copyWith({String? id, EventDetailImage? image, String? title, String? time, String? participationCondition, String? description}) {
    return EventDetail(
      image: image ?? this.image,
      title: title ?? this.title,
      time: time ?? this.time,
      participationCondition: participationCondition ?? this.participationCondition,
      description: description ?? this.description,
    );
  }

  factory EventDetail.fromJson(Map<String, dynamic> json) {
    return EventDetail(
      image: EventDetailImage.fromJson(json["image"]),
      title: json["title"] as String,
      time: json["time"] as String,
      participationCondition: json["participationCondition"] as String,
      description: json["description"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image.toJson(),
      "title": title,
      "time": time,
      "participationCondition": participationCondition,
      "description": description,
    };
  }

}


class EventDetailImage {
  final String? filename;
  final String url;
  final String? publicId;

  EventDetailImage({this.filename, required this.url, this.publicId});

  EventDetailImage copyWith({String? filename, String? url, String? publicId}) {
    return EventDetailImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory EventDetailImage.fromJson(Map<String, dynamic> json) {
    return EventDetailImage(
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
