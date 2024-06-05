import 'package:flutter/material.dart';

class MyMessageHandler {
  static void showSnackBar(var scaffoldMessengerKey, var message) {
    scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState!.showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.yellow,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        )));
  }
}
