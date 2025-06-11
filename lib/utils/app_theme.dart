import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.accentLight,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black45),
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          AppColors.accentLight,
        ),
      ),
    ),
    hintColor: Colors.black45,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black45),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black45),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(20),
      fillColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.accentLight,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
      headlineMedium: TextStyle(
        color: Colors.black54,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        color: Colors.black54,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
        color: Colors.black54,
        fontSize: 16,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.black45),
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.accentDark,
    canvasColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.primaryDark,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarTextStyle: TextStyle(color: Colors.white),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          AppColors.accentDark,
        ),
      ),
    ),
    hintColor: Colors.white60,
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70),
      ),
      filled: true,
      contentPadding: EdgeInsets.all(20),
      fillColor: AppColors.primaryDark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.primaryDark,
      selectedItemColor: AppColors.accentDark,
      unselectedItemColor: Colors.white70,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
      headlineMedium: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
      headlineSmall: TextStyle(
        color: Colors.white70,
        fontSize: 14,
      ),
      bodyLarge: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
      titleMedium: TextStyle(
        color: Colors.white60,
        fontSize: 14,
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: AppColors.primaryDark,
    ),
  );

  // Expose theme colors
}
