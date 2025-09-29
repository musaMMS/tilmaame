import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF6600);   // Orange
  static const Color secondary = Color(0xFF000000); // Black
  static const Color background = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF333333);
  static const Color textLight = Color(0xFF777777);

  static const Color button = Color(0xFFFF6600); // Orange button
}

ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,

  /// AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),

  /// Text Theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.textDark, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.textLight, fontSize: 14),
    titleLarge: TextStyle(
        color: AppColors.textDark, fontSize: 22, fontWeight: FontWeight.bold),
  ),

  /// Card Theme
  // cardTheme: CardTheme(
  //   color: Colors.white,
  //   elevation: 4,
  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  // ),

  /// Floating Button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.white,
  ),

  /// Elevated Button
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.button,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),

  /// Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: const BorderSide(color: AppColors.primary, width: 2),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),

  /// Text Button
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.secondary,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
);
