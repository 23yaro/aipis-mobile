
import 'package:aipis_calendar/screens/login_form.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import './screens/todo_screen.dart';
import './screens/home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/auth.dart';

@pragma('vm:entry-point')
void refreshToken() {
  // TODO: do something
}

@pragma('vm:entry-point')
void getNewEvents() {
  // TODO: do something
}

@pragma('vm:entry-point')
void notifyAboutEvent() {
  // TODO: do something
}

void main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  // TODO: check auth
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      initialRoute: '/auth',
      routes: {
        '/': (context) => const Home(),
        '/auth': (context) => const Auth(),
        '/login': (context) => const Login(),
        '/todo_screen': (context) => const task(),
      },
    );
  }
}
