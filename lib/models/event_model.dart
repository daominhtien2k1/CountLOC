import 'package:equatable/equatable.dart';

class EventList {
  final List<Event>? happeningEvents;
  final List<Event>? endedEvents;

  EventList({this.happeningEvents, this.endedEvents});

  EventList.initial(): happeningEvents = List<Event>.empty(growable: true), endedEvents = List<Event>.empty(growable: true);

  EventList copyWith({List<Event>? happeningEvents, List<Event>? endedEvents,}) {
    return EventList(
      happeningEvents: happeningEvents ?? this.happeningEvents,
      endedEvents: endedEvents ?? this.endedEvents,
    );
  }

  factory EventList.fromJson(Map<String, dynamic> json) {
    final happeningEventsData = json["data"]["happeningEvents"] as List<dynamic>?;
    final endedEventsData = json["data"]["endedEvents"] as List<dynamic>?;
    return EventList(
      happeningEvents: happeningEventsData?.map((hpe) => Event.fromJson(hpe)).toList(),
      endedEvents: endedEventsData?.map((ee) => Event.fromJson(ee)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (happeningEvents != null) "happeningEvents": happeningEvents!.map((hpe) => hpe.toJson()).toList(),
      if (endedEvents != null) "endedEvents": endedEvents!.map((ee) => ee.toJson()).toList(),
    };
  }

}

class Event {
  final String id;
  final EventImage image;
  final String title;
  final int clicks;
  final String remainingTime;

  Event({required this.id, required this.image, required this.title, required this.clicks, required this.remainingTime,});

  Event copyWith({String? id, EventImage? image, String? title, int? clicks, String? remainingTime,}) {
    return Event(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      clicks: clicks ?? this.clicks,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"] as String,
      image: EventImage.fromJson(json["image"]),
      title: json["title"] as String,
      clicks: json["clicks"] as int,
      remainingTime: json["remainingTime"] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image.toJson(),
      "title": title,
      "clicks": clicks,
      "remainingTime": remainingTime,
    };
  }

}


class EventImage {
  final String? filename;
  final String url;
  final String? publicId;

  EventImage({this.filename, required this.url, this.publicId});

  EventImage copyWith({String? filename, String? url, String? publicId}) {
    return EventImage(
      filename: filename ?? this.filename,
      url: url ?? this.url,
      publicId: publicId ?? this.publicId,
    );
  }

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
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
