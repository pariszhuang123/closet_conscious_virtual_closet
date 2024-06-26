import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../generated/l10n.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/theme/my_outfit_theme.dart';

class PremiumFilterBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const PremiumFilterBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
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
                  S.of(context).filterSearchPremiumFeature,
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              S.of(context).quicklyFindItems,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final userId = Supabase.instance.client.auth.currentUser!.id;
                  try {
                    final response = await Supabase.instance.client.rpc(
                      'increment_filter_request',
                      params: {'user_id': userId},
                    );

                    if (response.error != null) {
                      throw Exception(response.error!.message);
                    }

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(S.of(context).thankYou),
                            content: Text(S.of(context).interestAcknowledged),
                            actions: <Widget>[
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
                    }

                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Failed to increment filter request: $e'),
                      ));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary, backgroundColor: colorScheme.primary,
                ),
                child: Text(S.of(context).interested, style: theme.textTheme.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
