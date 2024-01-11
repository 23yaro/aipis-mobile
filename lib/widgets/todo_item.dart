import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

class ToDoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoCompleted;
  final onDeleteItem;
  final onChangeItem;

  const ToDoItem(
      {Key? key,
      required this.todo,
      required this.onToDoCompleted,
      required this.onDeleteItem,
      required this.onChangeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: IconButton(
          color: tdBlue,
          iconSize: 24,
          icon: Icon(todo.isDone ? Icons.check_box : Icons.check_box_outline_blank),
          onPressed: () {
            // print('Clicked on delete icon');
            onToDoCompleted(todo);
          },
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
            fontSize: 18,
            color: tdBlack,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
            IconButton(
              color: tdBlue,
              iconSize: 24,
              icon: Icon(Icons.create_rounded),
              onPressed: () {
                // print('Clicked on delete icon');
                onChangeItem(todo);
              },
            ),
            IconButton(
              color: tdBlue,
              iconSize: 24,
              icon: Icon(Icons.delete),
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
