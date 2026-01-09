import 'package:expense_tracker/screens/auth_screen.dart';

import 'package:expense_tracker/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        inputDecorationTheme: InputDecorationThemeData(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        // Heading Text
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            color: AppColors.text,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),

          titleLarge: TextStyle(
            color: AppColors.text,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleSmall: TextStyle(
            color: AppColors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),

          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.text,
          ),
        ),

        //
      ),

      home: const AuthScreen(),
    );
  }
}
