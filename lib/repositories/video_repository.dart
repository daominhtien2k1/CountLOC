import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class VideoRepository {
  getListVideo() async {
    try{
      var token = await Token.getToken();
      final url = Uri.http(Configuration.baseUrlConnect, 'video/get_list_videos');
      final response = await http.get(
          url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          }
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final postList = VideoList.fromJson(body['data']);
        return postList;
      } else if (response.statusCode == 400) {
        if (body['code'] == '9993') {
          // message: Video is not exsist
          return VideoList.initial();
        }
      } else {
        return VideoList.initial();
      }
    }catch(error){
      throw Exception('${error} - Error to get list video');
    }
  }

  Future<LikeVideo> likeVideo ({required String id}) async {
    try {
      var token = await Token.getToken();
      final url = Uri.http(Configuration.baseUrlConnect, 'video/like_video');
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'id': id
          })
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return LikeVideo.fromJson(body);
      } else if (response.statusCode == 400) {
        if (body['code'] == '506') {
          // message: Has been liked
          return LikeVideo.nullData().copyWith(code: body['code'], message: body['message']);
        } else if (body['code'] == '9991') {
          // message: Post is banned
          return LikeVideo.nullData().copyWith(code: body['code'], message: body['message']);
        } else {
          return LikeVideo.nullData();
        }
      } else if (response.statusCode == 403) {
        // Tài khoản bị khóa
        return LikeVideo.nullData().copyWith(code: body['code'], message: body['message']);
      } else {
        return LikeVideo.nullData();
      }
    } catch(error) {
      throw Exception('${error} - Error to like video post');
    }
  }

  Future<LikeVideo> unlikeVideo({required String id}) async {
    try {
      var token = await Token.getToken();
      final url = Uri.http(Configuration.baseUrlConnect, 'video/unlike_video');
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'id': id
          })
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return LikeVideo.fromJson(body);
      } else if (response.statusCode == 400) {
        if (body['code'] == '507') {
          // message: Has been unliked
          return LikeVideo.nullData().copyWith(code: body['code'], message: body['message']);
        } else if (body['code'] == '9991') {
          // message: Post is banned
          return LikeVideo.nullData().copyWith(code: body['code'], message: body['message']);
        } else {
          return LikeVideo.nullData();
        }
      } else if (response.statusCode == 403) {
        // message: Not access - Tài khoản bị khóa
        return LikeVideo.nullData().copyWith(code: body['code'], message: body['message']);
      } else {
        return LikeVideo.nullData();
      }
    } catch(error) {
      throw Exception('${error} - Error to unlike video post');
    }
  }
}