import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart'; // Import localization if needed
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';
import '../../../utilities/routes.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isFromMyCloset; // Determines which theme to use

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.isFromMyCloset,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0 && currentIndex != 0) {
      // Navigate only if not already on this tab
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.myCloset,
        arguments: {'isFromMyCloset': true},
      );
    } else if (index == 1 && currentIndex != 1) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.createOutfit,
        arguments: {'isFromMyCloset': false},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.dry_cleaning),
          label: S.of(context).myClosetTitle,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.wc_outlined),
          label: S.of(context).myOutfitTitle,
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      onTap: (index) => _onItemTapped(context, index), // Handles navigation internally
    );
  }
}
