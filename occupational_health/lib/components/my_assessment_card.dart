import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';

class MyAssessmentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? onPressed;

  const MyAssessmentCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: const Color(0xFFEFB84C),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
             Expanded(
                child: ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )),
            MySubmitButton(
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
