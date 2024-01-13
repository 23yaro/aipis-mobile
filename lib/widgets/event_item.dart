import 'package:aipis_calendar/model/event.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CalendarEventItem extends StatelessWidget {
  final CalendarEvent calendarEvent;
  final void Function(CalendarEvent) onEventCompleted;
  final onDeleteItem;
  final onChangeItem;
  final taskMargin;

  const CalendarEventItem({
    super.key,
    required this.calendarEvent,
    required this.onEventCompleted,
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
          taskMargin(calendarEvent);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: IconButton(
          color: tdBlue,
          iconSize: 24,
          icon: Icon(calendarEvent.complete
              ? Icons.check_box
              : Icons.check_box_outline_blank),
          onPressed: () {
            // print('Clicked on delete icon');
            onEventCompleted(calendarEvent);
          },
        ),
        title: Text(
          calendarEvent.name ?? "",
          style: TextStyle(
            fontSize: 18,
            color: tdBlack,
            decoration:
                calendarEvent.complete ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            color: tdBlue,
            iconSize: 24,
            icon: const Icon(Icons.create_rounded),
            onPressed: () {
              // print('Clicked on delete icon');
              onChangeItem(calendarEvent);
            },
          ),
          IconButton(
            color: tdBlue,
            iconSize: 24,
            icon: const Icon(Icons.delete),
            onPressed: () {
              // print('Clicked on delete icon');
              onDeleteItem(calendarEvent.id);
            },
          ),
        ]),
      ),
    );
  }
}
