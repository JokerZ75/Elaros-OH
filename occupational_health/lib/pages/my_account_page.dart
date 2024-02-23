import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:occupational_health/components/my_date_picker.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/components/my_text_form_field.dart";
import "package:occupational_health/services/Auth/auth_service.dart";
import 'package:provider/provider.dart';

String name = "";
String dateOfBirth = "";
String? occupation = "";
String email = "";
String password = "";
String confirm = "";




class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAccountPageState();
}

// Text Controllers
 final TextEditingController nameController = TextEditingController();
 final TextEditingController emailController = TextEditingController();
 final TextEditingController dateOfBirthController = TextEditingController();
 final TextEditingController occupationController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();
 final TextEditingController confirmPasswordController = TextEditingController();
 final TextEditingController _reloadController = TextEditingController();

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

  bool checked = false;
  final _formKey = GlobalKey<FormState>();

  void sendInfo() async {
    if (!checked) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please send")));
    }

    //Get Auth Service

    final authService = Provider.of<AuthService>(context, listen: false);
    DateTime dateOfBirth;
    String date = dateOfBirthController.text.toString();
    String formattedDate = date.substring(0, 20);
    try {
      dateOfBirth = DateTime.parse(formattedDate);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e Please enter a valid date.")));
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(dateOfBirth.toString())));
    try {
      await authService.updateAccount(
          emailController.text,
          passwordController.text,
          dateOfBirth,
          occupationController.text,
          nameController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      AuthService _auth = AuthService();
      _auth.getUserData().then((user) => {
        nameController.text = user.name,
        emailController.text = user.email,
        dateOfBirthController.text = user.dateOfBirth.toString().substring(0,10),
        occupationController.text = user.occupation ?? ""
      });
    });
  }

  //reload
//   void reload() async {
//     int s = int.parse(_reloadController.text); // define this hear
//     await FirebaseFirestore.instance
//         .collection("users")
//         .doc(widget.)
//         .update({"":  + s});

//     setState(() {});
// }

  // void setControllers() async {

  // }

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
                const SizedBox(height: 50),
                Icon(
                  Icons.account_circle_rounded,
                  size: 200,
                ),
                const SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
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
                          labelText: "Occupation",
                          keyboardType: TextInputType.text,
                          obscureText: false,
                          validator: (value) {
                            if (value != occupationController.text) {
                              return '';
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
                              return "Please enter your email";
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
                              return null;
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
                              return "Passwords do not match.";
                            }
                            return null;
                          }),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MySubmitButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final snackBar = SnackBar(
                          backgroundColor: const Color(0xFFEFD080),
                          content: Container(
                            height: 50,
                            child: const Text(
                              'An email has been sent to confirm your changes.',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          action: SnackBarAction(
                            textColor: Colors.black,
                            label: 'Close',
                            onPressed: () {},
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    text: "Change Information",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
