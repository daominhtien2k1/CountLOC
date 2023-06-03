import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class SearchRepository {
  Future<List<SaveSearch>?> fetchSaveSearchList() async {
    final url =
        Uri.http(Configuration.baseUrlConnect, '/search/get_saved_search');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final searchData = body["data"] as List<dynamic>?;
      List<SaveSearch>? savesearch =
          searchData?.map((cmt) => SaveSearch.fromJson(cmt)).toList();
      return savesearch;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<PostList?> searchSth({required String keyword}) async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, '/search/search_sth');

      var token = await Token.getToken();
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{'keyword': keyword}));

      if (response.statusCode == 200) {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final postList = PostList.fromJson(body);
        return postList;
      } else if (response.statusCode == 400) {
        return null;
      } else {
        return null;
      }
    } catch (error) {
      throw Exception('Error fetching posts');
    }
  }
}
