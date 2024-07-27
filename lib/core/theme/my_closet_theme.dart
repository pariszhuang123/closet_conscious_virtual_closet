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
    secondaryContainer: Colors.green.shade500,
    surface: Colors.white,
    onSurface: Colors.teal.shade800,
    error: Colors.red.shade200,
    onError: Colors.white,
  ),
  dividerColor: Colors.teal.shade800,

  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black), // Larger body text
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black), // Medium body text
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black), // Largest headline
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black), // Second largest headline
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black), // Medium-emphasis text
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black), // Smaller medium-emphasis text
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black), // Caption text
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // Text for buttons
    labelSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black), // Overline text
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
    backgroundColor: Colors.teal.shade100,  // Closest to #A0D6B4
    foregroundColor: Colors.black,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.teal.shade100, // Closest to #A0D6B4
    elevation: 16.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.teal.shade100, // Closest to #A0D6B4
    selectedItemColor: Colors.teal.shade800, // Closest to #255743
    unselectedItemColor: Colors.grey,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.teal.shade100, // Set the background color for SnackBar
    contentTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold), // Set the text color and style
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.teal.shade100,
    titleTextStyle: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: Colors.teal.shade800),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.teal.shade900; // closest to #255743
        }
        return Colors.teal.shade800; // closest to #366D59
      }),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // text color
    ),
  ),
);
