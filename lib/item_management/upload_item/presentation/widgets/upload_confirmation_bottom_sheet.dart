import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/utilities/app_router.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/theme/my_outfit_theme.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../../core/data/services/core_save_services.dart';
import '../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/achievement_celebration/helper/achievement_navigator.dart';

class UploadConfirmationBottomSheet extends StatefulWidget {
  final bool isFromMyCloset;

  const UploadConfirmationBottomSheet({super.key, required this.isFromMyCloset});

  @override
  UploadConfirmationBottomSheetState createState() => UploadConfirmationBottomSheetState();
}

class UploadConfirmationBottomSheetState extends State<UploadConfirmationBottomSheet> {
  bool _isButtonDisabled = false;
  final logger = CustomLogger('UploadConfirmation');
  late final CoreSaveService coreSaveService;


  void _handleButtonClick() {
    // Handle button click state, disable button
    setState(() {
      _isButtonDisabled = true;
    });

    // Call the function to save the result
    _saveAchievementBadge();
  }

  Future<void> _saveAchievementBadge() async {
    coreSaveService = CoreSaveService(); // Initialize without passing logger

    try {
      final response = await coreSaveService.saveAchievementBadge('closet_uploaded'); // Use the service

      if (!mounted) return;

      if (response != null && response['status'] == 'success') {
        final achievementUrl = response['badge_url'];

        if (achievementUrl != null) {
          handleAchievementNavigationWithTheme(
            context: context,
            achievementKey: 'closet_uploaded',
            badgeUrl: achievementUrl,
            nextRoute: AppRoutesName.myCloset,
            isFromMyCloset: widget.isFromMyCloset,
          );
        } else {
          _showCustomDialog(S.of(context).error,
              Text(S.of(context).unexpectedResponseFormat));
        }
      } else {
        _showCustomDialog(S.of(context).error,
            Text(S.of(context).unexpectedResponseFormat));
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
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          buttonText: S.of(context).ok,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          theme: widget.isFromMyCloset ? myClosetTheme : myOutfitTheme,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    ColorScheme colorScheme = theme.colorScheme;

    return Theme(
      data: theme,
      child: Container(
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
                      S.of(context).uploadConfirmationTitle,
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
                S.of(context).uploadConfirmationDescription,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ThemedElevatedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : _handleButtonClick,
                  text: S.of(context).confirmUpload,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
