import 'package:flutter/material.dart';

Container logo({double size = 50}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        'E',
        style: TextStyle(
          fontSize: size == 50 ? 30 : 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
