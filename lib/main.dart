import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/constants/settings.dart';
import 'package:aipis_calendar/screens/login_form.dart';
import 'package:aipis_calendar/screens/signup_form.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import './screens/event_screen.dart';
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
  WidgetsFlutterBinding.ensureInitialized();

  await initPreferences();
  initializeDateFormatting();
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
      title: 'Time Manager',
      initialRoute: AuthController.the.isLoggedIn() ? '/' : '/auth',
      routes: {
        '/': (context) => Home(),
        '/auth': (context) => Auth(),
        '/login': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/edit': (context) => EventEditor(),
      },
    );
  }
}
