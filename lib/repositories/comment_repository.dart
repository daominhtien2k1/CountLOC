import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class CommentRepository {
  Future<List<Comment>?> fetchComments({required String postId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/comment/get_comment', {'id': postId});

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final commentsData = body["data"]["commentList"] as List<dynamic>?;
      List<Comment>? comments = commentsData?.map((cmt) => Comment.fromJson(cmt)).toList();
      return comments;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<List<Comment>?> setComment({required String postId, required String comment}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/comment/set_comment');

    var token = await Token.getToken();

    final response = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': postId,
          'comment': comment
        })
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final commentsData = body["data"]["commentList"] as List<dynamic>?;
      List<Comment>? comments = commentsData?.map((cmt) => Comment.fromJson(cmt)).toList();
      return comments;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

}