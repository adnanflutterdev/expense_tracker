import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    TextEditingController budgetController = TextEditingController();

    void updateBudget() async {
      await FirebaseFirestore.instance.collection('user').doc(uid).update({
        'monthlyBudget': double.parse(budgetController.text),
      });
    }

    return StreamBuilder(
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
        UserModel userData = UserModel.fromFirebase(snapshot.data!.data()!);
        budgetController.text = userData.monthlyBudget.toString();
        print(userData);
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Settings', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Text('Budget Limit'),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: budgetController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.currency_rupee),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: updateBudget,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              'Save',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline_rounded,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Text('Account Info'),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Name',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: AppColors.text),
                      ),
                      Text(
                        userData.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.subText,
                        ),
                      ),
                      Divider(),
                      const SizedBox(height: 10),
                      Text(
                        'Email',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: AppColors.text),
                      ),
                      Text(
                        userData.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.subText,
                        ),
                      ),
                      Divider(),
                      const SizedBox(height: 10),
                      Text(
                        'Date of Birth',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: AppColors.text),
                      ),
                      Text(
                        userData.dob,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.subText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorBg,
                    foregroundColor: AppColors.errorText,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                    elevation: 0,
                  ),
                  label: Text(
                    'Logout',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.errorText),
                  ),
                  icon: Icon(Icons.logout_outlined, color: AppColors.errorText),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
