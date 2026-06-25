import 'package:flutter/material.dart';
import 'package:fumo/presentation/pages/login/login_screen.dart';
import 'package:fumo/presentation/pages/register/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool _showLoginPage = true;

  void _togglePages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return LoginScreen(onTap: _togglePages);
    }
    return RegisterScreen(onTap: _togglePages);
  }
}
