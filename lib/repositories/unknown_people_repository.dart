import 'dart:io';
import 'dart:convert';
import 'package:cosmetic_frontend/utils/token.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import '../configuration.dart';

class UnknownPeopleRepository {
  Future<UnknownPeopleList> fetchListUnknownPeople() async {
    final url =
        Uri.http(Configuration.baseUrlConnect, '/account/get_list_unknown_people');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    switch (response.statusCode) {
      case 200: {
        final body = json.decode(response.body) as Map<String, dynamic>;
        final unknownPeopleList = UnknownPeopleList.fromJson(body);
        return unknownPeopleList;
      }
      case 400:
        return UnknownPeopleList.initial();
      default:
        throw Exception('Error fetchRequestReceivedFriends');
    }
  }

  Future<bool> setRequestFriend({required String receiverId}) async {
    final url = Uri.http(
        Configuration.baseUrlConnect, '/account/set_request_friend');

    var token = await Token.getToken();

    try {
      final response = await http.post(url,
          headers: <String, String>{
            HttpHeaders.authorizationHeader: token,
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'receiver_id': receiverId
          })
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        return false;
      } else {
        return false;
      }
    } catch(error) {
      throw Exception('${error} - Error to send friend request');
    }
  }

}
