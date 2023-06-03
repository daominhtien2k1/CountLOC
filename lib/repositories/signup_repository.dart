import 'dart:convert';
import 'dart:io';

import '../configuration.dart';
import '../models/signup_model.dart';
import 'package:http/http.dart' as http;

class SignupRepository {
  Future<Signup> signup ({required String phoneNumber, required String password}) async {
    try {
      final url = Uri.http(Configuration.baseUrlConnect, 'account/signup');
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'phoneNumber': phoneNumber,
            'password': password
          })
      );
      final body = json.decode(response.body) as Map<String, dynamic>;
      return Signup.nullData().copyWith(code: body['code'], message: body['message']);
      // if (response.statusCode == 200) {
      //   return Signup.nullData().copyWith(code: body['code'], message: body['message']);
      // } else if (response.statusCode == 400) {
      //   if (body['code'] == '506') {
      //     // message: Has been liked
      //     return Signup.nullData().copyWith(code: body['code'], message: body['message']);
      //   } else if (body['code'] == '9991') {
      //     // message: Post is banned
      //     return Signup.nullData().copyWith(code: body['code'], message: body['message']);
      //   } else {
      //     return Signup.nullData();
      //   }
      // } else if (response.statusCode == 403) {
      //   // Không like được do mình block nó hoặc nó block mình
      //   if (body['details'] ==
      //       'Người viết đã chặn bạn / Bạn chặn người viết, do đó không thể like bài viết') {
      //     return Signup.nullData().copyWith(code: body['code'],
      //         message: 'Người viết đã chặn bạn / Bạn chặn người viết, do đó không thể like bài viết');
      //   }
      // }
      // return Signup.nullData().copyWith();
    } catch(error) {
      throw Exception('${error} - Error to sign up');
    }
  }
}