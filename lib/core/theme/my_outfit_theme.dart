import 'package:flutter/material.dart';

final ThemeData myOutfitTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent,
  ).copyWith(
    primary: Colors.blue.shade700, // Dark blue for primary
    onPrimary: Colors.white,
    primaryContainer: Colors.blue.shade800, // Darker blue for primary container
    secondary: Colors.blueAccent.shade100, // Light blue for secondary
    onSecondary: Colors.black,
    secondaryContainer: Colors.blueAccent.shade700, // Darker light blue for secondary container
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.grey.shade200,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed) || states.contains(MaterialState.selected)) {
            return Colors.blue.shade800; // Darker blue when pressed
          }
          return Colors.blue.shade700; // Dark blue for default state
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
    backgroundColor: Colors.blueAccent.shade100, // Light blue for AppBar
    foregroundColor: Colors.black,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.blueAccent.shade100, // Light blue for Drawer
    elevation: 16.0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.blueAccent.shade100, // Light blue for BottomNavigationBar
    selectedItemColor: Colors.blue.shade800, // Darker blue for selected item
    unselectedItemColor: Colors.grey,
  ),
);