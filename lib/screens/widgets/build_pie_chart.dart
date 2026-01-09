import 'package:expense_tracker/data/expense_category.dart';
import 'package:expense_tracker/models/stats_model.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BuildPieChart extends StatefulWidget {
  const BuildPieChart({
    super.key,
    required this.stats,
    required this.keys,
  });
  final Map<String,StatsModel> stats;
  final List<String> keys;

  @override
  State<BuildPieChart> createState() => _BuildPieChartState();
}

class _BuildPieChartState extends State<BuildPieChart> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        sections: List.generate(widget.keys.length, (index) {
          StatsModel statsModel = widget.stats[widget.keys[index]]!;
          return PieChartSectionData(
            title: '${statsModel.percentage.toStringAsFixed(0)}%',
            titleStyle: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.white),
            color: expenseColor[index],
            radius: 60,
            badgePositionPercentageOffset: statsModel.percentage,
          );
        }),
      ),
    );
  }
}
