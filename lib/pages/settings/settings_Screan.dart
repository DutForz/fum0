import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fumo/core/theme/theme_provider.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:provider/provider.dart';

class settings_Screan extends StatelessWidget {
  const settings_Screan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(context.localizations.settings),
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: Row(
        children: [
          Text(context.localizations.darkmode),
          CupertinoSwitch(
            value: Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).isDarkMode,
            onChanged: (value) => Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).toggleTheme(),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
