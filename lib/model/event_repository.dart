import 'dart:io';

import 'package:aipis_calendar/api/events.dart';
import 'package:aipis_calendar/model/event.dart';

class CalendarEventRepository {
  static final CalendarEventRepository the = CalendarEventRepository._();

  List<CalendarEvent> events = List<CalendarEvent>.empty(growable: true);
  DateTime lastFetch = DateTime.fromMicrosecondsSinceEpoch(0);

  CalendarEventRepository._();

  factory CalendarEventRepository() => the;

  Future<List<CalendarEvent>> getAll([String simpleFilter = ""]) async {
    final date = DateTime.now();
    // Кешируем раз в пять минут
    // TODO: не кешируем, похер
    // if (date.difference(lastFetch).inMinutes < 5) {
    //   return events;
    // }

    // TODO
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

  Future<void> update(CalendarEvent event) async {
    try {
      await updateEvent(event);
    } on SocketException {
      throw UnimplementedError(
          "Локальное хранилище ещё не сделали, нужен интернет");
    }
  }

  Future<void> removeById(int id) async {
    try {
      await removeEvent(id);
    } on SocketException {
      throw UnimplementedError(
          "Локальное хранилище ещё не сделали, нужен интернет");
    }
  }

  Future<void> remove(CalendarEvent event) async =>
      removeById(event.id);
}
