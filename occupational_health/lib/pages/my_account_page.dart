// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import "package:flutter/material.dart";
import "package:occupational_health/components/my_date_picker.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/components/my_text_form_field.dart";
import "package:occupational_health/services/Auth/auth_service.dart";
//import "package:occupational_health/components/my_text_form_field.dart";

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  void signOut() async {
    final AuthService authService = AuthService();
    try {
      await authService.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Text Controllers
  final nameController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final occupationController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: const Color(0xFFEFB84C),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                signOut();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: 200,
                ),
                const SizedBox(height: 15),
                //name
                MyTextFormField(
                    controller: nameController,
                    labelText: "Name",
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some information';
                      }
                      return null;
                    }),

                const SizedBox(height: 25),
                //DOB
                MyDatePicker(
                    controller: dateOfBirthController,
                    label: "Date of Birth",
                    onDateSelected: (DateTime date) {
                      dateOfBirthController.text =
                          date.toString().replaceAll("00:00:00.000", "");
                    }),

                const SizedBox(height: 25),
                //occupation
                MyTextFormField(
                    controller: occupationController,
                    labelText: "Occupation (Optional)",
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    validator: (value) {
                      if (value != occupationController.text) {
                        return 'Please enter your occupation';
                      }
                      return null;
                    }),

                const SizedBox(height: 25),

                //email
                MyTextFormField(
                    controller: emailController,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    }),

                const SizedBox(height: 25),

                //password
                MyTextFormField(
                    controller: passwordController,
                    labelText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    }),

                const SizedBox(height: 25),

                //confirm password

                MyTextFormField(
                    controller: confirmPasswordController,
                    labelText: "Confirm Password",
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Passwords do not match. Try again.";
                      }
                      return null;
                    }),
                
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(8),
                    child: Expanded(
                        child: MySubmitButton(
                      onPressed: () {},
                      minWidth: 10,
                      textSize: 16,
                      text: "Change Information",
                    ))),

                // ElevatedButton(
                //   onPressed: (){
                //     print ('An email has been sent to confirm your changes...');
                //   },
                //   child: Text("Change Information"),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
