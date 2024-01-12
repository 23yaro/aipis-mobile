import 'package:flutter/material.dart';

void makeAlertWindow(BuildContext context, String s) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () => Navigator.pop(context),
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Ошибка"),
    content: Text(s),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
