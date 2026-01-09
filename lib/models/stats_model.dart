import 'package:expense_tracker/models/category_model.dart';

class StatsModel {
  final CategoryModel category;
  final double amount;
  final double percentage;

  StatsModel({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  StatsModel copyWith({double? amount, double? percentage}) {
    return StatsModel(
      category: category,
      amount: amount ?? this.amount,
      percentage: percentage ?? this.percentage,
    );
  }
}
