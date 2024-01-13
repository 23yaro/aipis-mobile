class CalendarTag {
  int id;
  String name;
  String? description;
  String color;

  CalendarTag(
      {required this.id,
      required this.name,
      this.description,
      required this.color});

  CalendarTag.fromJson(Map<String, dynamic> json)
      : id = json['tagId'] as int,
        name = json['tagName'] as String,
        description = json['tagDesc'] as String?,
        color = json['tagColor'] as String;
}
