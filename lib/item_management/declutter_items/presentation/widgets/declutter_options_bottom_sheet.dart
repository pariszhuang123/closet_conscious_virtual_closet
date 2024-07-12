import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../../../../generated/l10n.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/theme/my_outfit_theme.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/Feedback/custom_alert_dialog.dart'; // Import the custom alert dialog
import '../../../../core/utilities/routes.dart';
import '../../../../core/data/type_data.dart'; // Import the type_data.dart file

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
          _showCustomDialog(S.of(context).thankYou, S.of(context).declutterAcknowledged);
        } else {
          _showCustomDialog(S.of(context).error, S.of(context).unexpectedResponseFormat);
        }
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      if (mounted) {
        _showCustomDialog(S.of(context).error, S.of(context).unexpectedErrorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  void _showCustomDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          buttonText: S.of(context).ok,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushNamed(context, AppRoutes.myCloset);
          },
          theme: widget.isFromMyCloset ? myClosetTheme : myOutfitTheme,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the theme and colors based on originating page
    ThemeData theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    ColorScheme colorScheme = theme.colorScheme;

    final declutterSellOptions = TypeDataList.declutterOptionsSell(context);
    final declutterSwapOptions = TypeDataList.declutterOptionsSwap(context);
    final declutterGiftOptions = TypeDataList.declutterOptionsGift(context);
    final declutterThrowOptions = TypeDataList.declutterOptionsThrow(context);

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
                    label: declutterSellOptions[0].getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_sold'),
                    imagePath: declutterSellOptions[0].imagePath!,
                  ),
                  NavigationTypeButton(
                    label: declutterSwapOptions[0].getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_swapped'),
                    imagePath: declutterSwapOptions[0].imagePath!,
                  ),
                  NavigationTypeButton(
                    label: declutterGiftOptions[0].getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_gifted'),
                    imagePath: declutterGiftOptions[0].imagePath!,
                  ),
                  NavigationTypeButton(
                    label: declutterThrowOptions[0].getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _handleButtonPress('increment_items_thrown'),
                    imagePath: declutterThrowOptions[0].imagePath!,
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
