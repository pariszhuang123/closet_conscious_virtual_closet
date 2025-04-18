import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/theme/my_outfit_theme.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../../core/utilities/app_router.dart';
import '../../../../core/data/type_data.dart';
import '../../../core/data/services/item_save_service.dart';

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
  late final ItemSaveService itemSaveService;

  @override
  void initState() {
    super.initState();
    itemSaveService = ItemSaveService(); // Initialize the service
  }

  Future<void> _handleButtonPress(String rpcName) async {
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      final response = await itemSaveService.handleDeclutterAction(rpcName, widget.currentItemId);

      logger.i('Full response: ${jsonEncode(response)}');

      if (!mounted) return;

      if (response != null && response.containsKey('status')) {
        if (response['status'] == 'success') {
          _showCustomDialog(S.of(context).thankYou,
              Text(S.of(context).declutterAcknowledged));
        } else {
          _showCustomDialog(S.of(context).error,
              Text(S.of(context).unexpectedResponseFormat));
        }
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      if (mounted) {
        _showCustomDialog(S.of(context).error,
            Text(S.of(context).unexpectedErrorOccurred));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  void _showCustomDialog(String title, Widget content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          buttonText: S.of(context).ok,
          onPressed: () {
            Navigator.of(context).pop();
            context.pushNamed(AppRoutesName.myCloset);
          },
          theme: widget.isFromMyCloset ? myClosetTheme : myOutfitTheme,
        );
      },
    );
  }

  void _confirmAction(String rpcName) {
    String title = S.of(context).areYouSure;
    String message;

    if (rpcName == 'increment_items_thrown') {
      message = S.of(context).declutterThrowWarning; // Specific warning for throwing items
    } else {
      message = S.of(context).declutterGenericWarning; // Generic warning for the other actions
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return CustomAlertDialog(
          title: title,
          content: Text(message),
          buttonText: S.of(dialogContext).confirm,
          onPressed: () {
            Navigator.of(dialogContext).pop();
            _handleButtonPress(rpcName);
          },
          theme: widget.isFromMyCloset ? myClosetTheme : myOutfitTheme,
          iconButton: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Pop dialog
              Navigator.of(context).pop(); // Pop previous screen
            },
          ),
          canPop: true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the theme and colors based on originating pages
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
                    label: declutterSellOptions.getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _confirmAction('increment_items_sold'),
                    assetPath: declutterSellOptions.assetPath, // Ensure non-nullable
                    isFromMyCloset: widget.isFromMyCloset,
                    buttonType: ButtonType.primary,
                    usePredefinedColor: false,
                  ),
                  NavigationTypeButton(
                    label: declutterSwapOptions.getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _confirmAction('increment_items_swapped'),
                    assetPath: declutterSwapOptions.assetPath,
                    isFromMyCloset: widget.isFromMyCloset,
                    buttonType: ButtonType.primary,
                    usePredefinedColor: false,
                  ),
                  NavigationTypeButton(
                    label: declutterGiftOptions.getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _confirmAction('increment_items_gifted'),
                    assetPath: declutterGiftOptions.assetPath,
                    isFromMyCloset: widget.isFromMyCloset,
                    buttonType: ButtonType.primary,
                    usePredefinedColor: false,
                  ),
                  NavigationTypeButton(
                    label: declutterThrowOptions.getName(context),
                    selectedLabel: '',
                    onPressed: _isButtonDisabled ? null : () => _confirmAction('increment_items_thrown'),
                    assetPath: declutterThrowOptions.assetPath,
                    isFromMyCloset: widget.isFromMyCloset,
                    buttonType: ButtonType.primary,
                    usePredefinedColor: false,
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
