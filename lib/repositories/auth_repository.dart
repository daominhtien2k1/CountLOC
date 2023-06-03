import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class AuthRepository {
  Future<AuthUser> login({required String phone, required String password}) async {
    // final response0 = await http.get(Uri.http(Configuration.baseUrlPhysicalDevice2, 'settings'));
    // print(response0.body);
    // final response1 = await http.get(Uri.parse('http://${Configuration.baseUrlPhysicalDevice2}/settings'));
    // print(response1.body);
    // final response2 = await http.post(Uri.parse('http://${Configuration.baseUrlPhysicalDevice2}/settings'),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //     },
    //     body: jsonEncode(<String, dynamic>{
    //       'value': 6,
    //     })
    // );
    // print(response2.body);
    final url = Uri.http(Configuration.baseUrlConnect, 'account/login');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'phoneNumber': phone,
          'password': password
        })
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final authUser = AuthUser.fromJson(body);
      return authUser;
    }else if (response.statusCode == 401) {
      // logic muốn để các trường null tùy theo trong 1 loại request api, nên các trường thuộc tính AuthUser model không nul
      // không sử dụng fromJson ở đây, mà chuyển logic đổ json -> model là vì các trường thuộc tính AuthUser model là non nullable
      return AuthUser.nullData().copyWith(code: '9995', message: 'User is not validated');
    }else {
      return AuthUser.nullData().copyWith(code: '1005', message: 'Unknown error');;
    }
    throw Exception('Error login');
  }

  logout() async {
    var token = await Token.getToken();
    final url = Uri.http(Configuration.baseUrlConnect, 'account/logout');
    http.post(url,
        headers: <String, String>{
          HttpHeaders.authorizationHeader: token,
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
  }

}