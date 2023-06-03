import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class FriendRepository {
  Future<FriendList> fetchFriends() async {
    print("#!#5Bắt đầu thực hiện friendsFetch()");
    final url =
        Uri.http(Configuration.baseUrlConnect, '/account/get_list_friends');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    switch (response.statusCode) {
      case 200: {
          final body = json.decode(response.body) as Map<String, dynamic>;
          final friendList = FriendList.fromJson(body);
          print("#!#6Kết thúc thực hiện xong friendsFetch()");
          return friendList;
      }
      case 400:
        return FriendList.initial();
      default:
        throw Exception('Error fetch friends');
    }
  }

  Future<FriendList> fetchFriendsOfAnotherUser({required String user_id}) async {
    final url =
        Uri.http(Configuration.baseUrlConnect, '/account/get_list_friends', {
      'user_id': user_id,
    });

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    switch (response.statusCode) {
      case 200: {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final friendList = FriendList.fromJson(body);
        return friendList;
      }
      case 400:
        return FriendList.initial();
      default:
        throw Exception('Error fetch friends');
    }
  }

  Future<bool> deleteFriend({required String personId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/account/del_friend');

    var token = await Token.getToken();

    try {
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{'person_id': personId}));

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch(error) {
      throw Exception('${error} - Error to del friend');
    }
  }
}
