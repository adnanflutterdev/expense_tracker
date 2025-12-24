import 'package:expense_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';

class ExpenseContainer extends StatelessWidget {
  const ExpenseContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.amount,
    required this.isUp,
  });
  final IconData icon;
  final String title;
  final String amount;
  final bool isUp;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 2.7,
      height: width / 5,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUp ? AppColors.inLight : AppColors.errorBg,
                  ),
                  child: Icon(
                    icon,
                    color: isUp ? AppColors.inBg : AppColors.errorText,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.shadow),
                ),
              ],
            ),
            Text(
              amount,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
