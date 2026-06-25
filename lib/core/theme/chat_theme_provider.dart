import 'package:flutter/material.dart';
import 'package:fumo/domain/entities/chat_theme_entity.dart';

class ChatThemeProvider extends InheritedWidget {
  const ChatThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  final ChatThemeEntity theme;

  static ChatThemeEntity of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ChatThemeProvider>();
    return provider?.theme ?? ChatThemeEntity.defaultTheme();
  }

  @override
  bool updateShouldNotify(ChatThemeProvider oldWidget) => theme != oldWidget.theme;
}