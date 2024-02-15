// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const MySubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // Style
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Color(0xFFEFD080)
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(12),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 22, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
