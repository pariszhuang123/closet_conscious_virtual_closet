import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/theme/my_outfit_theme.dart';

class MultiClosetFeatureBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const MultiClosetFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    // Determine the theme and colors based on originating page
    ThemeData theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
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
                  S.of(context).multiClosetFeatureTitle,
                  style: theme.textTheme.titleMedium, // Apply titleMedium style
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onSurface),
                  onPressed: () {
                    Navigator.pop(context); // Close the bottom sheet
                  },
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              S.of(context).multiClosetFeatureDescription,
              style: theme.textTheme.bodyMedium, // Apply bodyMedium style
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle user interest in the multi-closet feature
                  Navigator.pop(context); // Close the bottom sheet
                  // Logic to express interest
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(S.of(context).thankYou),
                        content: Text(S.of(context).interestAcknowledged),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text(S.of(context).ok),
                          ),
                        ],
                      );
                    },
                  );
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
