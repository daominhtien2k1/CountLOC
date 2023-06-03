import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';
import '../configuration.dart';
import '../utils/token.dart';

class EventRepository {
  Future<EventList?> fetchEventList({String? searchBy}) async {
    final url = searchBy != null ?
    Uri.http(
        Configuration.baseUrlConnect, '/event/get_list_events', {'searchBy': searchBy})
    : Uri.http(
        Configuration.baseUrlConnect, '/event/get_list_events');

    var token = await Token.getToken();

    final response = await http.get(url,
        headers: {
          HttpHeaders.authorizationHeader: token,
        }
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final eventList = EventList.fromJson(body);
      return eventList;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }

  Future<EventDetail?> fetchDetailEvent({required String eventId}) async {
    final url = Uri.http(Configuration.baseUrlConnect, '/event/get_event/$eventId');

    var token = await Token.getToken();

    final response = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: token,
    });

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final eventDetail = EventDetail.fromJson(body['data']);
      return eventDetail;
    } else if (response.statusCode == 400) {
      return null;
    } else {
      return null;
    }
  }
}