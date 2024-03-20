import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:occupational_health/components/my_keyboard_hider.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_text_form_field.dart';
import 'package:occupational_health/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier {
  // instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // instance for the firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in with email and password
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // create a new document for the user with the uid
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'uid': userCredential.user!.uid,
      }, SetOptions(merge: true));

      

      return;
    } on FirebaseAuthMultiFactorException catch (e) {
      // Multi-factor challenge
      final firstHint = e.resolver.hints.first;
      if (firstHint is! PhoneMultiFactorInfo) {
        return;
      }

      if (context.mounted) {
        await _verifyPhoneNumber(firstHint!.phoneNumber, context, e);

      }

      return;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e);
    }
  }

  // Change Email
  Future<void> changeEmail(String newEmail, String password) async {
    try {
      final User user = _auth.currentUser!;
      final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email ?? "", password: password);
      await user.reauthenticateWithCredential(credential);
      await user.verifyBeforeUpdateEmail(newEmail);

      await _firestore.collection('users').doc(user.uid).set({
        'email': newEmail,
      }, SetOptions(merge: true));
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  // Verify Phone Number
  Future<void> _verifyPhoneNumber(String phoneNumber, BuildContext context,
      FirebaseAuthMultiFactorException e) async {
    try {
      final firstHint = e.resolver.hints.first;
      if (firstHint is! PhoneMultiFactorInfo) {
        return;
      }
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          multiFactorInfo: firstHint,
          multiFactorSession: e.resolver.session,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.toString())));
          },
          codeSent: (String verificationId, int? resendToken) async {
            // get the sms code from user, using a text field
            final smsCode = await _getOTP(
                context, phoneNumber, e.resolver.session,
                resendToken: resendToken);

            if (smsCode != null) {
              // Create a PhoneAuthCredential with the code
              final phoneAuthCredential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: smsCode);

              // Sign in with the credential
              try {
                await e.resolver.resolveSignIn(
                  PhoneMultiFactorGenerator.getAssertion(phoneAuthCredential),
                );
              } on FirebaseAuthException catch (e) {
                throw Exception(e);
              }
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            Navigator.pop(context);
            throw Exception("Code auto retrieval timeout");
          });
    } catch (e) {
      throw Exception(e);
    }
  }

  // a dialog to get the OTP
  Future<dynamic> _getOTP(
      BuildContext context, String phoneNumber, MultiFactorSession session,
      {int? resendToken}) async {
    return showDialog(
        context: context,
        builder: (context) {
          final TextEditingController smsController = TextEditingController();
          return Dialog.fullscreen(
              child: MyKeyboardHider(
                  child: Scaffold(
                      body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 50.0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 95),
                    // Enter OTP message
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Enter The\nOTP",
                            style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w600,
                                height: 1.2),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "We've sent an OTP to your phone...",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                                height: 1.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),

                    Form(
                        child: Column(
                      children: <Widget>[
                        MyTextFormField(
                            controller: smsController,
                            labelText: "SMS Code",
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter the code";
                              }
                              return null;
                            },
                            obscureText: false),
                        const SizedBox(height: 15),
                        MySubmitButton(
                            onPressed: () {
                              Navigator.pop(context, smsController.text);
                            },
                            text: "Continue")
                      ],
                    )),

                    // Go back to login
                    const SizedBox(height: 25),

                    // Resend
                    GestureDetector(
                      onTap: () async {
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to send")),
                            );
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, color: Color(0xFFC7623A)),
                          Text(
                            "Resend OTP",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFC7623A),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    // Go back to login

                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, color: Color(0xFFC7623A)),
                          Text(
                            "Back to login",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFC7623A),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ))));
        },
        barrierDismissible: false);
  } // signInWithEmailAndPassword

  // Update Info
  Future<void> updateAccount(
      DateTime? dateOfBirth, String? occupation, String? name) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'name': name,
        'dateOfBirth': dateOfBirth,
        'occupation': occupation,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      // sign out
      await _auth.signOut();
      // sign out from google
      await _googleSignIn.signOut();
    } catch (e) {
      throw Exception(e);
    }
  } // signOut

  // register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      String email,
      String password,
      DateTime dateOfBirth,
      String? occupation,
      String name) async {
    try {
      // Create user sending verification email
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create a new document for the user with the uid
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'dateOfBirth': dateOfBirth,
        'occupation': occupation,
        'email': email,
        'uid': userCredential.user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } catch (e) {
      throw Exception(e);
    }
  } // registerWithEmailAndPassword

  // verify email
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    try {
      await user!.sendEmailVerification();
    } catch (e) {
      throw Exception(e);
    }
  } // sendEmailVerification

  // Delete user
  Future<void> deleteUser() async {
    User? user = _auth.currentUser;
    try {
      // delete all documents associated with the user
      await _firestore.collection('users').doc(user!.uid).delete();
      await _firestore
          .collection('assessments')
          .doc(user.uid)
          .collection("completed_questionaires")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });
      await user.delete();
    } catch (e) {
      throw Exception(e);
    }
  } // deleteUser

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      // Fetch email, profile and date of birth
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>[
          'email',
          'profile',
          'https://www.googleapis.com/auth/user.birthday.read'
        ],
      ).signIn();

      // If the process is cancelled
      if (googleUser == null) {
        throw Exception("Sign in process cancelled");
      }

      // Get the Google Sign In Authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      await _auth.signInWithCredential(credential);

      // User Info
      final User? user = _auth.currentUser;

      // If the UID is already in the database
      final DocumentSnapshot doc =
          await _firestore.collection('users').doc(user!.uid).get();
      if (doc.exists) {
        return;
      }
      // Get the user's date of birth
      final headers = await googleUser.authHeaders;
      final r = await http.get(
          Uri.parse(
              "https://people.googleapis.com/v1/people/me?personFields=birthdays"),
          headers: headers);
      final response = json.decode(r.body)["birthdays"][0]["date"];

      // Get the date of birth
      var dateOfBirth;
      if (response["month"] < 10) {
        response["month"] = "0${response["month"]}";
      }
      if (response["day"] < 10) {
        response["day"] = "0${response["day"]}";
      }
      try {
        dateOfBirth = DateTime.parse(
            "${response["year"]}-${response["month"]}-${response["day"]} 00:00:00.000");
      } catch (e) {
        dateOfBirth = DateTime(2022);
      }

      // Create a new document for the user with the uid
      _firestore.collection('users').doc(user!.uid).set({
        'email': user.email,
        'name': user.displayName,
        'dateOfBirth': dateOfBirth,
        'occupation': "Not Specified",
        'uid': user.uid,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Get User Info
  Future<MyUser> getUserData() async {
    DocumentSnapshot userData;
    try {
      userData = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
    } catch (e) {
      print(e);
      MyUser empty = MyUser(
          uid: "",
          email: "error",
          name: "error",
          occupation: "error",
          dateOfBirth: DateTime(2022),
          timestamp: Timestamp.now());
      return empty;
    }

    // Convert to map
    MyUser user = MyUser.fromMap(userData.data() as Map<String, dynamic>);
    return user;
  }
}
