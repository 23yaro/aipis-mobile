import 'package:aipis_calendar/model/tag.dart';

class CalendarEvent {
  int id;
  bool complete;
  String? name;
  String? description;
  List<CalendarTag> tagIds;
  DateTime dateTime;

  CalendarEvent(
      {required this.id,
      this.complete = false,
      this.name,
      this.description,
      required this.dateTime,
      required this.tagIds});

  CalendarEvent.fromJson(Map<String, dynamic> json)
      : id = json['eventId'] as int,
        complete = json['eventCompletion'] as bool,
        name = json['eventName'] as String?,
        description = json['eventDesc'] as String?,
        dateTime = DateTime.parse(json['eventDate'] as String),
        // TODO: tags parsing does not work yet
        tagIds =
            (json['tags'] as List).map((e) => CalendarTag.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {
        'eventId': id,
        'eventCompletion': complete,
        'eventName': name,
        'eventDesc': description,
        'eventDate': dateTime.toIso8601String(),
        'tags': tagIds.map((e) => e.id).toList()
      };
}
