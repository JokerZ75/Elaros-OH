import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:occupational_health/components/my_keyboard_hider.dart';
import 'package:occupational_health/components/my_submit_button.dart';
import 'package:occupational_health/components/my_text_form_field.dart';
import 'package:occupational_health/model/user.dart';

class AuthService extends ChangeNotifier {
  // instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // instance for the firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in with email and password
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // start multifactor session

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
      try {
        await _auth.verifyPhoneNumber(
            multiFactorSession: e.resolver.session,
            multiFactorInfo: firstHint,
            verificationCompleted: (PhoneAuthCredential credential) async {},
            verificationFailed: (FirebaseAuthException e) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(e.toString())));
            },
            codeSent: (String verificationId, int? resendToken) async {
              // get the sms code from user, using a text field
              final smsCode = await getOTP(context, firstHint.phoneNumber,
                  resendToken: resendToken);

              if (smsCode != null) {
                // Create a PhoneAuthCredential with the code
                final phoneAuthCredential = PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: smsCode);

                // Sign the user in
                try {
                  await e.resolver.resolveSignIn(
                    PhoneMultiFactorGenerator.getAssertion(
                      phoneAuthCredential,
                    ),
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
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  // a dialog to get the OTP
  Future<dynamic> getOTP(BuildContext context, String phoneNumber,
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
  Future<void> updateAccount(String? email, String? password,
      DateTime? dateOfBirth, String? occupation, String? name) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'email': email,
        'name': name,
        'dateOfBirth': dateOfBirth,
        'occupation': occupation,
        'password': password,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
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

  // Enroll to MFA
  Future<void> enroll() async {}

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
