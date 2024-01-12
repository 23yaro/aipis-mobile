class CalendarEvent {
  int id;
  String? name;
  String? description;
  List<int> tagIds;
  DateTime dateTime;

  CalendarEvent(
      {required this.id,
      this.name,
      this.description,
      required this.dateTime,
      required this.tagIds});

  CalendarEvent.fromJson(Map<String, dynamic> json)
      : id = json['eventId'] as int,
        name = json['eventName'] as String?,
        description = json['eventDesc'] as String?,
        dateTime = DateTime.parse(json['eventDate'] as String),
        tagIds = json['tags'] as List<int>;
}
