import 'package:flutter/material.dart';

final ThemeData myClosetTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.teal,
    accentColor: Colors.tealAccent,
  ).copyWith(
    primary: Colors.teal.shade900, // Closest to #366D59
    onPrimary: Colors.lime.shade50,
    primaryContainer: Colors.teal.shade100, // Closest to #255743
    secondary: Colors.teal.shade500, // Closest to #A0D6B4
    onSecondary: Colors.black87,
    secondaryContainer: Colors.teal.shade100,
    surface: Colors.lime.shade50,
    onSurface: Colors.teal.shade900,
    error: Colors.red.shade200,
    onError: Colors.lime.shade50,
  ),
  dividerColor: Colors.teal.shade900,

  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), // Larger body text
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black87), // Medium body text
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black), // Largest headline
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87), // Second largest headline
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), // Medium-emphasis text
    titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87), // Smaller medium-emphasis text
    bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black87, fontStyle: FontStyle.italic), // Caption text
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), // Text for buttons
    labelSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.black87), // Overline text
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade100,
    selectedColor: Colors.teal.shade900, // Closest to #366D59
    disabledColor: Colors.grey,
    secondarySelectedColor: Colors.lightGreen.shade700, // Closest to #88B69C
    padding: const EdgeInsets.all(4.0),
    shape: const StadiumBorder(),
    labelStyle: const TextStyle(color: Colors.black),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.teal.shade100,  // Closest to #A0D6B4
    foregroundColor: Colors.black87,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.teal.shade100, // Closest to #A0D6B4
    elevation: 16.0,
  ),

  iconTheme: IconThemeData(
    color: Colors.teal.shade900, // Align with primary or desired color
    size: 24, // Optional, you can adjust icon size as needed
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.teal.shade100, // Closest to #A0D6B4
    selectedItemColor: Colors.teal.shade900, // Closest to #255743
    unselectedItemColor: Colors.grey,
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: Colors.teal.shade100, // Custom color for myClosetTheme tooltips
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      color: Colors.black87, // Custom text color for myClosetTheme tooltips
      fontSize: 14,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.teal.shade100, // Set the background color for SnackBar
    contentTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold), // Set the text color and style
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.teal.shade100,
    titleTextStyle: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: Colors.teal.shade900),
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
