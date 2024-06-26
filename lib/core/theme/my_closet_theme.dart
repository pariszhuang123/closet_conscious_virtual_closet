import 'package:flutter/material.dart';

final ThemeData myClosetTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.teal,
    accentColor: Colors.tealAccent,
  ).copyWith(
    primary: Colors.teal.shade800, // Closest to #366D59
    onPrimary: Colors.white,
    primaryContainer: Colors.teal.shade900, // Closest to #255743
    secondary: Colors.teal.shade100, // Closest to #A0D6B4
    onSecondary: Colors.black,
    secondaryContainer: Colors.green.shade500,
    surface: Colors.white,
    onSurface: Colors.black,
    error: Colors.red.shade200,
    onError: Colors.white,
  ),
  dividerColor: Colors.teal.shade800,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed) || states.contains(WidgetState.selected)) {
            return Colors.teal.shade800; // Closest to #255743
          }
          return Colors.teal.shade400; // Closest to #366D59
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
          return Colors.white; // Always white text for better visibility
        },
      ),
      textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.pressed) || states.contains(WidgetState.selected)) {
            return const TextStyle(fontWeight: FontWeight.bold);
          }
          return const TextStyle(fontWeight: FontWeight.normal);
        },
      ),
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Larger body text
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black), // Medium body text
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black), // Largest headline
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black), // Second largest headline
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black), // Medium-emphasis text
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black), // Smaller medium-emphasis text
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black), // Caption text
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // Text for buttons
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black), // Overline text
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
    backgroundColor: Colors.teal.shade800,  // Closest to #A0D6B4
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