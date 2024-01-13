import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/api/events.dart';
import 'package:aipis_calendar/model/event.dart';
import 'package:aipis_calendar/model/event_repository.dart';
import 'package:aipis_calendar/screens/shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../widgets/event_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  num curDay = int.parse(DateFormat('d').format(DateTime.now()));
  int currentDayOfWeek = DateTime.now().weekday;
  final _ceController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
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
                      child: FutureBuilder<List<CalendarEvent>>(
                          future: _getCurrentWeek(),
                          builder: (BuildContext context,
                                  AsyncSnapshot<List<CalendarEvent>> list) =>
                              ListView(
                                  padding: const EdgeInsets.only(top: 15),
                                  children: list.data
                                          ?.map((ce) => Column(
                                                children: [
                                                  Text(
                                                      '${DateFormat('Hm').format(ce.dateTime)} ${ce.tagIds.map((e) => e.name).join(", ")}',
                                                      textAlign:
                                                          TextAlign.center),
                                                  CalendarEventItem(
                                                    calendarEvent: ce,
                                                    onEventCompleted:
                                                        _handleCECompleted,
                                                    onDeleteItem: _deleteCEItem,
                                                    onChangeItem: _CEChange,
                                                    taskMargin: (ce) {
                                                      _CEOpen(ce);
                                                    },
                                                  ),
                                                ],
                                              ))
                                          .toList() ??
                                      [])))
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
                      controller: _ceController,
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
                      _addCEItem(_ceController.text);
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
    } on NotLoggedInException {
      Future.microtask(() => gotoAuth(context));
      return Scaffold(
          backgroundColor: tdBGColor,
          appBar: _buildAppBar(),
          drawer: _buildDrawer());
    }
  }

  void _handleCECompleted(CalendarEvent ce) {
    ce.complete = !ce.complete;
    CalendarEventRepository().update(ce);
    // TODO: do we even need this?
    setState(() {});
  }

  void _deleteCEItem(int id) {
    CalendarEventRepository().removeById(id);
    setState(() {});
  }

  void _addCEItem(String toDo) async {
    if (_ceController.text != '') {
      TimeOfDay? selectedTime;
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
      );
      selectedTime = timeOfDay;

      if (selectedTime == null) {
        return;
      }

      final now = DateTime.now();

      CalendarEvent add = await createEvent(
          toDo,
          '',
          DateTime(now.year, now.month, curDay.toInt(), selectedTime.hour,
              selectedTime.minute));
      // TODO: same
      setState(() {});
      _ceController.clear();
    }
  }

  void _CEChange(CalendarEvent ce) {
    if (_ceController.text != '') {
      ce.name = _ceController.text;
      CalendarEventRepository().update(ce);
      setState(() {
        _ceController.clear();
      });
    }
  }

  Future<void> _CEOpen(CalendarEvent ce) async {
    // Ждём, пока пользователь закончит редактировать
    final result = await Navigator.pushNamed(context, '/edit', arguments: ce);

    if (!mounted) {
      return;
    }

    // TODO:
    setState(() {});
  }

  final DateFormat formatter = DateFormat('EEEE', 'ru_RU');

  AppBar _buildAppBar() {
    final now = DateTime.now();
    return AppBar(
      leading: const DrawerButton(),
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Text(toBeginningOfSentenceCase(formatter.dateSymbols.STANDALONEWEEKDAYS[currentDayOfWeek]))
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
                          // TODO:
                          currentDayOfWeek = e.key;
                        });
                      },
                      title: Text(
                        toBeginningOfSentenceCase(e.value),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          letterSpacing: 4.5,
                        ),
                      ),
                    ))
                .toList(),
          )),
          ListTile(
              onTap: () {
                Widget yesButton = TextButton(
                  child: const Text("Да"),
                  onPressed: () {
                    AuthController().logOut();
                    gotoAuth(context);
                  },
                );
                Widget noButton = TextButton(
                  child: const Text("Нет"),
                  onPressed: () => Navigator.pop(context),
                );

                AlertDialog alert = AlertDialog(
                  title: const Text("Внимание"),
                  content:
                      const Text("Вы действительно хотите выйти из аккаунта?"),
                  actions: [yesButton, noButton],
                );

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
              title: const Row(
                  children: [Icon(Icons.logout), Text("Выйти из аккаунта")]))
        ],
      ),
    );
  }

  Future<List<CalendarEvent>> _getCurrentWeek() async {
    List<CalendarEvent> tasks = (await CalendarEventRepository().getAll())
        .where((element) => element.dateTime.weekday == currentDayOfWeek)
        .toList();
    tasks.sort((a, b) {
      return a.dateTime.compareTo(b.dateTime);
    });
    return tasks;
  }
}
