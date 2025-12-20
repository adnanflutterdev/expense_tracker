import 'package:flutter/material.dart';

Widget title({
  double size = 30,
  MainAxisAlignment alignment = MainAxisAlignment.center,
}) => Row(
  mainAxisAlignment: alignment,
  children: [
    Text(
      'Expense',
      style: TextStyle(
        color: Colors.black,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      'Tracker',
      style: TextStyle(
        color: Colors.purpleAccent,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
);
