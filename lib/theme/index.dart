// Light Theme
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Roboto",
    appBarTheme: const AppBarTheme(
      backgroundColor:
          Colors.blue, // You can customize the app bar color in the light theme
    ),
    textTheme: const TextTheme().copyWith(
      bodySmall: const TextStyle(color: Colors.black),
      bodyMedium: const TextStyle(color: Colors.black),
      bodyLarge: const TextStyle(color: Colors.black),
      labelSmall: const TextStyle(color: Colors.black),
      labelMedium: const TextStyle(color: Colors.black),
      labelLarge: const TextStyle(color: Colors.black),
      displaySmall: const TextStyle(color: Colors.black),
      displayMedium: const TextStyle(color: Colors.black),
      displayLarge: const TextStyle(color: Colors.black),
    ),
  );

// Dark Theme
  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    fontFamily: "Roboto",
    appBarTheme: AppBarTheme(
      backgroundColor: Colors
          .grey[900], // You can customize the app bar color in the dark theme
    ),
    textTheme: const TextTheme().copyWith(
      bodySmall: const TextStyle(color: Colors.white),
      bodyMedium: const TextStyle(color: Colors.white),
      bodyLarge: const TextStyle(color: Colors.white),
      labelSmall: const TextStyle(color: Colors.white),
      labelMedium: const TextStyle(color: Colors.white),
      labelLarge: const TextStyle(color: Colors.white),
      displaySmall: const TextStyle(color: Colors.white),
      displayMedium: const TextStyle(color: Colors.white),
      displayLarge: const TextStyle(color: Colors.white),
    ),
  );
}
