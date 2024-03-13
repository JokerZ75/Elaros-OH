import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/pages/verify_page.dart';
import 'package:occupational_health/services/Auth/login_or_register.dart';
import 'package:occupational_health/services/Auth/mfa_gate.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              // logged in
              if (snapshot.hasData) {

                // check if user is verified
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  // check if user is enrolled to MFA
                  return const MfaGate();
                } else {
                  return const VerifyPage();
                }
              }
              // user not logged in
              else {
                return const LoginOrRegister();
              }
            }));
  }
}
