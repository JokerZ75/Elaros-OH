import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';

class VerifyPage extends StatefulWidget {

  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VerifyPageState();
} // VerifyPage

class _VerifyPageState extends State<VerifyPage> {
  final AuthService _auth = AuthService();

  // Send email while initializing
  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerification();

    WidgetsBinding.instance.addObserver(
      AppLifecycleListener(
        onResume: () {
          FirebaseAuth.instance.currentUser!.reload();

          // perodic reload
          Timer.periodic(const Duration(seconds: 5), (timer) {
            FirebaseAuth.instance.currentUser!.reload();

            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              timer.cancel();
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 145),
                // Welcome back
                Container(
                  alignment: Alignment.centerLeft,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Check\nEmail",
                        style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                            height: 1.2),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "We've sent an email to ${FirebaseAuth.instance.currentUser!.email}...",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w100,
                            height: 1.2),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 90),
          
                // Resend verification email
                MySubmitButton(
                    onPressed: () {
                      _auth.sendEmailVerification();
                    },
                    text: "Resend Verification Email"),
          
                const SizedBox(height: 25),
          
                // login button
                MySubmitButton(
                    onPressed: () {
                      _auth.deleteUser();
                    },
                    text: "Cancel Account Creation"),
              ],
            ),
          )),
        );
  }
}
