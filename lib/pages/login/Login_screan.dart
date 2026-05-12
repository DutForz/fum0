import 'package:flutter/material.dart';
import 'package:fumo/components/MyButton.dart';
import 'package:fumo/components/MyIcon.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/core/auth/auth_service.dart';

class LoginScrean extends StatelessWidget {
  LoginScrean({super.key, required this.onTap});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  void login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Myicon(gif: 'giphy.gif'),
            const SizedBox(height: 100),
            Text(
              "Welcome Back you've been missed",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            MyTextField(
              hintText: 'Login',
              Obscure: false,
              controller: emailController,
            ),
            SizedBox(height: 5),
            MyTextField(
              hintText: 'password',
              Obscure: true,
              controller: passwordController,
            ),
            Mybutton(inSideText: "Sign In", onTap: () => login(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " not a member ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    " Register now",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
