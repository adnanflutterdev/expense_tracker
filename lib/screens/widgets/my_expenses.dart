import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/helper/sizedbox_extention.dart';
import 'package:expense_tracker/models/expense_tracker.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyExpenses extends StatelessWidget {
  const MyExpenses({super.key, this.isShrinked = true, this.chip = 'All'});
  final bool isShrinked;
  final String chip;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    void deleteExpense(String id) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('expenses')
          .doc(id)
          .delete();
      if (!context.mounted) return;
      Navigator.pop(context);
    }

    void openAlertDialog(String id) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Deleting Expense'),
            content: Text('Are you sure to delete'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(onPressed: () => deleteExpense(id), child: Text('OK')),
            ],
          );
        },
      );
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('expenses')
          .orderBy('id', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null || !snapshot.hasData) {
          return Center(child: Text('No Data Found'));
        }

        List<ExpenseTracker> expensesFromFirebase = snapshot.data!.docs
            .map((data) => ExpenseTracker.fromFirebase(data.data()))
            .toList();
        List<ExpenseTracker> expenses = [];
        if (chip == 'All') {
          expenses = expensesFromFirebase;
        } else if (chip == 'Expenses') {
          expenses = expensesFromFirebase
              .where((expense) => expense.type == 'Expense')
              .toList();
        } else {
          expenses = expensesFromFirebase
              .where((expense) => expense.type == 'Income')
              .toList();
        }

        print(expenses);
        return ListView.builder(
          shrinkWrap: isShrinked,
          physics: isShrinked
              ? NeverScrollableScrollPhysics()
              : ScrollPhysics(),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            ExpenseTracker expense = expenses[index];
            bool isExpense = expense.type == 'Expense';
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.shadow,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          expense.category.icon,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                    10.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.type,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          expense.date,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.subText),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '${isExpense ? '-' : '+'}₹${expense.budget}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isExpense
                            ? AppColors.errorText
                            : AppColors.success,
                      ),
                    ),
                    IconButton(
                      onPressed: () => openAlertDialog(expense.id),
                      icon: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: AppColors.subText,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
