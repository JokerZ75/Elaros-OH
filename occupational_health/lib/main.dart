import 'package:flutter/material.dart';
import 'package:occupational_health/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:occupational_health/services/Auth/auth_gate.dart';
import 'package:provider/provider.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      create: (context) => AuthService(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: const Color(0xFFF2C351),
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          rangePickerHeaderBackgroundColor: Colors.amber,
          rangePickerBackgroundColor: Colors.white
          
        ),
      ),
      title: 'Occupational Health',
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}
