import '../../models/local/user_model.dart';
import '../../models/local/video_model.dart';
import 'user_data.dart';



final List<Video> videos = [
  Video(
    user: onlineUsers[5],
    described: 'Xin chào mọi người',
    videoUrl: 'https://www.youtube.com/watch?v=j5-yKhDd64s',
    likes: 1202,
    createdTime: DateTime.now()
  ),
  Video(
      user: onlineUsers[6],
      described: 'Liệu hôm nay có đáng',
      videoUrl: 'https://www.youtube.com/watch?v=E1ZVSFfCk9g',
      likes: 1513,
      createdTime: DateTime.now()
  ),
  Video(
      user: onlineUsers[7],
      described: 'Báo cáo tiến độ bài tập lớn',
      videoUrl: 'https://www.youtube.com/watch?v=umhl2hakkcY',
      likes: 3761,
      createdTime: DateTime.now()
  ),
];
