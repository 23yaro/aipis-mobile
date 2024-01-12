import 'dart:ffi' hide Size;
import 'package:aipis_calendar/screens/todo_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList(); //все таски
  List<ToDo> currentWeek = List<ToDo>.empty();
  num curDay = int.parse(DateFormat('d').format(DateTime.now()));
  final _todoController = TextEditingController();

  @override
  void initState() {

    currentWeek = _getCurrentWeek();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 80,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 15),
                    children: [
                      for (ToDo todoo in currentWeek)
                        Column(
                          children: [
                            Text(DateFormat('Hm').format(todoo.todoTime) + ' ' + todoo.tagName),
                            ToDoItem(
                              todo: todoo,
                              onToDoCompleted: _handleToDoCompleted,
                              onDeleteItem: _deleteToDoItem,
                              onChangeItem: _ToDoChange,
                              taskMargin: _ToDoOpen,
                            ),
                          ],
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                        hintText: 'Новая задача', border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleToDoCompleted(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      currentWeek.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String toDo) async {
    if (_todoController.text != '') {
    TimeOfDay? selectedTime;
    final TimeOfDay? timeofDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    selectedTime = timeofDay;

    if (selectedTime == null) {
      return;
    }

    final now = DateTime.now();

      setState(() {
        ToDo add = ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoName: toDo,
          todoText: '',
          todoTime: DateTime(now.year, now.month, curDay.toInt(),
              selectedTime!.hour, selectedTime.minute),
        );

        currentWeek.add(add);
        todosList.add(add);
        currentWeek.sort((a, b){ //sorting in descending order
          return a.todoTime.compareTo(b.todoTime);
        });
      });
      _todoController.clear();
    }
    else return;
  }

  void _ToDoChange(ToDo todo) {
    if (_todoController.text != '') {
      setState(() {
        todo.todoName = _todoController.text;
        _todoController.clear();
      });
    }
  }

  void _ToDoOpen(ToDo todo) {
    Navigator.pushNamed(context, '/todo_screen', arguments: todo);
  }

  final DateFormat formatter = DateFormat('EEEE', 'ru_RU');

  AppBar _buildAppBar() {
    return AppBar(
      leading: const DrawerButton(),
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(toBeginningOfSentenceCase(formatter.format(DateTime.now())))
      ]),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
              child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 80),
            children: formatter.dateSymbols.STANDALONEWEEKDAYS
                .asMap()
                .entries
                .map((e) => ListTile(
                      onTap: () {
                        setState(() {
                          currentWeek = _getWeek(e.key);
                        });
                      },
                      title: Text(
                        e.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          letterSpacing: 4.5,
                        ),
                      ),
                    ))
                .toList(),
          ))
        ],
      ),
    );
  }

  List<ToDo> _getCurrentWeek() {
    List<ToDo> tasks = todosList
        .where((element) =>
            DateFormat('MEd').format(element.todoTime) ==
            DateFormat('MEd').format(
                DateTime.now())) //ТУТ НУЖНО СДЕЛАТЬ ВЫБОР ВРЕМЕНИ В ПРИЛОЖУХЕ
        .toList();
    currentWeek.sort((a, b){ //sorting in descending order
      return a.todoTime.compareTo(b.todoTime);
    });
    return tasks;
  }

  List<ToDo> _getWeek(key) {
    int curdayNumber = 1;

    String weekDay = DateFormat('EEEE', 'ru_RU').format(DateTime.now());

    for (final day in formatter.dateSymbols.STANDALONEWEEKDAYS) {
      if (day == weekDay) break;
      curdayNumber = curdayNumber + 1;
    }

    String date = DateFormat('d').format(DateTime.now());
    curDay = int.parse(date) - (curdayNumber - key) + 1;

    List<ToDo> tasks = todosList
        .where((element) =>
            int.parse(DateFormat('d').format(element.todoTime)) == curDay)
        .toList();



    return tasks;
  }
}
