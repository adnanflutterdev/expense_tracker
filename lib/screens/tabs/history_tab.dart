import 'package:expense_tracker/helper/sizedbox_extention.dart';
import 'package:expense_tracker/screens/widgets/my_expenses.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> chipIndex = ValueNotifier(0);
    List<String> chips = ['All', 'Expenses', 'Income'];
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ValueListenableBuilder(
        valueListenable: chipIndex,
        builder: (context, value, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('History', style: Theme.of(context).textTheme.titleLarge),
            20.h,
            Row(
              children: List.generate(chips.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      chipIndex.value = index;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: value == index
                            ? AppColors.primary
                            : AppColors.white,
                        border: value != index
                            ? Border.all(color: AppColors.mutedText, width: 0.5)
                            : null,
                      ),
                      child: Text(
                        chips[index],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: value == index
                              ? AppColors.white
                              : AppColors.text,
                          fontWeight: value == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            20.h,
            Expanded(child: MyExpenses(isShrinked: false, chip: chips[value])),
          ],
        ),
      ),
    );
  }
}
