import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configuration.dart';

class Token {
  static Future<dynamic> getToken() async {
    // get token from local storage/cache
    final prefs = await SharedPreferences.getInstance();
    String userPref = prefs.getString('user') ?? '{"token": "No userdata"}';
    Map<String,dynamic> userMap = jsonDecode(userPref) as Map<String, dynamic>;
    // print("#Post_repository: " + userMap.toString());
    final token = userMap['token'] != 'No userdata' ? userMap['token'] : Configuration.token;
    return token;
  }
}