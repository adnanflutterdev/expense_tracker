import 'package:expense_tracker/screens/widgets/expense_container.dart';
import 'package:expense_tracker/screens/widgets/logo.dart';
import 'package:expense_tracker/screens/widgets/title.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: logo(size: 30, context: context),
        ),
        title: title(
          size: 22,
          alignment: MainAxisAlignment.start,
          context: context,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),

        child: Column(
          children: [
            Container(
              width: width - 30,
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        backgroundColor: Colors.deepPurple,
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
