import  'package:flutter/material.dart';
import 'package:occupational_health/pages/login_page.dart';
import 'package:occupational_health/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginOrRegisterState();
} // LoginOrRegister

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;

  void toggleView() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLoginPage ? LoginPage(onTap: toggleView) : RegisterPage(onTap: toggleView);
  }
}