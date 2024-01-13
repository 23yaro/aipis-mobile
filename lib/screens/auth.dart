import 'package:aipis_calendar/api/auth.dart';
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
      Future.microtask(() =>
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false));
      return const Scaffold();
    }

    return Scaffold(
        backgroundColor: tdBlue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Добро пожаловать в Календарь',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40)),
            IntrinsicWidth(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text("Войти")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text("Зарегистрироваться"))
                  ]),
            )
          ],
        ));
  }
}
