import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';
import '../screens/todo_screen.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final todosList = ToDo.todoList();
  List<ToDo> currentWeek = List<ToDo>.empty();
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
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 80,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.only(top: 15),
                    children: [
                      for (ToDo todoo in currentWeek)
                        ToDoItem(
                          todo: todoo,
                          onToDoCompleted: _handleToDoCompleted,
                          onDeleteItem: _deleteToDoItem,
                          onChangeItem: _ToDoChange,
                          taskMargin: _ToDoOpen,
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
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                    left: 20,
                  ),
                  padding: EdgeInsets.symmetric(
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
                    decoration: InputDecoration(
                        hintText: 'Новая задача', border: InputBorder.none),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: tdBlue,
                    minimumSize: Size(60, 60),
                    elevation: 10,
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

  void _addToDoItem(String toDo) {
    if (_todoController.text != '') {
      setState(() {
        ToDo add = ToDo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          todoName: toDo,
          todoText: '',
          todoTime: DateTime.now(),
        );
        currentWeek.add(add);
        todosList.add(add);
      });
      _todoController.clear();
    }
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
  void sex(){}
  final DateFormat formatter = DateFormat('EEEE', 'ru_RU');

  AppBar _buildAppBar() {
    return AppBar(
      leading: DrawerButton(),
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
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 80),
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
                        style: TextStyle(
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
    return tasks;
  }

  List<ToDo> _getWeek(key) {
    int curDay_number = 1;

    String weekGay = DateFormat('EEEE', 'ru_RU').format(DateTime.now());

    for (final gay in formatter.dateSymbols.STANDALONEWEEKDAYS) {
      if (gay == weekGay) break;
      curDay_number = curDay_number + 1;
    }

    String date = DateFormat('d').format(DateTime.now());
    num curDay = int.parse(date) - (curDay_number - key) + 1;

    List<ToDo> tasks = todosList
        .where((element) =>
            int.parse(DateFormat('d').format(element.todoTime)) == curDay)
        .toList();
    return tasks;
  }
}
