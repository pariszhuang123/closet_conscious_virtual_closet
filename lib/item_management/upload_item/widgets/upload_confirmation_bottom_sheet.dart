import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../core/theme/my_closet_theme.dart';
import '../../../core/theme/my_outfit_theme.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../core/screens/achievement_completed_screen.dart';
import '../../../core/data/services/core_save_services.dart';

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


  Future<void> _handleButtonPress() async {
    setState(() {
      _isButtonDisabled = true;
      coreSaveService = CoreSaveService(); // Initialize without passing logger
    });

    try {
      final response = await coreSaveService.saveAchievementBadge('closet_uploaded'); // Use the service

      if (!mounted) return;

      // Check if the response is a Map
      if (response != null && response['status'] == 'success') {
        final achievementUrl = response['badge_url'];

        // Use null-aware access for achievementUrl
        if (achievementUrl != null) {
          _showAchievementScreen(context, achievementUrl);
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

  void _showAchievementScreen(BuildContext context, String achievementUrl) {
    logger.i('Navigating to AchievementScreen with URL: $achievementUrl');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Theme(
          data: widget.isFromMyCloset ? myClosetTheme : myOutfitTheme,
          child: AchievementScreen(
            achievementUrl: achievementUrl,
            isFromMyCloset: widget.isFromMyCloset,
          ),
        ),
      ),
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
                child: ElevatedButton(
                  onPressed: _isButtonDisabled ? null : _handleButtonPress,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary,
                  ),
                  child: Text(S.of(context).confirmUpload, style: theme.textTheme.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
