import 'package:flutter/material.dart';
import 'package:fumo/core/auth/auth_gate.dart';
import 'package:fumo/core/theme/light_mode.dart' show lightMode;
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
      theme: lightMode,
    );
  }
}
