import 'package:expense_tracker/models/category_model.dart';

class ExpenseTracker {
  final String id;
  final String type;
  final double budget;
  final CategoryModel category;
  final String date;
  final String? note;

  ExpenseTracker({
    required this.id,
    required this.type,
    required this.budget,
    required this.category,
    required this.date,
    this.note,
  });

  factory ExpenseTracker.fromFirebase(Map<String, dynamic> data) {
    return ExpenseTracker(
      id: data['id'],
      type: data['type'],
      budget: data['budget'],
      category: CategoryModel.fromFirebase(data['category']),
      date: data['date'],
      note: data['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'budget': budget,
      'category': category.toMap(),
      'date': date,
      'note': note,
    };
  }
}
