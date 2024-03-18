import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';

class MyRehabCard extends StatelessWidget {
  final String title;
  final void Function()? onPressed;

  const MyRehabCard({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color(0xFFEFB84C),
      child: Padding(
        padding: const EdgeInsets.all(8.0),   
          child: Row(
            children: <Widget>[

              // Title / Name
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(
                flex: 1,
              ),
              // Button linking for more info'
              MySubmitButton(
                style: TextStyle (backgroundColor: const Color(0xFFEFD080)),
                onPressed: onPressed,
                minWidth: 115,
                text: "More info",
                lineHeight: 20,
                textSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      );
  }
}
