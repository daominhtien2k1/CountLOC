import 'user_model.dart';

class Video {
  final User user;
  final String described;
  final String videoUrl;
  final int likes;
  final DateTime createdTime;


  const Video({
    required this.user,
    required this.described,
    required this.videoUrl,
    required this.likes,
    required this.createdTime
  });
}