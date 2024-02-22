import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/pages/home_page.dart';
import 'package:occupational_health/pages/page_view_main.dart';
import 'package:occupational_health/services/Auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // logged in
          if (snapshot.hasData) {
            return const ListViewMain();
          }

          // user not logged in
          else {
            return const LoginOrRegister();
          }
        }
      )
    );
  }
}


