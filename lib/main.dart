import 'package:flutter/material.dart';
import 'package:fumo/core/auth/auth_gate.dart';
import 'package:fumo/core/theme/light_mode.dart' show lightMode;
import 'package:firebase_core/firebase_core.dart';
import 'package:fumo/l10n/app_localization.dart';
import 'package:fumo/l10n/l10n.dart';
import 'package:fumo/streams/general_stream.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    GeneralStream.languageStream.add(const Locale('en'));
    super.initState();
  }

  @override
  void dispose() {
    GeneralStream.languageStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
      stream: GeneralStream.languageStream.stream,
      builder: (context, snapshot) {
        return MaterialApp(
          locale: snapshot.data ?? const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: L10n.locals,
          home: const AuthGate(),
          debugShowCheckedModeBanner: false,
          theme: lightMode,
        );
      },
    );
  }
}
