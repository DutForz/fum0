import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fumo/core/di/injection.dart';
import 'package:fumo/core/theme/chat_theme_local_storage.dart';
import 'package:fumo/core/theme/chat_theme_provider.dart';
import 'package:fumo/domain/entities/chat_theme_entity.dart';
import 'package:fumo/extensions/context_extensions.dart';
import 'package:fumo/presentation/blocs/settings/settings_bloc.dart';
import 'package:fumo/presentation/blocs/profile/profile_bloc.dart';
import 'package:fumo/presentation/pages/profile/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  void _openProfile(BuildContext context) { Navigator.push(context, MaterialPageRoute<void>(builder: (context) => BlocProvider(create: (_) => sl<ProfileBloc>()..add(const LoadProfile()), child: const ProfileScreen()))); }

  void _openSavedThemes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const _SavedThemesScreen(),
      ),
    );
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(context.localizations.settings), backgroundColor: Theme.of(context).colorScheme.surface, foregroundColor: Theme.of(context).colorScheme.inversePrimary, elevation: 0),
      body: BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
        final isDarkMode = state is SettingsLoaded ? state.isDarkMode : false;
        return ListView(children: [
          ListTile(leading: const Icon(Icons.person), title: Text(context.localizations.profile), trailing: const Icon(Icons.chevron_right), onTap: () => _openProfile(context)),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(context.localizations.savedThemes),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openSavedThemes(context),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(context.localizations.darkmode),
            CupertinoSwitch(value: isDarkMode, onChanged: (_) { context.read<SettingsBloc>().add(const SettingsThemeToggled()); }),
          ]),
        ]);
      }),
    );
  }
}

class _SavedThemesScreen extends StatefulWidget {
  const _SavedThemesScreen();

  @override
  State<_SavedThemesScreen> createState() => _SavedThemesScreenState();
}

class _SavedThemesScreenState extends State<_SavedThemesScreen> {
  List<ChatThemeEntity> _themes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    final themes = await ChatThemeLocalStorage.loadSavedThemes();
    if (mounted) {
      setState(() {
        _themes = themes;
        _loading = false;
      });
    }
  }

  Future<void> _deleteTheme(String themeName) async {
    await ChatThemeLocalStorage.deleteSavedTheme(themeName);
    _loadThemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(context.localizations.savedThemes),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _themes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.palette_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          context.localizations.noSavedThemes,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.localizations.savedThemesHint,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.chat),
                          label: Text(context.localizations.goToChatCreateTheme),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _themes.length,
                  itemBuilder: (context, index) {
                    final theme = _themes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    theme.themeName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _deleteTheme(theme.themeName),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ChatThemeProvider(
                              theme: theme,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.backgroundColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                height: 80,
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: theme.otherBubbleColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          context.localizations.other,
                                          style: TextStyle(
                                            color: theme.otherTextColor,
                                            fontFamily: theme.fontFamily,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: theme.ownBubbleColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          context.localizations.you,
                                          style: TextStyle(
                                            color: theme.ownTextColor,
                                            fontFamily: theme.fontFamily,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${context.localizations.fontLabel}${theme.fontFamily}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontFamily: theme.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
