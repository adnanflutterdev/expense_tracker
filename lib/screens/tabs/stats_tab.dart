import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/helper/sizedbox_extention.dart';
import 'package:expense_tracker/models/expense_tracker.dart';
import 'package:expense_tracker/models/stats_model.dart';
import 'package:expense_tracker/screens/widgets/build_pie_chart.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - 30;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('expenses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null || snapshot.hasError) {
          return Center(child: Text('No Data Found'));
        }
        // List<QueryDocumentSnapshot<Map<String, dynamic>>> dataFromFirebase =
        //     snapshot.data!.docs;
        List<ExpenseTracker> expenses = snapshot.data!.docs
            .map((data) => ExpenseTracker.fromFirebase(data.data()))
            .toList();
        expenses = expenses
            .where((expense) => expense.type == 'Expense')
            .toList();
        double totalAmount = 0;
        for (final i in expenses) {
          totalAmount += i.budget;
        }
        print(totalAmount);
        List<String> categories = [];
        Map<String, StatsModel> stats = {};
        for (ExpenseTracker expense in expenses) {
          // print(expense.category.label);
          if (categories.contains(expense.category.label)) {
            // print('Already contained');
            StatsModel statsModel = stats[expense.category.label]!;
            double newAmount = statsModel.amount + expense.budget;
            stats[expense.category.label] = statsModel.copyWith(
              amount: newAmount,
              percentage: (newAmount / totalAmount) * 100,
            );
          } else {
            categories.add(expense.category.label);
            // print('added');
            stats.addAll({
              expense.category.label: StatsModel(
                category: expense.category,
                amount: expense.budget,
                percentage: (expense.budget / totalAmount) * 100,
              ),
            });
          }
        }

        print(stats['Food & Dining']!.percentage);
        // List<Widget> list = [Text('data'), Text('data')];

        List<String> keys = stats.keys.toList();
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Analytics',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                20.h,
                SizedBox(
                  width: width,
                  height: width,
                  child: Stack(
                    children: [
                      Card(
                        color: AppColors.white,
                        child: Container(
                          width: width,
                          height: width,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text('Expense Breakdown'),
                                20.h,
                                Expanded(
                                  child: BuildPieChart(
                                    stats: stats,
                                    keys: keys,
                                  ),
                                ),
                                20.h,
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: (width / 2) - 20,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.subText),
                            ),
                            Text(
                              '₹${totalAmount}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                20.h,
                Text(
                  'Top Categories',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                // Column(
                //   children: list,
                // )
                // Spread operator
                // ...list
                ...List.generate(stats.length, (index) {
                  StatsModel statsModel = stats[keys[index]]!;
                  return Card(
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Text(statsModel.category.icon),
                          10.w,
                          Text(statsModel.category.label),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                '₹${statsModel.amount}',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(
                                '${statsModel.percentage.toStringAsFixed(2)}%',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.subText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
