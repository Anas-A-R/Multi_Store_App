// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_store_app/auth/forgot_password.dart';
import 'package:multi_store_app/minor_screens/product_detail.dart';
import 'package:multi_store_app/providers/auth_repo.dart';
import 'package:multi_store_app/widgets/auth_wodgets.dart';
import 'package:multi_store_app/widgets/snack_bar.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({super.key});

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late String email;
  late String password;
  bool paswordVisibe = false;
  bool processing = false;
  bool sendEmailVerification = false;
  bool docExists = false;

  Future<bool> checkExistanceOfDoc(String docId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(docId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance.currentUser!;
      docExists = await checkExistanceOfDoc(user.uid);
      docExists == false //if user does not exist then create a collection
          ? await FirebaseFirestore.instance
              .collection('customers')
              .doc(user.uid)
              .set({
              'name': user.displayName,
              'email': user.email,
              'profile_image': user.photoURL,
              'address': '',
              'phone': '',
              'cid': user.uid,
              'password': '',
            }).then((value) =>
                  Navigator.pushReplacementNamed(context, '/customer_home'))
          : Navigator.pushReplacementNamed(context,
              '/customer_home'); //if user exist then directly move to home screen without creating collection
    });
  }

  void logIn() async {
    setState(() {
      processing = true;
    });
    if (_formkey.currentState!.validate()) {
      try {
        await AuthRepo.signInWithEmailAndPassword(email, password);
        await AuthRepo.reloadUserData();
        if (await AuthRepo.checkEmailVerification() == true) {
          Navigator.pushReplacementNamed(context, '/customer_home');
          _formkey.currentState!.reset(); //reset all fields
        } else {
          MyMessageHandler.showSnackBar(_scaffoldMessengerKey,
              'Please verify your email and check your inbox first');
          setState(() {
            processing = false;
            sendEmailVerification = true;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(
            _scaffoldMessengerKey, e.message.toString());
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(
          _scaffoldMessengerKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
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
                    children: [
                      const AuthHeaderLabel(
                        label: 'Login',
                      ),
                      sendEmailVerification
                          ? SizedBox(
                              height: 50,
                              child: YellowButton(
                                  label: "Resend email verification",
                                  onPressed: () async {
                                    await FirebaseAuth.instance.currentUser!
                                        .sendEmailVerification();
                                    setState(() {
                                      sendEmailVerification = false;
                                    });
                                  },
                                  widthInPercent: 0.5),
                            )
                          : const SizedBox(
                              height: 50,
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
                            } else if (value.isValidateEmail() == false) {
                              return 'Invalid email';
                            } else if (value.isValidateEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          decoration: textFormDecoration.copyWith(
                              label: const Text('Email'),
                              hintText: 'Enter your email'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            password = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password.';
                            }
                            return null;
                          },
                          obscureText: paswordVisibe,
                          decoration: textFormDecoration.copyWith(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      paswordVisibe = !paswordVisibe;
                                    });
                                  },
                                  icon: Icon(
                                    paswordVisibe
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.purple,
                                  )),
                              label: const Text('Password'),
                              hintText: 'Enter your password'),
                        ),
                      ),
                      HaveAccount(
                        actionLabel: 'Forgot Password ? ',
                        onpressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const ForgotPasswordScreen();
                            },
                          ));
                        },
                        haveAccount: '',
                      ),
                      HaveAccount(
                        actionLabel: 'SignUp',
                        onpressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_signup');
                        },
                        haveAccount: 'Don\'t have an account?',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      processing
                          ? const CircularProgressIndicator()
                          : AuthMainButton(
                              mainButtonLabel: 'Log In',
                              onPressed: logIn,
                            ),
                      const ProductDetailHeader(
                        label: 'OR',
                      ),
                      AuthMainButton(
                        buttonColor: Colors.red,
                        mainButtonLabel: 'Sign In with Google',
                        onPressed: () {
                          signInWithGoogle();
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
  bool isValidateEmail() {
    return RegExp(
            r'^([a-zA-Z0-9])([\-\_\.]*)([a-zA-Z0-9]*)([@])([a-zA-Z0-9]{2,})([\.][a-zA-Z]{2,3})$')
        ///////(anas       )(optional )(razaq850    )(@  )(gmail          )(.   com          )
        .hasMatch(this);
  }
}
