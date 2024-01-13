import 'package:aipis_calendar/model/event.dart';
import 'package:aipis_calendar/model/event_repository.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class EventEditor extends StatefulWidget {
  const EventEditor({super.key});

  @override
  State<EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {
  final _eventNameController = TextEditingController();
  final _eventDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final calendarEvent =
        (ModalRoute.of(context)?.settings.arguments ?? '') as CalendarEvent;
    _eventNameController.text = calendarEvent.name.toString();
    _eventDescriptionController.text = calendarEvent.description.toString();
    return PopScope(
      onPopInvoked: (didPop) {
        // Сохраняем изменения при выходе
        if (didPop) {
          CalendarEventRepository().update(calendarEvent);
        }
      },
      child: Scaffold(
        backgroundColor: tdBGColor,
        appBar: AppBar(
          title: Text(calendarEvent.name.toString()),
          leading: const BackButton(),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Text("Название:"),
                    Expanded(
                        child: TextField(
                      controller: _eventNameController,
                      onChanged: (text) {
                        calendarEvent.name = text;
                      },
                      decoration:
                          const InputDecoration(hintText: 'Моё событие'),
                    ))
                  ],
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _eventDescriptionController,
                    onChanged: (text) {
                      calendarEvent.description = text;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Описание', border: InputBorder.none),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
