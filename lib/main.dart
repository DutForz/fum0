import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/core/theme/dark_mode.dart';
import 'package:fumo/core/theme/light_mode.dart';
import 'package:fumo/firebase_options.dart';
import 'package:fumo/l10n/app_localizations.dart';
import 'package:fumo/l10n/l10n.dart';
import 'package:fumo/presentation/blocs/auth/auth_bloc.dart';
import 'package:fumo/presentation/blocs/settings/settings_bloc.dart';
import 'package:fumo/presentation/widgets/auth_gate.dart';
import 'package:fumo/streams/general_stream.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupDependencyInjection();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) => sl<SettingsBloc>()..add(const SettingsStarted()),
        ),
      ],
      child: StreamBuilder<Locale>(
        stream: GeneralStream.languageStream.stream,
        builder: (context, snapshot) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              final isDarkMode = settingsState is SettingsLoaded ? settingsState.isDarkMode : false;
              return MaterialApp(
                locale: snapshot.data ?? const Locale('en'),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: L10n.locals,
                home: const AuthGate(),
                debugShowCheckedModeBanner: false,
                theme: isDarkMode ? darkMode : lightMode,
              );
            },
          );
        },
      ),
    );
  }
}
