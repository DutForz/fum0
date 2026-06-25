import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/components/MyButton.dart';
import 'package:fumo/components/MyIcon.dart';
import 'package:fumo/components/MyTextField.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onTap});
  final VoidCallback onTap;
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override void dispose() { _passwordController.dispose(); _emailController.dispose(); super.dispose(); }
  void _login() { context.read<AuthBloc>().add(AuthSignInRequested(email: _emailController.text.trim(), password: _passwordController.text)); }
  @override Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) { if (state is AuthError) { showDialog<void>(context: context, builder: (context) => AlertDialog(title: Text(state.message))).then((_) { if (context.mounted) context.read<AuthBloc>().add(const AuthErrorAcknowledged()); }); } },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Myicon(gif: 'giphy.gif'),
          const SizedBox(height: 100),
          Text(context.localizations.welcomeBack, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16)),
          MyTextField(hintText: context.localizations.login, Obscure: false, controller: _emailController),
          const SizedBox(height: 5),
          MyTextField(hintText: context.localizations.password, Obscure: true, controller: _passwordController),
          Mybutton(inSideText: context.localizations.signIn, onTap: _login),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(' ${context.localizations.notAMember}', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            GestureDetector(onTap: widget.onTap, child: Text(' ${context.localizations.registerNow}', style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontWeight: FontWeight.bold))),
          ]),
        ])),
      ),
    );
  }
}
