import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/data/expense_category.dart';
import 'package:expense_tracker/data/income_category.dart';
import 'package:expense_tracker/helper/show_snackbars.dart';
import 'package:expense_tracker/helper/sizedbox_extention.dart';
import 'package:expense_tracker/models/category_model.dart';
import 'package:expense_tracker/models/expense_tracker.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionSheet extends StatefulWidget {
  const TransactionSheet({super.key});

  @override
  State<TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends State<TransactionSheet> {
  int tabIndex = 0;
  int selectedIndex = -1;
  bool hasErrorMessage = false;
  PageController pageController = PageController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List<Map<String, dynamic>> tabLabel = [
    {'label': 'Expense', 'color': AppColors.errorText},
    {'label': 'Income', 'color': AppColors.success},
  ];

  void upload() async {
    if (amountController.text.trim().isEmpty ||
        selectedIndex == -1 ||
        dateController.text.isEmpty) {
      hasErrorMessage = true;
      setState(() {});
    } else {
      ExpenseTracker expenseTracker = ExpenseTracker(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: tabIndex == 0 ? 'Expense' : 'Income',
        budget: double.parse(amountController.text.trim()),
        category: tabIndex == 0
            ? expenseCategories[selectedIndex]
            : incomeCategories[selectedIndex],
        date: dateController.text,
        note: noteController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('expenses')
          .doc(expenseTracker.id)
          .set(expenseTracker.toMap());

      if (!mounted) return;
      displaySnackBar(
        context: context,
        isSuccess: true,
        message: 'Expense add...',
      );
      Navigator.pop(context);
    }
  }

  void openDatePicker() async {
    DateTime? result = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (result != null) {
      dateController.text = '${result.day}-${result.month}-${result.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: (8 / 10) * height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(30),
          right: Radius.circular(30),
        ),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Transaction',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel_outlined),
                ),
              ],
            ),

            if (hasErrorMessage)
              Text(
                'Add required data before saving...',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.errorText),
              ),

            20.h,
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.shadow,
              ),
              child: Row(
                children: List.generate(2, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Container(
                        width: (width - 62) / 2,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: tabIndex == index
                              ? AppColors.white
                              : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            tabLabel[index]['label'],
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: tabIndex == index
                                      ? tabLabel[index]['color']
                                      : AppColors.subText,
                                ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            20.h,
            Expanded(
              child: PageView.builder(
                itemCount: 2,
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    tabIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.currency_rupee,
                              color: AppColors.subText,
                            ),
                            hintText: '0.00',
                            hintStyle: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.mutedText),
                          ),
                        ),
                        20.h,
                        Text(
                          'CATEGORY',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: AppColors.subText),
                        ),
                        10.h,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            itemCount: tabIndex == 0
                                ? expenseCategories.length
                                : incomeCategories.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 1.3,
                                ),
                            itemBuilder: (context, index) {
                              CategoryModel category = tabIndex == 0
                                  ? expenseCategories[index]
                                  : incomeCategories[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: selectedIndex == index
                                        ? Border.all(color: AppColors.primary)
                                        : null,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        color: AppColors.shadow,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        category.icon,
                                        style: TextStyle(fontSize: 30),
                                      ),
                                      Text(
                                        category.label,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        20.h,
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DATE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.subText),
                                  ),
                                  TextField(
                                    controller: dateController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 0,
                                      ),
                                      suffixIcon: Icon(Icons.calendar_month),
                                    ),
                                    onTap: openDatePicker,
                                  ),
                                ],
                              ),
                            ),
                            10.w,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NOTE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.subText),
                                  ),
                                  TextField(
                                    controller: noteController,
                                    decoration: InputDecoration(
                                      hintText: 'Details',
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 0,
                                      ),
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: AppColors.mutedText,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        20.h,
                        SizedBox(
                          width: width,
                          child: ElevatedButton(
                            onPressed: upload,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(12),
                              ),
                            ),
                            child: Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
