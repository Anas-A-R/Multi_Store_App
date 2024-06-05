// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/providers/auth_repo.dart';
import 'package:customer_multi_store_app/widgets/appbar_widgets.dart';
import 'package:customer_multi_store_app/widgets/auth_wodgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late String email;
  bool processing = false;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const AppbarTitle(title: 'Forgot Password'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const AuthHeaderLabel(
                        label: 'Forgot Password',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email.';
                            } else if (value.validateEmail() == false) {
                              return 'Invalid email';
                            } else if (value.validateEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              label: const Text('Email'),
                              hintText: 'Enter your email'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      processing
                          ? const CircularProgressIndicator()
                          : AuthMainButton(
                              mainButtonLabel: 'Send reset password link',
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  AuthRepo.sendPasswordResetEmail(email);
                                  Navigator.pop(context);
                                } else {}
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool validateEmail() {
    return RegExp(
            r'^([a-zA-Z0-9])([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        ///////(anas       )(optional )(razaq850    )(@  )(gmail          )(.   com          )
        .hasMatch(this);
  }
}
