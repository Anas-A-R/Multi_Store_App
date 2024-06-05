// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:supplier_multi_store_app/providers/auth_repo.dart';
import 'package:supplier_multi_store_app/widgets/appbar_widgets.dart';
import 'package:supplier_multi_store_app/widgets/auth_wodgets.dart';
import 'package:supplier_multi_store_app/widgets/snack_bar.dart';
import 'package:supplier_multi_store_app/widgets/yellow_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool oldPasswordVisibe = false;
  bool newPasswordVisibe = false;
  bool confirmPasswordVisibe = false;
  bool checkPassword = true;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const AppbarTitle(title: 'Change Password'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    const AppbarTitle(title: 'Change Password'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                          obscureText: oldPasswordVisibe,
                          controller: oldPasswordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your old password.';
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              errorText:
                                  checkPassword ? null : 'not valid password',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      oldPasswordVisibe = !oldPasswordVisibe;
                                    });
                                  },
                                  icon: Icon(
                                    oldPasswordVisibe
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.purple,
                                  )),
                              label: const Text('Old Password'),
                              hintText: 'Enter your old password')),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        obscureText: newPasswordVisibe,
                        controller: newPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your new passowrd.';
                          }
                          return null;
                        },
                        decoration: textFormDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    newPasswordVisibe = !newPasswordVisibe;
                                  });
                                },
                                icon: Icon(
                                  newPasswordVisibe
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.purple,
                                )),
                            label: const Text('New Password'),
                            hintText: 'Enter your New Password'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Confirm your password.';
                          } else if (value != newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        obscureText: confirmPasswordVisibe,
                        decoration: textFormDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    confirmPasswordVisibe =
                                        !confirmPasswordVisibe;
                                  });
                                },
                                icon: Icon(
                                  confirmPasswordVisibe
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.purple,
                                )),
                            label: const Text('Confirm new Password'),
                            hintText: 'Confirm your password'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FlutterPwValidator(
                      controller: newPasswordController,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 2,
                      specialCharCount: 1,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 180,
                      onSuccess: () {},
                      onFail: () {},
                    ),
                    const Spacer(),
                    YellowButton(
                        label: "Apply Changes",
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            print('valid form');
                            checkPassword = await AuthRepo.checkOldPassword(
                                FirebaseAuth.instance.currentUser!.email,
                                oldPasswordController.text);
                            setState(() {});
                            checkPassword
                                ? await AuthRepo.updateUserPassword(
                                        newPasswordController.text.trim())
                                    .whenComplete(() {
                                    _formkey.currentState!.reset();
                                    newPasswordController.clear();
                                    oldPasswordController.clear();
                                    confirmPasswordController.clear();
                                    MyMessageHandler.showSnackBar(
                                        _scaffoldMessengerKey,
                                        'Password has been updated successfully');
                                    Future.delayed(const Duration(seconds: 3))
                                        .whenComplete(
                                            () => Navigator.pop(context));
                                  })
                                : print('invalid old password');
                          } else {
                            print('invalid form');
                          }
                        },
                        widthInPercent: 1)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
