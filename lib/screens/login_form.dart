import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/constants/colors.dart';
import 'package:aipis_calendar/constants/regex.dart';
import 'package:aipis_calendar/model/event_repository.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool authenticating = false;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Адрес электронной почты',
                            hintText: "test@example.com",
                            prefixIcon: Icon(Icons.email)),
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return "Введите почту";
                          }

                          if (emailPattern.hasMatch(s)) {
                            return null;
                          }

                          return "Неправильный адрес E-Mail";
                        },
                        onSaved: (v) {
                          email = v!;
                        }),
                    TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: const InputDecoration(
                          labelText: 'Пароль',
                          prefixIcon: Icon(Icons.password),
                        ),
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return "Введите пароль";
                          }

                          if (passwordPattern.hasMatch(s)) {
                            return null;
                          }

                          return "Пароль должен как минимум 8 символов, одну строчную и одну заглавную букву.";
                        },
                        onSaved: (v) {
                          password = v!;
                        }),
                    ElevatedButton(
                        onPressed: authenticating
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                _formKey.currentState!.save();

                                authenticating = true;
                                try {
                                  await AuthController.the
                                      .login(email, password);
                                  if (AuthController.the.isLoggedIn()) {
                                    print(await CalendarEventRepository()
                                        .getAllEvents());
                                    if (context.mounted) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/');
                                      return;
                                    }
                                  }
                                } on Exception catch (e) {
                                  Widget okButton = TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {},
                                  );

                                  AlertDialog alert = AlertDialog(
                                    title: const Text("Ошибка"),
                                    content: Text("$e"),
                                    actions: [
                                      okButton,
                                    ],
                                  );

                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                  }
                                }
                                authenticating = false;
                              },
                        child: const Text("Войти"))
                  ],
                ))));
  }
}
