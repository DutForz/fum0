import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/components/MyButton.dart';
import 'package:fumo/components/MyIcon.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.onTap});
  final VoidCallback onTap;
  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override void dispose() { _passwordController.dispose(); _confirmPasswordController.dispose(); _emailController.dispose(); super.dispose(); }
  void _register() {
    if (_passwordController.text != _confirmPasswordController.text) { showDialog<void>(context: context, builder: (context) => const AlertDialog(title: Text("Password don't match "))); return; }
    context.read<AuthBloc>().add(AuthSignUpRequested(email: _emailController.text.trim(), password: _passwordController.text));
  }
  @override Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) { if (state is AuthError) { showDialog<void>(context: context, builder: (context) => AlertDialog(title: Text(state.message))).then((_) { if (context.mounted) context.read<AuthBloc>().add(const AuthErrorAcknowledged()); }); } },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Myicon(gif: 'giphy (2).gif'),
          const SizedBox(height: 100),
          Text('Create your account', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16)),
          MyTextField(hintText: 'Login', Obscure: false, controller: _emailController),
          const SizedBox(height: 5),
          MyTextField(hintText: 'password', Obscure: true, controller: _passwordController),
          const SizedBox(height: 5),
          MyTextField(hintText: 'Confirm password', Obscure: true, controller: _confirmPasswordController),
          Mybutton(inSideText: 'Sign Up', onTap: _register),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(' Do you a member ?', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            GestureDetector(onTap: widget.onTap, child: Text(' Login ', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold))),
          ]),
        ])),
      ),
    );
  }
}
