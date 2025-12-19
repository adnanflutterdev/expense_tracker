import 'package:flutter/material.dart';

void displaySnackBar({
  required BuildContext context,
  required bool isSuccess,
  required String message,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: isSuccess ? Colors.green : Colors.redAccent,
      content: Text(message),
    ),
  );
}
