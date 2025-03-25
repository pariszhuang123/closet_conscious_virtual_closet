import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


final ThemeData myOutfitTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.blueAccent,
  ).copyWith(
    primary: Colors.purple.shade700, // Dark blue for primary
    onPrimary: Colors.lime.shade50,
    primaryContainer: Colors.purple.shade700, // Darker blue for primary container
    secondary: Colors.purple.shade300, // Light blue for secondary
    onSecondary: Colors.blueGrey.shade900,
    secondaryContainer: Colors.blueAccent.shade100,
    surface: Colors.lime.shade50,
    onSurface: Colors.purple.shade700,
    error: Colors.red.shade700,
    onError: Colors.lime.shade50,
  ),
  dividerColor: Colors.purple.shade700,

  textTheme: TextTheme(
    bodyMedium: GoogleFonts.averageSans(fontSize: 14, fontWeight: FontWeight.normal, color: const Color(0xFF263238)), // Medium body text
    displayLarge: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF263238)), // Largest headline
    titleMedium: GoogleFonts.openSans(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF263238)), // Medium-emphasis text
    bodySmall: GoogleFonts.averageSans(fontSize: 12, fontWeight: FontWeight.normal, color: const Color(0xFFEF9A9A)), // Medium body text
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade100,
    selectedColor: Colors.purple.shade700, // Dark blue for selected chip
    disabledColor: Colors.grey,
    secondarySelectedColor: Colors.purple.shade100, // Darker light blue for secondary selected chip
    padding: const EdgeInsets.all(4.0),
    shape: const StadiumBorder(),
    labelStyle: const TextStyle(color: Colors.black87),
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.purple.shade100, // Light blue for AppBar
    foregroundColor: Colors.black87,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.purple.shade100, // Light blue for Drawer
    elevation: 16.0,
  ),

  iconTheme: IconThemeData(
    color: Colors.purple.shade700, // Align with primary or desired color
    size: 24, // Optional, you can adjust icon size as needed
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.purple.shade100, // Light blue for BottomNavigationBar
    selectedItemColor: Colors.purple.shade700, // Darker blue for selected item
    unselectedItemColor: Colors.grey,
  ),
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: Colors.purple.shade100, // Custom color for myClosetTheme tooltips
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      color: Colors.black87, // Custom text color for myClosetTheme tooltips
      fontSize: 14,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.purple.shade100, // Set the background color for SnackBar
    contentTextStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold), // Set the text color and style
  ),
  dialogTheme: DialogTheme(
    backgroundColor: Colors.purple.shade100,
    titleTextStyle: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.bold),
    contentTextStyle: TextStyle(color: Colors.purple.shade600),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return Colors.purple.shade700; // closest to #255743
        }
        return Colors.purple.shade600; // closest to #366D59
      }),
      foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // text color
    ),
  ),
);
