class ToDo {
  String? id;
  String? todoName;
  String? todoText;
  DateTime todoTime;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoName,
    required this.todoText,
    required this.todoTime,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(
          id: '01',
          todoName: 'ахахахахах',
          todoText: '',
          todoTime: DateTime.now(),
          isDone: true),
      ToDo(
          id: '02',
          todoName: 'пенисс',
          todoText: '',
          todoTime: DateTime.parse('2024-01-13'),
          isDone: true)
    ];

  }

}
