import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart'; // Import localization if needed
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';
import '../../../utilities/app_router.dart';

class AnalyticsBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final bool isFromMyCloset; // Determines which theme to use

  const AnalyticsBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.isFromMyCloset,
  });

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0 && currentIndex != 0) {
      // Navigate only if not already on this tab
      context.pushNamed(
        AppRoutesName.summaryItemsAnalytics,
        extra: {'isFromMyCloset': true},
      );
    } else if (index == 1 && currentIndex != 1) {
      context.pushNamed(
        AppRoutesName.summaryOutfitAnalytics,
        extra: {'isFromMyCloset': false},
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
          label: S.of(context).tabItemAnalytics,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.wc_outlined),
          label: S.of(context).tabOutfitAnalytics,
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      onTap: (index) => _onItemTapped(context, index), // Handles navigation internally
    );
  }
}
