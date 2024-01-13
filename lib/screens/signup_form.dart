import 'package:aipis_calendar/api/auth.dart';
import 'package:aipis_calendar/constants/regex.dart';
import 'package:aipis_calendar/model/event_repository.dart';
import 'package:aipis_calendar/screens/shared.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<StatefulWidget> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
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
                    // TextFormField(
                    //     keyboardType: TextInputType.visiblePassword,
                    //     obscureText: true,
                    //     enableSuggestions: false,
                    //     autocorrect: false,
                    //     decoration: const InputDecoration(
                    //       labelText: 'Повторите пароль',
                    //       prefixIcon: Icon(Icons.password),
                    //     ),
                    //     validator: (s) {
                    //       if (s == null || s.isEmpty || s != password) {
                    //         return "Введите такой же пароль";
                    //       }
                    //
                    //       return null;
                    //     }),
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
                                      .signUp(email, password);
                                  await AuthController.the
                                      .signIn(email, password);
                                  if (AuthController.the.isLoggedIn()) {
                                    print(await CalendarEventRepository()
                                        .getAll());
                                    if (context.mounted) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/');
                                      return;
                                    }
                                  }
                                } on UserAlreadyExistsException {
                                  if (context.mounted) {
                                    makeAlertWindow(context,
                                        "Пользователь с такой почтой уже существует.");
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    makeAlertWindow(context, "$e");
                                  }
                                }
                                authenticating = false;
                              },
                        child: const Text("Создать аккаунт"))
                  ],
                ))));
  }
}
