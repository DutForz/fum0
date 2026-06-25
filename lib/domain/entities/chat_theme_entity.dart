import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChatThemeEntity extends Equatable {
  const ChatThemeEntity({
    required this.backgroundColor,
    required this.ownBubbleColor,
    required this.otherBubbleColor,
    required this.ownTextColor,
    required this.otherTextColor,
    required this.appBarColor,
    required this.fontFamily,
    required this.themeName,
  });

  final Color backgroundColor;
  final Color ownBubbleColor;
  final Color otherBubbleColor;
  final Color ownTextColor;
  final Color otherTextColor;
  final Color appBarColor;
  final String fontFamily;
  final String themeName;

  static const String defaultFontFamily = 'Roboto';

  static const List<String> availableFonts = [
    'Roboto',
    'Shonen',
    'Serif',
    'Monospace',
    'Cursive',
    'SansSerif',
    'Arial',
    'Georgia',
  ];

  factory ChatThemeEntity.defaultTheme() => const ChatThemeEntity(
    backgroundColor: Color(0xFF87A3A1),
    ownBubbleColor: Color(0xFFEEEDED),
    otherBubbleColor: Color(0xFF969595),
    ownTextColor: Color(0xFF000000),
    otherTextColor: Color(0xFFFFFFFF),
    appBarColor: Color(0xFFEEEDED),
    fontFamily: 'Roboto',
    themeName: 'Default',
  );

  ChatThemeEntity copyWith({
    Color? backgroundColor,
    Color? ownBubbleColor,
    Color? otherBubbleColor,
    Color? ownTextColor,
    Color? otherTextColor,
    Color? appBarColor,
    String? fontFamily,
    String? themeName,
  }) {
    return ChatThemeEntity(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      ownBubbleColor: ownBubbleColor ?? this.ownBubbleColor,
      otherBubbleColor: otherBubbleColor ?? this.otherBubbleColor,
      ownTextColor: ownTextColor ?? this.ownTextColor,
      otherTextColor: otherTextColor ?? this.otherTextColor,
      appBarColor: appBarColor ?? this.appBarColor,
      fontFamily: fontFamily ?? this.fontFamily,
      themeName: themeName ?? this.themeName,
    );
  }

  Map<String, dynamic> toMap() => {
    'backgroundColor': backgroundColor.toARGB32(),
    'ownBubbleColor': ownBubbleColor.toARGB32(),
    'otherBubbleColor': otherBubbleColor.toARGB32(),
    'ownTextColor': ownTextColor.toARGB32(),
    'otherTextColor': otherTextColor.toARGB32(),
    'appBarColor': appBarColor.toARGB32(),
    'fontFamily': fontFamily,
    'themeName': themeName,
  };

  factory ChatThemeEntity.fromMap(Map<String, dynamic> map) => ChatThemeEntity(
    backgroundColor: Color(map['backgroundColor'] as int),
    ownBubbleColor: Color(map['ownBubbleColor'] as int),
    otherBubbleColor: Color(map['otherBubbleColor'] as int),
    ownTextColor: Color(map['ownTextColor'] as int),
    otherTextColor: Color(map['otherTextColor'] as int),
    appBarColor: Color(map['appBarColor'] as int),
    fontFamily: map['fontFamily'] as String? ?? 'Roboto',
    themeName: map['themeName'] as String? ?? 'Custom',
  );

  String toJsonString() => {
    'backgroundColor': backgroundColor.toARGB32(),
    'ownBubbleColor': ownBubbleColor.toARGB32(),
    'otherBubbleColor': otherBubbleColor.toARGB32(),
    'ownTextColor': ownTextColor.toARGB32(),
    'otherTextColor': otherTextColor.toARGB32(),
    'appBarColor': appBarColor.toARGB32(),
    'fontFamily': fontFamily,
    'themeName': themeName,
  }.toString();

  @override
  List<Object?> get props => [
    backgroundColor,
    ownBubbleColor,
    otherBubbleColor,
    ownTextColor,
    otherTextColor,
    appBarColor,
    fontFamily,
    themeName,
  ];
}
