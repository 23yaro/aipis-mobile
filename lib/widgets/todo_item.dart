import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoCompleted;
  final onDeleteItem;
  final onChangeItem;
  final taskMargin;

  const ToDoItem(
      {super.key,
      required this.todo,
      required this.onToDoCompleted,
      required this.onDeleteItem,
      required this.onChangeItem,
      required this.taskMargin,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          taskMargin(todo);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: IconButton(
          color: tdBlue,
          iconSize: 24,
          icon: Icon(
              todo.isDone ? Icons.check_box : Icons.check_box_outline_blank),
          onPressed: () {
            // print('Clicked on delete icon');
            onToDoCompleted(todo);
          },
        ),
        title: Text(
          todo.todoName!,
          style: TextStyle(
            fontSize: 18,
            color: tdBlack,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            color: tdBlue,
            iconSize: 24,
            icon: const Icon(Icons.create_rounded),
            onPressed: () {
              // print('Clicked on delete icon');
              onChangeItem(todo);
            },
          ),
          IconButton(
            color: tdBlue,
            iconSize: 24,
            icon: const Icon(Icons.delete),
            onPressed: () {
              // print('Clicked on delete icon');
              onDeleteItem(todo.id);
            },
          ),
        ]),
      ),

    );


  }
}
