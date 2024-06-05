import 'package:flutter/material.dart';

class AuthMainButton extends StatelessWidget {
  final String mainButtonLabel;
  final VoidCallback onPressed;
  final Color? buttonColor;
  const AuthMainButton({
    super.key,
    required this.mainButtonLabel,
    required this.onPressed,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: buttonColor ?? Colors.purple,
      borderRadius: BorderRadius.circular(20),
      child: MaterialButton(
        minWidth: double.infinity,
        height: 50,
        onPressed: onPressed,
        child: Text(
          mainButtonLabel,
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String actionLabel;
  final VoidCallback onpressed;
  final String haveAccount;
  const HaveAccount({
    super.key,
    required this.actionLabel,
    required this.onpressed,
    required this.haveAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveAccount,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        TextButton(
          onPressed: onpressed,
          child: Text(
            actionLabel,
            style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.normal,
                color: Colors.purple,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String label;
  const AuthHeaderLabel({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/welcome_screen');
            },
            icon: const Icon(
              Icons.home_work,
              color: Colors.black,
              size: 40,
            ))
      ],
    );
  }
}

var textFormDecoration = InputDecoration(
    label: const Text('Full name'),
    hintText: 'Enter your full name',
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.purple, width: 1),
        borderRadius: BorderRadius.circular(25)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
        borderRadius: BorderRadius.circular(25)));
