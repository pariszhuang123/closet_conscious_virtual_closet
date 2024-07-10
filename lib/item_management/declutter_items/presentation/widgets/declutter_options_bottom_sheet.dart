import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../../../../generated/l10n.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/theme/my_outfit_theme.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/utilities/logger.dart';

class DeclutterBottomSheet extends StatefulWidget {
  final bool isFromMyCloset;
  final String currentItemId;

  const DeclutterBottomSheet({super.key, required this.isFromMyCloset, required this.currentItemId});

  @override
  DeclutterBottomSheetState createState() => DeclutterBottomSheetState();
}

class DeclutterBottomSheetState extends State<DeclutterBottomSheet> {
  bool _isButtonDisabled = false;
  final logger = CustomLogger('DeclutterRequest');

  Future<void> _handleButtonPress(String rpcName) async {
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      final response = await Supabase.instance.client.rpc(
        rpcName,
        params: {'current_item_id': widget.currentItemId},
      ).single();

      logger.i('Full response: ${jsonEncode(response)}');

      if (!mounted) return;

      if (response.containsKey('status')) {
        if (response['status'] == 'success') {
          logger.i('Request processed successfully: ${jsonEncode(response)}');
          Navigator.pop(context); // Close the bottom sheet
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(S.of(context).thankYou),
                content: Text(S.of(context).declutterAcknowledged), // Replace with appropriate localization key
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
        } else {
          logger.e('Unexpected response format: ${jsonEncode(response)}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(S.of(context).error),
                content: Text(S.of(context).unexpectedResponseFormat),
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
        }
      } else {
        logger.e('Unexpected response: ${jsonEncode(response)}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).error),
              content: Text(S.of(context).unexpectedResponseFormat),
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
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).error),
              content: Text(S.of(context).unexpectedErrorOccurred),
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
      }
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

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
                    S.of(context).declutterFeatureTitle, // Replace with appropriate localization key
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
              S.of(context).declutterFeatureDescription, // Replace with appropriate localization key
              style: theme.textTheme.bodyMedium, // Apply bodyMedium style
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavigationTypeButton(
                    label: S.of(context).Sell,
                    selectedLabel: S.of(context).Sell,
                    imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_sold'),
                  ),
                  NavigationTypeButton(
                    label: S.of(context).Swap,
                    selectedLabel: S.of(context).Swap,
                    imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_swapped'),
                  ),
                  NavigationTypeButton(
                    label: S.of(context).Gift,
                    selectedLabel: S.of(context).Gift,
                    imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_gifted'),
                  ),
                  NavigationTypeButton(
                    label: S.of(context).Throw,
                    selectedLabel: S.of(context).Throw,
                    imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_thrown'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
