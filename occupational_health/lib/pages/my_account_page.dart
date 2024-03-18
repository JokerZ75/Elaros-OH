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
                    style: TextStyle (backgroundColor: const Color(0xFFEFD080)),
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
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: SingleChildScrollView(
                              child: const Center(
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
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
