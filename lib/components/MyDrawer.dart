import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/components/MyIcon.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/l10n/l10n.dart';
import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';
import 'package:fumo/presentation/blocs/profile/profile_bloc.dart';
import 'package:fumo/presentation/pages/profile/profile_screen.dart';
import 'package:fumo/presentation/pages/settings/settings_screen.dart';
import 'package:fumo/streams/general_stream.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key, required this.selectedLocale});
  final Locale selectedLocale;
  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthSignOutRequested());
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(const LoadProfile()),
          child: const ProfileScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Myicon(gif: 'test3.gif', width: 150, height: 150),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(context.localizations.home),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(context.localizations.profile),
                  leading: const Icon(Icons.person),
                  onTap: () {
                    Navigator.pop(context);
                    _openProfile(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(context.localizations.settings),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(context.localizations.language),
                  leading: const Icon(Icons.language),
                  onTap: () {
                    final currentLocale = Localizations.localeOf(context);
                    final currentIndex = L10n.locals.indexOf(currentLocale);
                    final nextIndex = (currentIndex + 1) % L10n.locals.length;
                    GeneralStream.languageStream.add(L10n.locals[nextIndex]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  onTap: () => _logout(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
