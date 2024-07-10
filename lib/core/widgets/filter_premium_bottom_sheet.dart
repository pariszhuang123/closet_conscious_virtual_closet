import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../generated/l10n.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/theme/my_outfit_theme.dart';

class PremiumFilterBottomSheet extends StatefulWidget {
  final bool isFromMyCloset;

  const PremiumFilterBottomSheet({super.key, required this.isFromMyCloset});

  @override
  PremiumFilterBottomSheetState createState() => PremiumFilterBottomSheetState();
}

class PremiumFilterBottomSheetState extends State<PremiumFilterBottomSheet> {
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
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
                Flexible(
                  child: Text(
                    S.of(context).filterSearchPremiumFeature,
                    style: theme.textTheme.titleMedium,
                  ),
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
                onPressed: _isButtonDisabled
                    ? null
                    : () async {
                  setState(() {
                    _isButtonDisabled = true;
                  });

                  try {
                    final data = await Supabase.instance.client.rpc(
                      'increment_filter_request',
                    ).single();

                    if (data['status'] != 'success') {
                      throw Exception(data['message']);
                    }

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).interestAcknowledged),
                        ),
                      );
                      Navigator.pop(context); // Navigate back to the previous screen
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.of(context).errorIncrement),
                        ),
                      );
                    }
                  } finally {
                    setState(() {
                      _isButtonDisabled = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  backgroundColor: colorScheme.primary,
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
