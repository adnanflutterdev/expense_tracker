import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/helper/sizedbox_extention.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/screens/transaction_sheet.dart';
import 'package:expense_tracker/screens/widgets/expense_container.dart';
import 'package:expense_tracker/screens/widgets/my_expenses.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 30;

    final uid = FirebaseAuth.instance.currentUser?.uid;

    void openSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return TransactionSheet();
        },
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),

        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: width,
                // height: (2.5 / 10) * height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [AppColors.gradientSt, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 0.5],
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    Positioned(
                      right: -((1.3 / 5) * width) / 5,
                      top: -((1.3 / 5) * width) / 5,
                      child: Container(
                        width: (1.3 / 5) * width,
                        height: (1.3 / 5) * width,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Balance',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                          Text(
                            '₹20,000.00',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(color: AppColors.white),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ExpenseContainer(
                                icon: Icons.trending_up,
                                title: 'INCOME',
                                amount: '1,234',
                                isUp: true,
                              ),
                              ExpenseContainer(
                                icon: Icons.trending_down,
                                title: 'EXPENSE',
                                amount: '234',
                                isUp: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data == null || snapshot.hasError) {
                    return Center(child: Text('Error occured'));
                  }
                  UserModel userData = UserModel.fromFirebase(
                    snapshot.data!.data()!,
                  );

                  double widthPer =
                      (userData.spent * 100) / userData.monthlyBudget;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Budget',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(
                            '₹${userData.spent}/₹${userData.monthlyBudget}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.subText),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '$widthPer%',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 15,
                            width: width - 16,
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.5),
                                    color: AppColors.shadow,
                                  ),
                                ),
                                Container(
                                  width: (widthPer / 100) * (width - 16),
                                  height: 15,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7.5),
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              20.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent'),
                  TextButton.icon(
                    onPressed: () {
                      // pageController.animateToPage(
                      //   2,
                      //   duration: Duration(milliseconds: 300),
                      //   curve: Curves.easeIn,
                      // );
                      pageController.jumpToPage(2);
                    },
                    style: TextButton.styleFrom(
                      iconAlignment: IconAlignment.end,
                      iconSize: 15,
                    ),
                    icon: Icon(Icons.arrow_forward_ios),
                    label: Text('View all'),
                  ),
                ],
              ),
              20.h,
              MyExpenses(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openSheet,
        backgroundColor: Colors.deepPurple,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
