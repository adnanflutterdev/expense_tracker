import 'package:expense_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';

Container logo({double size = 50, required BuildContext context}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        'E',
        style: Theme.of(
          context,
        ).textTheme.headlineLarge?.copyWith(color: AppColors.white),
      ),
    ),
  );
}
