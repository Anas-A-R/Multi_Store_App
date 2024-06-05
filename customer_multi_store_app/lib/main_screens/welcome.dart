// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:customer_multi_store_app/widgets/yellow_button.dart';

List<Color> textColors = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal
];

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  bool processing = false;

  late AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/inapp/bgimage.jpg'),
                  fit: BoxFit.cover)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedTextKit(
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'WELCOME',
                      textStyle: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme'),
                      colors: textColors,
                    ),
                    ColorizeAnimatedText(
                      'DUCK Store',
                      textStyle: const TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Acme'),
                      colors: textColors,
                    )
                  ],
                ),
                const SizedBox(
                  height: 120,
                  width: 200,
                  child: Image(image: AssetImage('images/inapp/logo.jpg')),
                ),
                SizedBox(
                  height: 80,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                        fontFamily: 'Acme'),
                    child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                      RotateAnimatedText('Buy'),
                      RotateAnimatedText('Shop'),
                      RotateAnimatedText('Duck Store'),
                    ]),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30))),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Supplier Only',
                              style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: const BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30))),
                          child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedLogo(controller: _controller),
                                  YellowButton(
                                      label: 'Log In',
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/supplier_login');
                                      },
                                      widthInPercent: 0.25),
                                  YellowButton(
                                      label: 'Sign Up',
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/supplier_signup');
                                      },
                                      widthInPercent: 0.25),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AnimatedLogo(controller: _controller),
                              YellowButton(
                                  label: 'Log In',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/customer_login');
                                  },
                                  widthInPercent: 0.25),
                              YellowButton(
                                  label: 'Sign Up',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/customer_signup');
                                  },
                                  widthInPercent: 0.25),
                            ],
                          )),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white38,
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GoogleFacebookLogin(
                            label: 'Google',
                            onPressed: () {},
                            child: const Image(
                                image: AssetImage('images/inapp/google.jpg')),
                          ),
                          GoogleFacebookLogin(
                            label: 'Facebook',
                            onPressed: () {},
                            child: const Image(
                                image: AssetImage('images/inapp/facebook.jpg')),
                          ),
                          processing
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : GoogleFacebookLogin(
                                  label: 'Guest',
                                  onPressed: () async {
                                    setState(() {
                                      processing = true;
                                    });
                                    await FirebaseAuth.instance
                                        .signInAnonymously()
                                        .whenComplete(() async {
                                      await FirebaseFirestore.instance
                                          .collection('anonymous_users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .set({
                                        'name': '',
                                        'email': '',
                                        'profile_image': '',
                                        'address': '',
                                        'phone': '',
                                        'uid': FirebaseAuth
                                            .instance.currentUser!.uid,
                                        'password': '',
                                      });
                                    });
                                    Navigator.pushReplacementNamed(
                                        context, '/customer_home');
                                  },
                                  child: const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.lightBlueAccent,
                                  )),
                        ],
                      )),
                ),
              ],
            ),
          )),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  final AnimationController _controller;
  const AnimatedLogo({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: const Image(
            image: AssetImage('images/inapp/logo.jpg'),
          ),
        );
      },
    );
  }
}

class GoogleFacebookLogin extends StatelessWidget {
  final String label;
  final Widget child;
  final VoidCallback onPressed;
  const GoogleFacebookLogin({
    super.key,
    required this.label,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(
            height: 45,
            child: child,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
