import 'package:expense_tracker/models/category_model.dart';
import 'package:flutter/material.dart';

List<CategoryModel> expenseCategories = [
  CategoryModel(label: 'Food & Dining', icon: '🍔'),
  CategoryModel(label: 'Transportation', icon: '🚗'),
  CategoryModel(label: 'Shopping', icon: '🛍️'),
  CategoryModel(label: 'Bills & Utilities', icon: '💡'),
  CategoryModel(label: 'Health', icon: '🏥'),
  CategoryModel(label: 'Entertainment', icon: '🎬'),
  CategoryModel(label: 'Others', icon: '📦'),
];

List<Color> expenseColor = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
];
