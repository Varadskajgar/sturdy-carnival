import 'package:flutter/material.dart';

class AppTheme {
  static const lime = Color(0xFFB7F34A);
  static const ink = Color(0xFF171917);
  static const muted = Color(0xFF777D75);
  static const canvas = Color(0xFFF7F8F5);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: lime,
      brightness: Brightness.light,
      primary: ink,
      secondary: lime,
      surface: Colors.white,
    ),
    fontFamily: 'Arial',
    appBarTheme: const AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: ink,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
