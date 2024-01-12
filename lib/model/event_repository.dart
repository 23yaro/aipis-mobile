import 'dart:io';

import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/api/events.dart';
import 'package:aipis_calendar/model/event.dart';

class CalendarEventRepository {
  static final CalendarEventRepository the = CalendarEventRepository._();

  List<CalendarEvent> events = List<CalendarEvent>.empty(growable: true);
  DateTime lastFetch = DateTime.fromMicrosecondsSinceEpoch(0);

  CalendarEventRepository._();

  factory CalendarEventRepository() => the;

  Future<List<CalendarEvent>> getAllEvents([String simpleFilter = ""]) async {
    final date = DateTime.now();
    // Кешируем раз в пять минут
    if (date.difference(lastFetch).inMinutes < 5) {
      return events;
    }

    // TODO: пиздец
    try {
      var response = await getEvents(999, 0, simpleFilter);
      lastFetch = DateTime.now();
      events = response.events;
    } on SocketException {
      // Нет соединения с интернетом, пробуем достать из локального хранилища
      // TODO: кеш в локальное хранилище для оффлайн уведомлений
      throw UnimplementedError(
          "Локальное хранилище ещё не сделали, нужен интернет");
    }

    return events;
  }
}
