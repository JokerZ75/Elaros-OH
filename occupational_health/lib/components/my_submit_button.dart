// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MySubmitButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final int? minWidth;
  final Icon? icon;
  final int? lineHeight;
  final int? textSize;
  final FontWeight? fontWeight;
  final TextStyle? style;
  const MySubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.minWidth = 200,
    this.icon,
    this.lineHeight = 23,
    this.textSize = 22,
    this.fontWeight = FontWeight.w500,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      // Style
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFEFD080)),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(12),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(minWidth!.toDouble(), 50),
        ),
      ),
      child: Center(
          child: Column(
        children: <Widget>[
          if (icon != null) icon!,
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: textSize!.toDouble(), color: Colors.black, fontWeight: fontWeight, height: lineHeight!.toDouble() / 20,)
          ),
        ],
      )),
    );
  }
}
