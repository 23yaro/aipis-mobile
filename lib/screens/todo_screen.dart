import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';


class task extends StatefulWidget {
  const task({super.key});

  @override
  State<task> createState() => _taskState();
}


class _taskState extends State<task> {
  final _taskController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final todoItem = (ModalRoute.of(context)?.settings.arguments ?? '') as ToDo;
    _taskController.text = todoItem.todoText.toString();
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        title: Text(todoItem.todoName.toString()),
        leading: BackButton(onPressed: ()=>{Navigator.pop(context, todoItem.todoText)},),
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
                      todoItem.todoText=text;
                    },
                    decoration: const InputDecoration(
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
