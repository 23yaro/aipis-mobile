import 'dart:convert';
import 'dart:io';

import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/model/event.dart';
import 'package:aipis_calendar/model/tag.dart';
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
    if (eventsJson is List) {
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

  var response = await http.get(Uri.parse(urlApiEventUniversal), headers: {
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

Future<CalendarEvent> createEvent(
    String name, String description, DateTime dateTime,
    [List<CalendarTag>? tags]) async {
  AuthController().assertLoggedIn();

  var response = await http.post(Uri.parse(urlApiEventUniversal),
      body: jsonEncode({
        "eventName": name,
        "eventDesc": description,
        "eventDate": dateTime.toIso8601String(),
        "eventCompletion": false,
        "tags": []
      }),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer ${AuthController().getAccessToken()}"
      });
  if (response.statusCode == HttpStatus.ok) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return CalendarEvent.fromJson(json);
  }
  throw Exception('Failed to create an event: ${response.statusCode}');
}

Future<void> updateEvent(CalendarEvent event) async {
  AuthController().assertLoggedIn();

  // TODO: pushing the whole object is a bad idea
  var response = await http.patch(
      Uri.parse("$urlApiEventUniversal/${event.id}"),
      body: jsonEncode(event.toJson()),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer ${AuthController().getAccessToken()}"
      });
  if (response.statusCode == HttpStatus.ok) {
    // TODO: update event from the returned JSON
    // final json = jsonDecode(response.body) as Map<String, dynamic>;
    // return CalendarEvent.fromJson(json);
    return;
  }

  throw Exception('Failed to update the event: ${response.statusCode}');
}

Future<void> removeEvent(int id) async {
  AuthController().assertLoggedIn();

  var response =
      await http.delete(Uri.parse("$urlApiEventUniversal/$id"), headers: {
    'Accept': 'application/json',
    "Authorization": "Bearer ${AuthController().getAccessToken()}"
  });
  if (response.statusCode == HttpStatus.ok) {
    return;
  }
  throw Exception('Failed to remove the event: ${response.statusCode}');
}
