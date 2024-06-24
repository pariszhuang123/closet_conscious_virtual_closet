import 'package:flutter/material.dart';

final ThemeData myClosetTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.teal,
    accentColor: Colors.tealAccent,
  ).copyWith(
    primary: Colors.teal.shade800, // Closest to #366D59
    onPrimary: Colors.white,
    primaryContainer: Colors.teal.shade900, // Closest to #255743
    secondary: Colors.teal.shade400, // Closest to #A0D6B4
    onSecondary: Colors.black,
    secondaryContainer: Colors.green.shade500, // Closest to #88B69C
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.grey.shade200,
    onSurface: Colors.black,
    error: Colors.red.shade200,
    onError: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed) || states.contains(MaterialState.selected)) {
            return Colors.teal.shade800; // Closest to #255743
          }
          return Colors.teal.shade400; // Closest to #366D59
        },
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          return Colors.white; // Always white text for better visibility
        },
      ),
      textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed) || states.contains(MaterialState.selected)) {
            return const TextStyle(fontWeight: FontWeight.bold);
          }
          return const TextStyle(fontWeight: FontWeight.normal);
        },
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black), // Larger body text
    bodyMedium: TextStyle(color: Colors.black), // Smaller body text
    displayLarge: TextStyle(color: Colors.black), // Largest headline
    displayMedium: TextStyle(color: Colors.black), // Second largest headline
    titleMedium: TextStyle(color: Colors.black), // Medium-emphasis text
    titleSmall: TextStyle(color: Colors.black), // Smaller medium-emphasis text
    bodySmall: TextStyle(color: Colors.black), // Caption text
    labelLarge: TextStyle(color: Colors.white), // Text for buttons
    labelSmall: TextStyle(color: Colors.black), // Overline text
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade200,
    selectedColor: Colors.teal.shade800, // Closest to #366D59
    disabledColor: Colors.grey,
    secondarySelectedColor: Colors.teal.shade400, // Closest to #88B69C
    padding: const EdgeInsets.all(4.0),
    shape: const StadiumBorder(),
    labelStyle: const TextStyle(color: Colors.black),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF366d59),  // Closest to #A0D6B4
    foregroundColor: Colors.black,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.greenAccent.shade100, // Closest to #A0D6B4
    elevation: 16.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.greenAccent.shade100, // Closest to #A0D6B4
    selectedItemColor: Colors.teal.shade800, // Closest to #255743
    unselectedItemColor: Colors.grey,
  ),
);