import 'dart:convert';
import 'package:fumo/domain/entities/chat_theme_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatThemeLocalStorage {
  static const String _themesPrefix = 'chat_theme_';
  static const String _savedThemesKey = 'saved_chat_themes';

  static Future<void> saveThemeForChat({
    required String chatRoomId,
    required ChatThemeEntity theme,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(theme.toMap());
      await prefs.setString('$_themesPrefix$chatRoomId', json);
    } catch (_) {

    }
  }

  static Future<ChatThemeEntity?> loadThemeForChat({
    required String chatRoomId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString('$_themesPrefix$chatRoomId');
      if (json == null) return null;
      final map = jsonDecode(json) as Map<String, dynamic>;
      return ChatThemeEntity.fromMap(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveThemeToProfile({
    required ChatThemeEntity theme,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themesJson = prefs.getString(_savedThemesKey);
      final themes = <Map<String, dynamic>>[];
      if (themesJson != null) {
        try {
          final decoded = jsonDecode(themesJson) as List<dynamic>;
          themes.addAll(decoded.cast<Map<String, dynamic>>());
        } catch (_) {}
      }
      themes.removeWhere((t) => t['themeName'] == theme.themeName);
      themes.add(theme.toMap());
      await prefs.setString(_savedThemesKey, jsonEncode(themes));
    } catch (_) {

    }
  }

  static Future<List<ChatThemeEntity>> loadSavedThemes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themesJson = prefs.getString(_savedThemesKey);
      if (themesJson == null) return [];
      final decoded = jsonDecode(themesJson) as List<dynamic>;
      return decoded
          .cast<Map<String, dynamic>>()
          .map((map) => ChatThemeEntity.fromMap(map))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> deleteSavedTheme(String themeName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themesJson = prefs.getString(_savedThemesKey);
      if (themesJson == null) return;
      final decoded = jsonDecode(themesJson) as List<dynamic>;
      final themes = decoded.cast<Map<String, dynamic>>();
      themes.removeWhere((t) => t['themeName'] == themeName);
      await prefs.setString(_savedThemesKey, jsonEncode(themes));
    } catch (_) {

    }
  }
}