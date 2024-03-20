import "package:flutter/material.dart";

class MyTopProgressCard {
  final Duration duration;
  double? distanceFromTop;
  final String title;

  MyTopProgressCard({
    required this.duration,
    this.distanceFromTop = 200,
    required this.title,
  });

  // Snack bar to show the progress on top of the screen
  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Column(children: [
        const LinearProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEFD080)),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ]),
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.all(15),
      backgroundColor: const Color(0xFFEFB84C),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - distanceFromTop!,
          left: 10,
          right: 10),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: "Close",
        textColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ));
  }
}
