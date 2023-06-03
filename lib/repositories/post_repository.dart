import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class PostRepository {

  Future<PostList> fetchPosts({int startIndex = 0, String? last_id}) async {
    try {
      // print("Fetching posts");
      const _postLimit = 5;
      final url = last_id != null ? Uri.http(
          Configuration.baseUrlConnect, '/post/get_list_posts', {
        'index': '$startIndex',
        'count': '$_postLimit',
        'last_id': '$last_id'
      })
          : Uri.http(Configuration.baseUrlConnect, '/post/get_list_posts',
          {'index': '$startIndex', 'count': '$_postLimit'});

      // get token from local storage/cache
      var token = await Token.getToken();
      // print("#Post_repository: " +  token.toString());

      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: token,
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final postList = PostList.fromJson(body);
        return postList;
      } else if (response.statusCode == 400) {
        return PostList.initial();
      } else {
        return PostList.initial();
      }
    } catch(error) {
      throw Exception('Error fetching posts');
    }

  }

  Future<LikePost> likeHomePost({required String id}) async {
    try {
      var token = await Token.getToken();
      final url = Uri.http(Configuration.baseUrlConnect, 'post/like_post');
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
        return LikePost.fromJson(body);
      } else if (response.statusCode == 400) {
        if (body['code'] == '506') {
          // message: Has been liked
          return LikePost.nullData().copyWith(code: body['code'], message: body['message']);
        } else if (body['code'] == '9991') {
          // message: Post is banned
          return LikePost.nullData().copyWith(code: body['code'], message: body['message']);
        } else {
          return LikePost.nullData();
        }
      } else if (response.statusCode == 403) {
        // Không like được do mình block nó hoặc nó block mình
        if (body['details'] == 'Người viết đã chặn bạn / Bạn chặn người viết, do đó không thể like bài viết') {
          return LikePost.nullData().copyWith(code: body['code'], message: 'Người viết đã chặn bạn / Bạn chặn người viết, do đó không thể like bài viết');
        }
        // Tài khoản bị khóa
        return LikePost.nullData().copyWith(code: body['code'], message: body['message']);
      } else {
        return LikePost.nullData();
      }
    } catch(error) {
      throw Exception('${error} - Error to like post');
    }
  }

  Future<LikePost> unlikeHomePost({required String id}) async {
    try {
      var token = await Token.getToken();
      final url = Uri.http(Configuration.baseUrlConnect, 'post/unlike_post');
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
        return LikePost.fromJson(body);
      } else if (response.statusCode == 400) {
        if (body['code'] == '506') {
          // message: Has been unliked
          return LikePost.nullData().copyWith(code: body['code'], message: body['message']);
        } else if (body['code'] == '9991') {
          // message: Post is banned
          return LikePost.nullData().copyWith(code: body['code'], message: body['message']);
        } else {
          return LikePost.nullData();
        }
      } else if (response.statusCode == 403) {
        // message: Not access - Tài khoản bị khóa
        return LikePost.nullData().copyWith(code: body['code'], message: body['message']);
      } else {
        return LikePost.nullData();
      }
    } catch(error) {
      throw Exception('${error} - Error to unlike post');
    }
  }

  Future<PostDetail?> fetchDetailPost({required String postId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/post/get_post/$postId');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final postDetail = PostDetail.fromJson(body['data']);
      return postDetail;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<PostList> fetchPostsByAccountId({required String accountId, int startIndex = 0, String? last_id}) async {
    try {
      // print("Fetching posts");
      const postLimit = 5;
      final url = last_id != null ? Uri.http(
          Configuration.baseUrlConnect, '/post/get_list_posts/$accountId', {
        'index': '$startIndex',
        'count': '$postLimit',
        'last_id': last_id
      })
          : Uri.http(Configuration.baseUrlConnect, '/post/get_list_posts/$accountId',
          {'index': '$startIndex', 'count': '$postLimit'});

      // get token from local storage/cache
      var token = await Token.getToken();
      // print("#Post_repository: " +  token.toString());

      final response = await http.get(url, headers: {
        HttpHeaders.authorizationHeader: token,
      });
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final postList = PostList.fromJson(body);
        return postList;
      } else if (response.statusCode == 400) {
        return PostList.initial();
      } else {
        return PostList.initial();
      }
    } catch(error) {
      throw Exception('Error fetching personal posts');
    }

  }

  Future<PostDetail?> addPost({required String described, String? status, List<XFile>? imageFileList}) async {
    try {
      var token = await Token.getToken();
      final url = Uri.http(Configuration.baseUrlConnect, 'post/add_post');
      List<File>? imageList;
      if(imageFileList !=null) {
        imageList = imageFileList.map((image) {
          File file = File(image.path);
          return file;
        }).toList();
      }

      // cái này chỉ gửi được described và status, không gửi được ảnh
      // final response = await http.post(url,
      //     headers: <String, String>{
      //       HttpHeaders.authorizationHeader: token,
      //       'Content-Type': 'application/json; charset=UTF-8',
      //     },
      //     body: jsonEncode(<String, dynamic>{
      //       'described': described,
      //       if(status != null) 'status': status,
      //       if(imageList != null && imageList.length == 1) 'image': imageList[0],
      //       if(imageList != null && imageList.length == 2) 'image': imageList[1],
      //       if(imageList != null && imageList.length == 3) 'image': imageList[2],
      //       if(imageList != null && imageList.length == 4) 'image': imageList[3]
      //     })
      // );

      var request = http.MultipartRequest("POST", url);
      Map<String, String> headers = { HttpHeaders.authorizationHeader: token };
      request.headers.addAll(headers);
      request.fields["described"] = described;
      if(status != null) request.fields["status"] = status;

      if(imageList != null && imageList.length == 1) {
        // print(imageList[0].path);
        var ext = imageList[0].path.split('.').last;
        var pic = await http.MultipartFile.fromPath("image", imageList[0].path, contentType: MediaType('image', ext));
        request.files.add(pic);
      }

      var responseStreamedResponse = await request.send();
      var responseData = await responseStreamedResponse.stream.toBytes();
      // var responseString = String.fromCharCodes(responseData); // lỗi tiếng việt
      // print("#PostRepository: $responseString");
      var responseUTF8 = utf8.decode(responseData);
      // print("#PostRepository: $responseUTF8");

      if (responseStreamedResponse.statusCode == 201) {
        final body = json.decode(responseUTF8) as Map<String, dynamic>;
        final postDetail = PostDetail.fromJson(body['data']);
        return postDetail;
      } else if (responseStreamedResponse.statusCode == 400) {
        return null;
      } else {
        return null;
      }
    } catch(error) {
      throw Exception('${error} - Error to add post');
    }
  }

  Future<void> reportPost({required String postId, required String subject, required String details}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/post/report_post');

    var token = await Token.getToken();
    try {
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'id': postId,
            'subject': subject,
            'details': details
          })
      );
    } catch(error) {
      throw Exception('${error} - Error to report post');
    }
  }

  Future<bool> deletePost({required String postId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/post/delete_post/$postId');

    var token = await Token.getToken();
    try {
      final response = await http.delete(url, headers: {
        HttpHeaders.authorizationHeader: token,
      });
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch(error) {
      throw Exception('${error} - Error to delete post');
    }
  }
}