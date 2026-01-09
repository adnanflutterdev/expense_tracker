import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/helper/show_snackbars.dart';
import 'package:expense_tracker/models/user.dart';
import 'package:expense_tracker/screens/widgets/logo.dart';
import 'package:expense_tracker/screens/widgets/title.dart';
import 'package:expense_tracker/utils/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ValueNotifier<bool> isObscure = ValueNotifier(true);
  ValueNotifier<bool> isSigninPage = ValueNotifier(true);
  ValueNotifier<bool> isSigningin = ValueNotifier(false);

  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void authenticate({required bool isSignin}) async {
    bool isValid = formKey.currentState!.validate();

    if (isValid) {
      isSigningin.value = true;
      if (isSignin) {
        // print('On Login Screen');

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(),
            password: pass.text.trim(),
          );
          if (!mounted) {
            return;
          }
          displaySnackBar(
            context: context,
            isSuccess: true,
            message: 'Loggedin Successfully...',
          );
        } on FirebaseAuthException catch (err) {
          displaySnackBar(
            context: context,
            isSuccess: true,
            message: err.message ?? 'Unknown error occured...',
          );
        }
      } else {
        // print('On Signup Screen');

        try {
          final result = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: email.text.trim(),
                password: pass.text.trim(),
              );

          if (result.user != null) {
            UserModel user = UserModel(
              id: result.user!.uid,
              name: name.text.trim(),
              email: email.text.trim(),
              dob: dob.text,
              monthlyBudget: 0.0,
              spent: 0.0
            );

            await FirebaseFirestore.instance
                .collection('user')
                .doc(user.id)
                .set(user.toMap());
          }

          if (!mounted) {
            return;
          }
          displaySnackBar(
            context: context,
            isSuccess: true,
            message: 'Account Created Successfully...',
          );
        } on FirebaseAuthException catch (err) {
          displaySnackBar(
            context: context,
            isSuccess: true,
            message: err.message ?? 'Unknown error occured...',
          );
        }
      }
      isSigningin.value = false;
    }
  }

  void openDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(2010),
    );

    if (pickedDate != null) {
      print(pickedDate);

      dob.text = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              logo(context: context),
              SizedBox(height: 30),
              Text(
                'Welcome to',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              title(context: context),
              SizedBox(height: 10),
              Text(
                'Track Your Spending Smartly',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedText),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: isSigninPage,
                          builder: (context, isSignin, child) {
                            if (isSignin) {
                              return SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                TextFormField(
                                  controller: name,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    hintText: 'Full Name',
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

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter your name';
                                    } else if (value.trim().length < 3) {
                                      return 'Enter valid name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                TextFormField(
                                  controller: dob,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    hintText: 'Enter your dob',
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

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Enter DOB';
                                    }
                                    return null;
                                  },

                                  onTap: () {
                                    openDatePicker();
                                  },
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        TextFormField(
                          controller: email,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email_outlined),
                            hintText: 'name@example.com',
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

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Enter email';
                            } else if (!value.trim().contains('@') ||
                                !value.trim().endsWith('.com')) {
                              return 'Enter valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: isObscure,
                          builder: (context, isVisible, child) {
                            return TextFormField(
                              controller: pass,
                              obscureText: isVisible,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock_outline),
                                suffixIcon: ValueListenableBuilder(
                                  valueListenable: isObscure,
                                  builder: (context, isVisible, child) {
                                    return IconButton(
                                      onPressed: () {
                                        isObscure.value = !isVisible;
                                      },
                                      icon: Icon(
                                        isVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    );
                                  },
                                ),
                                hintText: '*******',
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
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter Password';
                                } else if (value.trim().length < 6) {
                                  return 'Password length must me greater than 6';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: width - 70,
                            height: 50,
                            child: ValueListenableBuilder(
                              valueListenable: isSigninPage,
                              builder: (context, isSignin, child) {
                                return ElevatedButton(
                                  onPressed: () =>
                                      authenticate(isSignin: isSignin),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(12),
                                    ),
                                  ),
                                  child: ValueListenableBuilder(
                                    valueListenable: isSigningin,
                                    builder: (context, value, child) {
                                      if (value) {
                                        return SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                      return Text(
                                        isSignin ? 'Sign In' : 'Sign up',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              isSigninPage.value = !isSigninPage.value;
                            },
                            child: ValueListenableBuilder(
                              valueListenable: isSigninPage,
                              builder: (context, isSignin, child) {
                                return Text(
                                  isSignin
                                      ? 'New here? Create Account'
                                      : 'Already have an account? Sign in',
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Text('  OR  '),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: width - 40,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  label: Text('Continue as Guest'),
                  icon: Icon(Icons.person_outline, size: 30),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
