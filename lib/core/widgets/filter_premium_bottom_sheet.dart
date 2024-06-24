import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/theme/my_outfit_theme.dart';

class PremiumFilterBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const PremiumFilterBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    // Determine colors based on originating page
    ColorScheme colorScheme = isFromMyCloset ? myClosetTheme.colorScheme : myOutfitTheme.colorScheme;

    return Container(
      color: colorScheme.background,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).filterSearchPremiumFeature,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
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
            style: TextStyle(fontSize: 16, color: colorScheme.onBackground),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Handle user interest in the premium feature
              Navigator.pop(context); // Close the bottom sheet
              // You can add further logic here to navigate to the purchase page or show more details
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: colorScheme.onPrimary, backgroundColor: colorScheme.primary,
            ),
            child: Text(S.of(context).interested),
          ),
        ],
      ),
    );
  }
}
