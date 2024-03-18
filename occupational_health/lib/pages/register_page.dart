import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:occupational_health/components/my_date_picker.dart';
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
      await authService.registerWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          dateOfBirth,
          occupationController.text,
          nameController.text);
    } catch (e) {
      // ignore: use_build_context_synchronously
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
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
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
                          dateOfBirthController.text =
                              date.toString().replaceAll("00:00:00.000", "");
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
                        Text(
                          "I agree to the ",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w100),
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: const EdgeInsets.all(8),
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: SingleChildScrollView(
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(7),
                                        child: Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Massa eget egestas purus viverra accumsan in nisl nisi scelerisque. Nunc scelerisque viverra mauris in aliquam sem fringilla ut morbi. Vel eros donec ac odio. Gravida arcu ac tortor dignissim convallis aenean et tortor at. Molestie ac feugiat sed lectus vestibulum mattis ullamcorper velit sed. Volutpat sed cras ornare arcu dui. Mauris augue neque gravida in. Adipiscing bibendum est ultricies integer. Id donec ultrices tincidunt arcu. Augue eget arcu dictum varius duis at. At tellus at urna condimentum mattis pellentesque id nibh. Nam libero justo laoreet sit. Massa enim nec dui nunc mattis enim ut. Nulla at volutpat diam ut venenatis tellus. Eu turpis egestas pretium aenean. \n\nNibh tortor id aliquet lectus proin nibh nisl condimentum id. Nunc mi ipsum faucibus vitae aliquet nec ullamcorper sit amet. Quis hendrerit dolor magna eget est lorem ipsum. Tristique nulla aliquet enim tortor at auctor. Volutpat lacus laoreet non curabitur gravida arcu ac tortor. Volutpat blandit aliquam etiam erat velit. Purus faucibus ornare suspendisse sed nisi. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. \n\nQuisque egestas diam in arcu cursus euismod. Aliquet risus feugiat in ante metus dictum. Massa tincidunt nunc pulvinar sapien et. Natoque penatibus et magnis dis parturient montes nascetur ridiculus. Lectus nulla at volutpat diam ut venenatis tellus in metus. Enim nec dui nunc mattis enim ut. Amet facilisis magna etiam tempor. Tincidunt praesent semper feugiat nibh sed pulvinar proin gravida. Imperdiet proin fermentum leo vel orci porta non. Amet consectetur adipiscing elit pellentesque habitant morbi. Amet purus gravida quis blandit turpis cursus in hac. Iaculis urna id volutpat lacus. \n\nArcu odio ut sem nulla. Eget duis at tellus at urna. Semper eget duis at tellus at. Gravida quis blandit turpis cursus in hac habitasse. Netus et malesuada fames ac turpis egestas integer eget. At risus viverra adipiscing at in tellus integer feugiat. Posuere ac ut consequat semper viverra nam libero. In iaculis nunc sed augue lacus viverra vitae congue. Magna fermentum iaculis eu non diam. Iaculis at erat pellentesque adipiscing commodo elit at imperdiet dui. Sed enim ut sem viverra aliquet eget sit amet. \n\nAccumsan lacus vel facilisis volutpat. At varius vel pharetra vel turpis. At ultrices mi tempus imperdiet nulla malesuada pellentesque. Feugiat nisl pretium fusce id velit. Risus in hendrerit gravida rutrum. Sed felis eget velit aliquet. Turpis egestas integer eget aliquet. Augue ut lectus arcu bibendum at. Lectus magna fringilla urna porttitor. Augue neque gravida in fermentum et. Pulvinar etiam non quam lacus. Consectetur purus ut faucibus pulvinar elementum integer. Egestas diam in arcu cursus. Nulla posuere sollicitudin aliquam ultrices sagittis orci a. Adipiscing tristique risus nec feugiat in fermentum.",
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text(
                            "terms and conditions",
                            style: TextStyle(decoration: TextDecoration.underline, decorationThickness: 0.7,
                                fontSize: 12, fontWeight: FontWeight.w100),
                          ),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100),
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
                  style: TextStyle(backgroundColor: const Color(0xFFEFD080)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signUp();
                    }
                  },
                  text: "Sign Up"),
            ],
          ),
        )));
  } // Widget
} // _RegisterPageState