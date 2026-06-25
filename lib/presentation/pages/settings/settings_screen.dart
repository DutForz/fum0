import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/presentation/blocs/settings/settings_bloc.dart';
import 'package:fumo/presentation/blocs/profile/profile_bloc.dart';
import 'package:fumo/presentation/pages/profile/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  void _openProfile(BuildContext context) { Navigator.push(context, MaterialPageRoute<void>(builder: (context) => BlocProvider(create: (_) => sl<ProfileBloc>()..add(const LoadProfile()), child: const ProfileScreen()))); }
  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(context.localizations.settings), backgroundColor: Theme.of(context).colorScheme.surface, foregroundColor: Theme.of(context).colorScheme.inversePrimary, elevation: 0),
      body: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
        final isDarkMode = state is SettingsLoaded ? state.isDarkMode : false;
        return ListView(children: [
          ListTile(leading: const Icon(Icons.person), title: Text(context.localizations.profile), trailing: const Icon(Icons.chevron_right), onTap: () => _openProfile(context)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(context.localizations.darkmode),
            CupertinoSwitch(value: isDarkMode, onChanged: (_) { context.read<SettingsBloc>().add(const SettingsThemeToggled()); }),
          ]),
        ]);
      }),
    );
  }
}
