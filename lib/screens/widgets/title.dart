import 'package:expense_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';

Widget title({
  double size = 30,
  MainAxisAlignment alignment = MainAxisAlignment.center,
  required BuildContext context,
}) => Row(
  mainAxisAlignment: alignment,
  children: [
    Text(
      'Expense',
      style: Theme.of(
        context,
      ).textTheme.headlineLarge?.copyWith(fontSize: size),
    ),
    Text(
      'Tracker',
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        color: AppColors.primary,
        fontSize: size,
      ),
    ),
  ],
);
