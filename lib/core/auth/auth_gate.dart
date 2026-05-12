import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fumo/core/auth/LoginOrRegister.dart';
import 'package:fumo/pages/home/home_screan.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeScrean();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
