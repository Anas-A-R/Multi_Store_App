import 'package:flutter/material.dart';

class AppbarBackButton extends StatelessWidget {
  const AppbarBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios_new));
  }
}

class AppbarTitle extends StatelessWidget {
  final String title;
  const AppbarTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Acme',
            fontSize: 24,
            letterSpacing: 1.5));
  }
}