import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Future<SharedPreferences> _perf = SharedPreferences.getInstance();
  String supplierId = '';
  Timer? countdownTimer;
  int seconds = 5;

  @override
  void initState() {
    startTimer();
    _perf
        .then((SharedPreferences sharedPreferences) =>
            sharedPreferences.getString('supplierid') ?? '')
        .then(
          (value) => setState(() {
            supplierId = value;
          }),
        );
    super.initState();
  }

  startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds < 1) {
        stopTimer();
        supplierId != ''
            ? Navigator.pushReplacementNamed(context, '/supplier_home')
            : Navigator.pushReplacementNamed(context, '/supplier_login');
      }
    });
  }

  stopTimer() {
    countdownTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'images/onboard/supplier_onboard.jpg',
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 30,
          right: 30,
          child: GestureDetector(
            onTap: () {
              stopTimer();
              supplierId != ''
                  ? Navigator.pushReplacementNamed(context, '/supplier_home')
                  : Navigator.pushReplacementNamed(context, '/supplier_login');
            },
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20)),
              child: seconds < 1
                  ? const Text(
                      'Skip',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    )
                  : Text(
                      'Skip | $seconds',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                    ),
            ),
          ),
        ),
      ]),
    ));
  }
}
