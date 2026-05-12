import 'package:flutter/material.dart';
import 'package:fumo/components/MyIcon.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/l10n/l10n.dart';
import 'package:fumo/pages/settings/settings_Screan.dart';
import 'package:fumo/streams/general_stream.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key, required this.selectedLocale});
  final Locale selectedLocale;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                  leading: Icon(Icons.home),
                  onTap: () {
                    Navigator.pop(context);
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
                      MaterialPageRoute(
                        builder: (context) => const settings_Screan(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: ListTile(
                  title: Text(context.localizations.language),
                  leading: Icon(Icons.language),
                  onTap: () async {
                    GeneralStream.languageStream.add(
                      L10n.locals.firstWhere(
                        (element) => element != Localizations.localeOf(context),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
