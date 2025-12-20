import 'package:expense_tracker/models/tab_model.dart';
import 'package:expense_tracker/screens/tabs/history_tab.dart';
import 'package:expense_tracker/screens/tabs/home_tab.dart';
import 'package:expense_tracker/screens/tabs/settings_tab.dart';
import 'package:expense_tracker/screens/tabs/stats_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> tabIndex = ValueNotifier(0);
    PageController pageController = PageController();

    List<Widget> pages = [HomeTab(), StatsTab(), HistoryTab(), SettingsTab()];

    List<TabModel> tabs = [
      TabModel(icon: Icons.home_outlined, label: 'Home'),
      TabModel(icon: Icons.pie_chart_outline, label: 'Stats'),
      TabModel(icon: Icons.history, label: 'History'),
      TabModel(icon: Icons.settings_outlined, label: 'Settings'),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (value) {
                  tabIndex.value = value;
                },
                itemBuilder: (context, index) {
                  return pages[index];
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(width: 0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ValueListenableBuilder(
                  valueListenable: tabIndex,
                  builder: (context, value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(tabs.length, (index) {
                        TabModel tab = tabs[index];
                        return GestureDetector(
                          onTap: () {
                            pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.decelerate,
                            );
                          },
                          child: Column(
                            children: [
                              Icon(
                                tab.icon,
                                color: index == value
                                    ? Colors.deepPurple
                                    : Colors.grey,
                              ),
                              Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: index == value
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
