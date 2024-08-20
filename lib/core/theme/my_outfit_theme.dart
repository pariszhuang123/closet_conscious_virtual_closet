import 'package:flutter/material.dart';

final ThemeData myOutfitTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent,
  ).copyWith(
    primary: Colors.blue.shade800, // Dark blue for primary
    onPrimary: Colors.white,
    primaryContainer: Colors.blue.shade800, // Darker blue for primary container
    secondary: Colors.lightBlue.shade400, // Light blue for secondary
    onSecondary: Colors.black,
    secondaryContainer: Colors.blueAccent.shade700,
    surface: Colors.white,
    onSurface: Colors.blue.shade800,
    error: Colors.red,
    onError: Colors.white,
  ),
  dividerColor: Colors.blue.shade800,

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
    selectedColor: Colors.blue.shade700, // Dark blue for selected chip
    disabledColor: Colors.grey,
    secondarySelectedColor: Colors.blueAccent.shade700, // Darker light blue for secondary selected chip
    padding: const EdgeInsets.all(4.0),
    shape: const StadiumBorder(),
    labelStyle: const TextStyle(color: Colors.black),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue.shade100, // Light blue for AppBar
    foregroundColor: Colors.black,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.lightBlue.shade100, // Light blue for Drawer
    elevation: 16.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.blue.shade100, // Light blue for BottomNavigationBar
    selectedItemColor: Colors.blue.shade800, // Darker blue for selected item
    unselectedItemColor: Colors.grey,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.blue.shade800, // Set the background color for SnackBar
    contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Set the text color and style
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.lightBlue.shade100,
    titleTextStyle: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: Colors.blue.shade800),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.blue.shade900; // closest to #255743
        }
        return Colors.blue.shade800; // closest to #366D59
      }),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // text color
    ),
  ),
);
