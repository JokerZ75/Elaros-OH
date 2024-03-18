// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_text_form_field.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
} // LoginPage

class _LoginPageState extends State<LoginPage> {
  // Text Controllers
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void login() async {
    // Get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          EmailController.text, PasswordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              // Welcome back
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      "Welcome\nBack",
                      style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w600,
                          height: 1.2),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "We've missed you\nsign in now to\ncontinue...",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w100,
                          height: 1.2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // email
                    MyTextFormField(
                        controller: EmailController,
                        labelText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }),

                    const SizedBox(height: 15),

                    // password
                    MyTextFormField(
                        controller: PasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        labelText: "Password",
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        }),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Reset Password")));
                    },
                    child: Text(
                      "Click Here",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFC7623A),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 160,
                child: Center(
                  child: Text("Google Sign In Apple Sign In"),
                ),
              ),

              // register button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFC7623A),
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),

              const SizedBox(height: 25),

              // login button
              MySubmitButton(
                style: TextStyle (backgroundColor: const Color(0xFFEFD080)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                  text: "Sign In"),
            ],
          ),
        )));
  } // Widget
} // _LoginPageState

