import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // To open URLs
import 'dart:io' show Platform;

import '../../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../../generated/l10n.dart';  // Localization import
import '../../../../core/utilities/logger.dart';  // Import CustomLogger

class UpdateRequiredDialog {
  static final CustomLogger logger = CustomLogger('UpdateRequiredDialog');  // Initialize logger

  static Future<void> show({
    required BuildContext context,
    required ThemeData theme,
    required VoidCallback onUpdatePressed,
  }) async {
    logger.i('Showing UpdateRequiredDialog');  // Log when dialog is shown

    // Using CustomAlertDialog.showCustomDialog and making it non-dismissible
    return CustomAlertDialog.showCustomDialog(
      context: context,
      title: S.of(context).update_required_title,  // Localized title
      content: Text(S.of(context).update_required_content),  // Localized content
      buttonText: S.of(context).update_button_text,  // Localized button text
      onPressed: () {
        // Open the app store URL based on the platform
        _launchAppStore(context);
      },
      theme: theme,
      barrierDismissible: false,  // Prevent dismissing by tapping outside or pressing back
    );
  }

  // Method to handle platform-based redirection to the app stores
  static void _launchAppStore(BuildContext context) async {
    Uri uri;
    try {
      if (Platform.isAndroid) {
        uri = Uri.parse(
            "https://play.google.com/store/apps/details?id=com.makinglifeeasie.closetconscious");
        logger.i('Platform is Android. Redirecting to Play Store.');
      } else if (Platform.isIOS) {
        uri = Uri.parse("https://apps.apple.com/us/app/id1542311809");
        logger.i('Platform is iOS. Redirecting to App Store.');
      } else {
        logger.w('Unsupported platform for store redirection.');
        return;
      }

      // Log the URL before launching
      logger.i('Launching AppStore with URL: $uri');

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        logger.i('Successfully launched the app store URL.');
      } else {
        logger.e('Failed to launch the app store URL: $uri');
      }
    } catch (e) {
      logger.e('Error occurred during store redirection: $e');
    }
  }
}
