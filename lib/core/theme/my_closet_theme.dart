import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData myClosetTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.teal,
    accentColor: Colors.tealAccent,
  ).copyWith(
    primary: Colors.teal.shade900, // Closest to #366D59
    onPrimary: Colors.lime.shade50,
    primaryContainer: Colors.teal.shade900, // Closest to #255743
    secondary: Colors.teal.shade500, // Closest to #A0D6B4
    onSecondary: Colors.blueGrey.shade900,
    secondaryContainer: Colors.teal.shade100,
    surface: Colors.lime.shade50,
    onSurface: Colors.teal.shade900,
    error: Colors.red.shade200,
    onError: Colors.lime.shade50,
  ),
  dividerColor: Colors.teal.shade900,

  textTheme: TextTheme(
      bodyMedium: GoogleFonts.averageSans(fontSize: 14, fontWeight: FontWeight.normal, color: const Color(0xFF263238)), // Medium body text
      displayLarge: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF263238)), // Largest headline
      titleMedium: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF263238)), // Medium-emphasis text
      bodySmall: GoogleFonts.averageSans(fontSize: 12, fontWeight: FontWeight.normal, color: const Color(0xFFEF9A9A)), // Medium body text
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
