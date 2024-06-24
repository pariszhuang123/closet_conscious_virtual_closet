import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/theme/my_outfit_theme.dart';

class PremiumFilterBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const PremiumFilterBottomSheet({super.key, required this.isFromMyCloset});


  @override
  Widget build(BuildContext context) {
    // Determine the theme and colors based on originating page
    ThemeData theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).filterSearchPremiumFeature,
                  style: theme.textTheme.titleMedium, // Apply titleMedium style
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onBackground),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              S.of(context).quicklyFindItems,
              style: theme.textTheme.bodyMedium, // Apply bodyMedium style
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle user interest in the premium feature
                  Navigator.pop(context); // Close the bottom sheet
                  // You can add further logic here to navigate to the purchase page or show more details
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary, backgroundColor: colorScheme.primary,
                ),
                child: Text(S.of(context).interested, style: theme.textTheme.labelLarge), // Apply labelLarge text style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
