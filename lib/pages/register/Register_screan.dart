import 'package:flutter/material.dart';
import 'package:fumo/components/MyButton.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/core/auth/auth_service.dart';

class RegisterScrean extends StatelessWidget {
  RegisterScrean({super.key, required this.onTap});
  final void Function()? onTap;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  void Register(BuildContext context) {
    final auth = AuthService();
    if (passwordController.text == confirmPasswordController.text) {
      try {
        auth.signUpWithEmailAndPassword(
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
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 5,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.topCenter,
                    widthFactor: 0.7,
                    heightFactor: 0.7,
                    child: const Image(
                      image: AssetImage('assets/image/giphy (2).gif'),
                    ),
                  ),
                ),
              ),
            ),
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
