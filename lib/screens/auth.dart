import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/model/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:aipis_calendar/constants/colors.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<StatefulWidget> createState() => AuthState();
}

class AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    if (AuthController.the.isLoggedIn()) {
      return const Scaffold();
    }

    return Scaffold(
        backgroundColor: tdBlue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Добро пожаловать',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                child: const Text("Войти")),
            ElevatedButton(
                onPressed: () {
                  print(CalendarEventRepository.the.getAllEvents());
                },
                child: const Text("Get"))
          ],
        ));
  }
}
