import 'package:flutter/material.dart';
import 'package:fumo/extensions/context_extensions.dart';

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
    );
  }
}
