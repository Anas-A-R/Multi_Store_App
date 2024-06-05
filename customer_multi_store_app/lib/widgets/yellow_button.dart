import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double widthInPercent;
  final Color? color;
  final Color? titleColor;
  const YellowButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.widthInPercent,
    this.color,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color ?? Colors.yellow),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * widthInPercent,
        height: 45,
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(fontSize: 18, color: titleColor ?? Colors.black),
        ),
      ),
    );
  }
}
