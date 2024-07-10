import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../../../generated/l10n.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/theme/my_outfit_theme.dart';
import '../../core/utilities/logger.dart';
import '../widgets/Feedback/custom_alert_dialog.dart'; // Import the custom alert dialog

class MultiClosetFeatureBottomSheet extends StatefulWidget {
  final bool isFromMyCloset;

  const MultiClosetFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  MultiClosetFeatureBottomSheetState createState() => MultiClosetFeatureBottomSheetState();
}

class MultiClosetFeatureBottomSheetState extends State<MultiClosetFeatureBottomSheet> {
  bool _isButtonDisabled = false;
  final logger = CustomLogger('MultiClosetRequest');

  @override
  Widget build(BuildContext context) {
    // Determine the theme and colors based on originating page
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
                onPressed: _isButtonDisabled
                    ? null
                    : () async {
                  setState(() {
                    _isButtonDisabled = true;
                  });

                  try {
                    final response = await Supabase.instance.client.rpc(
                      'increment_multi_closet_request',
                    ).single();

                    logger.i('Full response: ${jsonEncode(response)}');

                    if (response.containsKey('status')) {
                      if (response['status'] == 'success') {
                        logger.i('Request processed successfully: ${jsonEncode(response)}');
                        if (context.mounted) {
                          Navigator.pop(context); // Close the bottom sheet
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: S.of(context).thankYou,
                                content: S.of(context).interestAcknowledged,
                                buttonText: S.of(context).ok,
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                theme: theme,
                              );
                            },
                          );
                        }
                      } else {
                        logger.e('Unexpected response format: ${jsonEncode(response)}');
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertDialog(
                                title: S.of(context).error,
                                content: S.of(context).unexpectedResponseFormat,
                                buttonText: S.of(context).ok,
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                theme: theme,
                              );
                            },
                          );
                        }
                      }
                    } else {
                      logger.e('Unexpected response: ${jsonEncode(response)}');
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlertDialog(
                              title: S.of(context).error,
                              content: S.of(context).unexpectedResponseFormat,
                              buttonText: S.of(context).ok,
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              theme: theme,
                            );
                          },
                        );
                      }
                    }
                  } catch (e) {
                    logger.e('Unexpected error: $e');
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomAlertDialog(
                            title: S.of(context).error,
                            content: S.of(context).unexpectedErrorOccurred,
                            buttonText: S.of(context).ok,
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            theme: theme,
                          );
                        },
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
                child: Text(S.of(context).interested, style: theme.textTheme.labelLarge), // Apply labelLarge text style
              ),
            ),
          ],
        ),
      ),
    );
  }
}
