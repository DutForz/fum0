import 'package:flutter/material.dart';
import 'package:fumo/pages/login/Login_screan.dart';
import 'package:fumo/pages/register/Register_screan.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScrean(onTap: togglePages);
    } else {
      return RegisterScrean(onTap: togglePages);
    }
  }
}
