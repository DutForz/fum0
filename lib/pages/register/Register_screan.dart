import 'package:flutter/material.dart';
import 'package:fumo/components/MyButton.dart';
import 'package:fumo/components/MyIcon.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/core/auth/auth_service.dart';

class RegisterScrean extends StatelessWidget {
  RegisterScrean({super.key, required this.onTap});
  final void Function()? onTap;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  Future<void> Register(BuildContext context) async {
    final auth = AuthService();
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await auth.signUpWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(title: Text("Password don't match ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Myicon(gif: 'giphy (2).gif'),
            const SizedBox(height: 100),
            Text(
              "Hi my cutie",
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
            SizedBox(height: 5),
            MyTextField(
              hintText: 'Confirm password',
              Obscure: true,
              controller: confirmPasswordController,
            ),
            Mybutton(inSideText: "Sign Up", onTap: () => Register(context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " Do you a member ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    " Login ",
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
