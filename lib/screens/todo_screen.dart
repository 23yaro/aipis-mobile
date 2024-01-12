import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';
import '../widgets/todo_item.dart';
import '../screens/home.dart';


class task extends StatefulWidget {
  task({super.key});

  @override
  State<task> createState() => _taskState();
}


class _taskState extends State<task> {
  final _taskController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final todo_item = (ModalRoute.of(context)?.settings.arguments ?? '') as ToDo;
    _taskController.text = todo_item.todoText.toString();
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        title: Text(todo_item.todoName.toString()),
        leading: BackButton(onPressed: ()=>{Navigator.pop(context, todo_item.todoText)},),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _taskController,
                    onChanged:(text){
                      todo_item.todoText=text;
                    },
                    decoration: InputDecoration(
                        hintText: 'Описание', border: InputBorder.none),
                  ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
