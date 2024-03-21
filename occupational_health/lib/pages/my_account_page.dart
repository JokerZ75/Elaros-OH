import "dart:async";

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:occupational_health/components/my_date_picker.dart";
import "package:occupational_health/components/my_keyboard_hider.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/components/my_swipe_back.dart";
import "package:occupational_health/components/my_text_form_field.dart";
import "package:occupational_health/components/my_top_progress_card.dart";
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

class _MyAccountPageState extends State<MyAccountPage> {
  final AuthService _auth = AuthService();
  // Text Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool emailsMatch = true; // True if email in database and auth match

  void signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  bool checked = false;
  final _formKey = GlobalKey<FormState>();

  void sendInfo() async {
    //Get Auth Service

    final authService = Provider.of<AuthService>(context, listen: false);
    DateTime dateOfBirth;
    String date = dateOfBirthController.text.toString();
    String formattedDate = date.substring(0, 10);
    try {
      dateOfBirth = DateTime.parse(formattedDate);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e Please enter a valid date.")));
      return;
    }
    try {
      await authService.updateAccount(
          dateOfBirth, occupationController.text, nameController.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
    await _auth.getUserData().then((user) => {
          setState(() {
            nameController.text = user.name;
            emailController.text = user.email;
            dateOfBirthController.text =
                user.dateOfBirth.toString().substring(0, 10);
            occupationController.text = user.occupation ?? "";
            emailsMatch =
                user.email == FirebaseAuth.instance.currentUser!.email;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _auth.getUserData().then((user) => {
            setState(() {
              nameController.text = user.name;
              emailController.text = user.email;
              dateOfBirthController.text =
                  user.dateOfBirth.toString().substring(0, 10);
              occupationController.text = user.occupation ?? "";
            })
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Account",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w600)),
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
        body: MySwipeBack(
          child: MyKeyboardHider(
              child: SingleChildScrollView(
                  child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Icon(
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
                              dateOfBirthController.text = date
                                  .toString()
                                  .replaceAll("00:00:00.000", "");
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
                            readOnly: true,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              return null;
                            }),

                        emailsMatch
                            ? const SizedBox()
                            : const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  "Emails do not match. Please verify the new email to complete change.",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: MySubmitButton(
                      style:
                          const TextStyle(backgroundColor: Color(0xFFEFD080)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          sendInfo();

                          final snackBar = SnackBar(
                            backgroundColor: const Color(0xFFEFD080),
                            content: const SizedBox(
                              height: 50,
                              child: Text(
                                'Your changes have been saved to your account.',
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
                  const SizedBox(height: 15),
                  // If google sign in is implemented
                  FirebaseAuth.instance.currentUser!.providerData
                          .where(
                              (element) => element.providerId != "google.com")
                          .isNotEmpty
                      ? Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  MyTopProgressCard(
                                          duration: const Duration(seconds: 8),
                                          title: "Sending reset link to email")
                                      .showSnackBar(context);

                                  _auth.resetPassword(emailController.text);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Reset Password",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationThickness: 1.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800]),
                                  ),
                                )),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: () => {
                                // Get new email
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _changeEmailDialog();
                                  },
                                  barrierDismissible: false,
                                ).then((value) => {
                                      // Linear progress indicator in snack bar at top
                                      if (value != null)
                                        {
                                          MyTopProgressCard(
                                                  duration: const Duration(
                                                      seconds: 2),
                                                  title:
                                                      "Changing Email Address")
                                              .showSnackBar(context),

                                          // Delay to get new email
                                          Future.delayed(
                                              const Duration(seconds: 2), () {
                                            _auth.getUserData().then((user) => {
                                                  setState(() {
                                                    emailController.text =
                                                        user.email;
                                                  }),
                                                  // reload user
                                                  FirebaseAuth
                                                      .instance.currentUser!
                                                      .reload(),
                                                  setState(() {
                                                    emailsMatch = user.email ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.email;
                                                  })
                                                });
                                          })
                                        }
                                    })
                              },
                              child: Text(
                                "Change Email Address",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 1.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800]),
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(11),
                              height: MediaQuery.of(context).size.height / 1.5,
                              child: const SingleChildScrollView(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(7),
                                    child: Text(
                                      "Lorem ipsum dolora sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Massa eget egestas purus viverra accumsan in nisl nisi scelerisque. Nunc scelerisque viverra mauris in aliquam sem fringilla ut morbi. Vel eros donec ac odio. Gravida arcu ac tortor dignissim convallis aenean et tortor at. Molestie ac feugiat sed lectus vestibulum mattis ullamcorper velit sed. Volutpat sed cras ornare arcu dui. Mauris augue neque gravida in. Adipiscing bibendum est ultricies integer. Id donec ultrices tincidunt arcu. Augue eget arcu dictum varius duis at. At tellus at urna condimentum mattis pellentesque id nibh. Nam libero justo laoreet sit. Massa enim nec dui nunc mattis enim ut. Nulla at volutpat diam ut venenatis tellus. Eu turpis egestas pretium aenean. \n\nNibh tortor id aliquet lectus proin nibh nisl condimentum id. Nunc mi ipsum faucibus vitae aliquet nec ullamcorper sit amet. Quis hendrerit dolor magna eget est lorem ipsum. Tristique nulla aliquet enim tortor at auctor. Volutpat lacus laoreet non curabitur gravida arcu ac tortor. Volutpat blandit aliquam etiam erat velit. Purus faucibus ornare suspendisse sed nisi. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. \n\nQuisque egestas diam in arcu cursus euismod. Aliquet risus feugiat in ante metus dictum. Massa tincidunt nunc pulvinar sapien et. Natoque penatibus et magnis dis parturient montes nascetur ridiculus. Lectus nulla at volutpat diam ut venenatis tellus in metus. Enim nec dui nunc mattis enim ut. Amet facilisis magna etiam tempor. Tincidunt praesent semper feugiat nibh sed pulvinar proin gravida. Imperdiet proin fermentum leo vel orci porta non. Amet consectetur adipiscing elit pellentesque habitant morbi. Amet purus gravida quis blandit turpis cursus in hac. Iaculis urna id volutpat lacus. \n\nArcu odio ut sem nulla. Eget duis at tellus at urna. Semper eget duis at tellus at. Gravida quis blandit turpis cursus in hac habitasse. Netus et malesuada fames ac turpis egestas integer eget. At risus viverra adipiscing at in tellus integer feugiat. Posuere ac ut consequat semper viverra nam libero. In iaculis nunc sed augue lacus viverra vitae congue. Magna fermentum iaculis eu non diam. Iaculis at erat pellentesque adipiscing commodo elit at imperdiet dui. Sed enim ut sem viverra aliquet eget sit amet. \n\nAccumsan lacus vel facilisis volutpat. At varius vel pharetra vel turpis. At ultrices mi tempus imperdiet nulla malesuada pellentesque. Feugiat nisl pretium fusce id velit. Risus in hendrerit gravida rutrum. Sed felis eget velit aliquet. Turpis egestas integer eget aliquet. Augue ut lectus arcu bibendum at. Lectus magna fringilla urna porttitor. Augue neque gravida in fermentum et. Pulvinar etiam non quam lacus. Consectetur purus ut faucibus pulvinar elementum integer. Egestas diam in arcu cursus. Nulla posuere sollicitudin aliquam ultrices sagittis orci a. Adipiscing tristique risus nec feugiat in fermentum.",
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Text(
                        "Terms and Conditions",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                  ),

                  // Delete Account
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: TextButton(
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser!.providerData
                                .first.providerId ==
                            "google.com") {
                          showGoogleDelete(context);
                        } else {
                          showDeleteAccountDialog(context);
                        }
                      },
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))),
        ));
  }

  Future<dynamic> showGoogleDelete(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Delete Account"),
            content: const Text(
                "Are you sure you want to delete your account? This action cannot be undone."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await _auth.deleteUserWithGoogle(context);
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }

  Future<dynamic> showDeleteAccountDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: SizedBox(
            height: 150,
            child: Column(
              children: <Widget>[
                const Text(
                    "Are you sure you want to delete your account? This action cannot be undone."),

                // password
                MyTextFormField(
                  controller: passwordController,
                  labelText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _auth.deleteUserWithPassword(
                    passwordController.text, context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget _changeEmailDialog() {
    final TextEditingController newEmailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final emailFormKey = GlobalKey<FormState>();

    return AlertDialog(
      title: const Text("Change Email Address"),
      content: Column(children: <Widget>[
        Form(
            key: emailFormKey,
            child: Column(children: [
              MyTextFormField(
                controller: newEmailController,
                labelText: "New Email",
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              MyTextFormField(
                controller: passwordController,
                labelText: "Password",
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              )
            ])),
      ]),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (emailFormKey.currentState!.validate()) {
              try {
                await _auth.changeEmail(
                    newEmailController.text, passwordController.text);
                if (mounted) Navigator.of(context).pop(true);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            }
          },
          child: const Text('Change'),
        ),
      ],
    );
  }
}
