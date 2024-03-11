import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/pages/page_view_main.dart';
import 'package:occupational_health/pages/verify_page.dart';
import 'package:occupational_health/services/Auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);



  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {

          // logged in
          if (snapshot.hasData) {
            // check if user is verified
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              return const ListViewMain();
            }
            else {
              return  VerifyPage(
              );
            }
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


