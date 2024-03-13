import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_date_picker.dart';
import 'package:occupational_health/components/my_keyboard_hider.dart';
// ignore_for_file: prefer_const_constructors
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_text_form_field.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
} // LoginPage

class _RegisterPageState extends State<RegisterPage> {
  // Text Controllers
  final nameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final occupationController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool checked = false;
  final _formKey = GlobalKey<FormState>();

  void signUp() async {
    if (!checked) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please agree to the terms and conditions")));
      return;
    }

    // Get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    DateTime dateOfBirth;
    String date = dateOfBirthController.text.toString();
    String formattedDate = date.substring(0, 10);
    try {
      dateOfBirth = DateTime.parse(formattedDate);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e Please enter a valid date")));
      return;
    }
    try {
      // Show load spinner dialog while waiting
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          barrierDismissible: false);
      await authService.registerWithEmailAndPassword(
        emailController.text,
        passwordController.text,
        dateOfBirth,
        occupationController.text,
        nameController.text,
      );
      if (mounted) Navigator.pop(context);
    } // catch firebase auth weak password
    catch (e) {
      if (mounted) {
        Navigator.pop(context);
        if (e.toString().contains("weak-password")) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Password is too weak")));
        } else if (e.toString().contains("email-already-in-use")) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Email cannot be used, try another")));
        } else if (e.toString().contains("invalid-email")) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please enter a valid email")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyKeyboardHider(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
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
                          "Welcome",
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w600,
                              height: 1.2),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Sign up now and better\ntrack your health...",
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
                            controller: nameController,
                            labelText: "Name",
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            }),

                        const SizedBox(height: 15),

                        // DOB
                        MyDatePicker(
                            controller: dateOfBirthController,
                            label: "Date of Birth",
                            onDateSelected: (DateTime date) {
                              dateOfBirthController.text = date
                                  .toString()
                                  .replaceAll("00:00:00.000", "");
                            }),

                        const SizedBox(height: 15),

                        MyTextFormField(
                            controller: occupationController,
                            labelText: "Occupation (Optional)",
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            validator: (value) {
                              return null;
                            }),

                        const SizedBox(height: 15),

                        // email
                        MyTextFormField(
                            controller: emailController,
                            labelText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              // check if email is valid
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            }),

                        const SizedBox(height: 15),

                        // password
                        MyTextFormField(
                            controller: passwordController,
                            labelText: "Password",
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }

                              return null;
                            }),

                        const SizedBox(height: 15),

                        // confirm password
                        MyTextFormField(
                            controller: confirmPasswordController,
                            labelText: "Confirm Password",
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            }),

                        const SizedBox(height: 5),

                        // terms and conditions
                        Row(
                          children: <Widget>[
                            Checkbox(
                              value: checked,
                              onChanged: (value) {
                                setState(() {
                                  checked = value!;
                                });
                              },
                              activeColor: Color(0xFFEFD080),
                              checkColor: Colors.black,
                            ),
                            const Text(
                              "I agree to the terms and conditions",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // register button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Have an account?",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w100),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFC7623A),
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // login button
                  MySubmitButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      text: "Sign Up"),
                ],
              ),
            ))));
  } // Widget
} // _RegisterPageState