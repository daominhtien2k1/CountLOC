// To parse this JSON data, do
//
//     final videoList = videoListFromJson(jsonString);

import 'dart:convert';
import 'package:equatable/equatable.dart';

VideoList videoListFromJson(String str) => VideoList.fromJson(json.decode(str));

String videoListToJson(VideoList data) => json.encode(data.toJson());

class VideoList {
  VideoList({
    required this.videos,
  });

  final List<VideoElement> videos;
  VideoList.initial(): videos = List<VideoElement>.empty(growable: true);

  VideoList copyWith({
    required List<VideoElement> videos,
  }) =>
      VideoList(
        videos: videos ?? this.videos,
      );

  factory VideoList.fromJson(Map<String, dynamic> json) => VideoList(
    videos: List<VideoElement>.from(json["videos"].map((x) => VideoElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
  };
}

class VideoElement extends Equatable{
  VideoElement({
    required this.id,
    required this.described,
    required this.video,
    required this.isAdsCampaign,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.isLiked,
  });

  final String id;
  final String described;
  final VideoVideo video;
  final bool isAdsCampaign;
  final String createdAt;
  final String updatedAt;
  final int likes;
  final bool isLiked;

  VideoElement copyWith({
     String? id,
     String? described,
     VideoVideo? video,
     bool? isAdsCampaign,
     String? createdAt,
     String? updatedAt,
     int? likes,
     bool? isLiked,
  }) =>
      VideoElement(
        id: id ?? this.id,
        described: described ?? this.described,
        video: video ?? this.video,
        isAdsCampaign: isAdsCampaign ?? this.isAdsCampaign,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        likes: likes ?? this.likes,
        isLiked: isLiked ?? this.isLiked,
      );

  factory VideoElement.fromJson(Map<String, dynamic> json) => VideoElement(
    id: json["id"],
    described: json["described"],
    video: VideoVideo.fromJson(json["video"]),
    isAdsCampaign: json["isAdsCampaign"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    likes: json["likes"],
    isLiked: json["is_liked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "described": described,
    "video": video.toJson(),
    "isAdsCampaign": isAdsCampaign,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "likes": likes,
    "is_liked": isLiked,
  };

  @override
  List<Object?> get props {
    return [id, described, video, isAdsCampaign, createdAt, updatedAt, likes, isLiked];
  }
}




class VideoVideo {
  VideoVideo({
    required this.url,
    required this.publicId,
  });

  final String url;
  final String publicId;

  VideoVideo copyWith({
    required String url,
    String? publicId,
  }) =>
      VideoVideo(
        url: url ?? this.url,
        publicId: publicId ?? this.publicId,
      );

  factory VideoVideo.fromJson(Map<String, dynamic> json) => VideoVideo(
    url: json["url"],
    publicId: json["publicId"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "publicId": publicId,
  };
}




