import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:occupational_health/components/my_keyboard_hider.dart";
import "package:occupational_health/components/my_submit_button.dart";
import "package:occupational_health/components/my_text_form_field.dart";
import "package:occupational_health/pages/page_view_main.dart";
import "package:intl_phone_field/intl_phone_field.dart";
import "package:occupational_health/services/Assessment/onboard_gate.dart";
import "package:occupational_health/services/Auth/auth_service.dart";

class MfaGate extends StatefulWidget {
  
  const MfaGate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MfaGateState();
}

class _MfaGateState extends State<MfaGate> {
  bool _isVerified = false;// Make these true if you want to test without enrolling
  final AuthService _auth = AuthService();
  bool _signedInWithGoogle = false;

  @override
  void initState() {
    super.initState();
    // Check if user is signed in with Google
    FirebaseAuth.instance.currentUser!.providerData.forEach((e) {
      if (e.providerId == "google.com") {
        setState(() {
          _signedInWithGoogle = true;
        });
      }
    });
  }

  void enrollUser(
      String phoneNumber, TextEditingController otpController) async {
    // Send OTP to phone
    final session =
        await FirebaseAuth.instance.currentUser!.multiFactor.getSession();
    await FirebaseAuth.instance.verifyPhoneNumber(
      multiFactorSession: session,
      phoneNumber: phoneNumber,
      verificationCompleted: (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone number verified")),
        );
      },
      verificationFailed: (e) {
        handleEnrollErrors(e, context);
      },
      codeSent: (String verificationId, int? resendToken) async {
        // The SMS verification code has been sent to the provided phone number.
        // ...
        // Show a prompt to the user to enter the SMS code

        // Bring a dialog to enter the OTP
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => _buildDialogue(
              otpController, verificationId, context, phoneNumber, resendToken),
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  void handleEnrollErrors(FirebaseAuthException e, BuildContext context) {
    if (e.code == "invalid-phone-number") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid phone number")),
      );
    } else if (e.code == "invalid-verification-code") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid verification code")),
      );
    } else if (e.code == "invalid-verification-id") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid verification ID")),
      );
    } else if (e.code == "requires-recent-login") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session expired please login again")),
      );
      FirebaseAuth.instance.signOut();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        e.message != null
            ? SnackBar(content: Text(e.message!))
            : const SnackBar(content: Text("Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyKeyboardHider(
        child: Scaffold(
      body: FutureBuilder(
        future:
            FirebaseAuth.instance.currentUser!.multiFactor.getEnrolledFactors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            if (_isVerified || _signedInWithGoogle) {
              return const OnboardGate();
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              // Need to enroll user
              return _buildMfaEnroller(context);
            }
            else {
              return const OnboardGate();
            }
          }
          return const Center(
            child: Text("Error"),
          );
        },
      ),
    ));
  }

  Widget _buildMfaEnroller(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController otpController = TextEditingController();
    String completePhoneNumber = "";

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 105),

          // Enroll message
          Container(
            alignment: Alignment.centerLeft,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Add\nTwo-Factor Authentication",
                  style: TextStyle(
                      fontSize: 42, fontWeight: FontWeight.w600, height: 1.2),
                ),
                SizedBox(height: 5),
                Text(
                  "Lets add an extra layer of security to your account...",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w100, height: 1.2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 45),

          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                IntlPhoneField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    floatingLabelStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    focusColor: Color(0xFFC7623A),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFC7623A), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  initialCountryCode: "GB",
                  cursorColor: const Color(0xFFC7623A),
                  onChanged: (phone) {
                    completePhoneNumber = phone.completeNumber;
                  },
                ),
                const SizedBox(height: 30),
                MySubmitButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      enrollUser(completePhoneNumber, otpController);
                    }
                  },
                  text: "Continue",
                ),
              ],
            ),
          ),

          // Return to login / register
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.arrow_back, color: Color(0xFFC7623A)),
                Text(
                  "Return to login / register",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC7623A),
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  // Build dialog to enter OTP
  Widget _buildDialogue(
      TextEditingController otpController,
      String verificationId,
      BuildContext context,
      String phoneNumber,
      int? resendToken) {

    return Dialog.fullscreen(
        child: MyKeyboardHider(
            child: Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 105),

            // Enter OTP message
            Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Enter The\nOTP",
                    style: TextStyle(
                        fontSize: 42, fontWeight: FontWeight.w600, height: 1.2),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "We've sent an OTP to your phone... $phoneNumber",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w100, height: 1.2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Form(
              child: Column(
                children: <Widget>[
                  MyTextFormField(
                    controller: otpController,
                    labelText: "OTP",
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the OTP";
                      }
                      if (value.length < 6) {
                        return "Please enter a valid OTP";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Resend OTP
                  GestureDetector(
                    onTap: () async {
                      final session = await FirebaseAuth.instance.currentUser!.multiFactor
                          .getSession();
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        multiFactorSession: session,
                        phoneNumber: phoneNumber,
                        verificationCompleted: (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Phone number verified")),
                          );
                        },
                        verificationFailed: (e) {
                          handleEnrollErrors(e, context);
                        },
                        codeSent: (String verificationId, int? resendToken) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("OTP sent")),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                        timeout: const Duration(seconds: 60),
                        forceResendingToken: resendToken,
                      );
                    },
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFC7623A),
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 25),
                  // Check OTP
                  MySubmitButton(
                    onPressed: () async {
                      // Create a PhoneAuthCredential with the code
                      final credential = PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: otpController.text);

                      // Sign the user in (or link) with the credential
                      try {
                        await FirebaseAuth.instance.currentUser!.multiFactor
                            .enroll(PhoneMultiFactorGenerator.getAssertion(
                                credential));
                        // close the dialog
                        if (mounted) Navigator.pop(context);
                        setState(() {
                          _isVerified = true;
                        });
                      } on FirebaseAuthException catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message!),
                            ),
                          );
                        }
                      }
                    },
                    text: "Continue",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Close dialog / cancel
            MySubmitButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Cancel",
            ),
          ],
        ),
      )),
    )));
  }
}

