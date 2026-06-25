import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';
import 'package:fumo/presentation/pages/home/home_screen.dart';
import 'package:fumo/presentation/widgets/login_or_register.dart';
import 'package:fumo/presentation/blocs/home/home_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return BlocProvider(
            create: (_) => sl<HomeBloc>(),
            child: const HomeScreen(),
          );
        }
        if (state is AuthInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return const LoginOrRegister();
      },
    );
  }
}
