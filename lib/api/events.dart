import 'dart:convert';
import 'dart:io';

import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/model/event.dart';
import 'package:http/http.dart' as http;

import 'package:aipis_calendar/constants/urls.dart';

class GetEventsResponse {
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final int elementsPerPage;
  final List<CalendarEvent> events;

  const GetEventsResponse(
      {required this.totalElements,
      required this.totalPages,
      required this.currentPage,
      required this.elementsPerPage,
      required this.events});

  factory GetEventsResponse.fromJson(Map<String, dynamic> json) {
    var events = List<CalendarEvent>.empty();
    final dynamic eventsJson = json['list'];
    if (eventsJson is List<Map<String, dynamic>>) {
      events = eventsJson.map((e) => CalendarEvent.fromJson(e)).toList();
    }
    return GetEventsResponse(
        totalElements: json['totalElements'] as int,
        totalPages: json['totalPages'] as int,
        currentPage: json['currentPage'] as int,
        elementsPerPage: json['elementsPerPage'] as int,
        events: events);
  }
}

Future<GetEventsResponse> getEvents(
    [int perPage = 10, int page = 0, String simpleFilter = ""]) async {
  AuthController().assertLoggedIn();

  var response = await http.get(Uri.parse(urlApiEventGetAll), headers: {
    'Accept': 'application/json',
    "Authorization": "Bearer ${AuthController().getAccessToken()}"
  });
  if (response.statusCode == HttpStatus.ok) {
    return GetEventsResponse.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load events: ${response.statusCode}');
  }
}
