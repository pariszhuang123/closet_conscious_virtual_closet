import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // To open URLs
import 'dart:io' show Platform;
import '../../../../generated/l10n.dart';  // Localization import
import '../../../../core/utilities/logger.dart';  // Import CustomLogger

class UpdateRequiredPage extends StatelessWidget {
  static final CustomLogger logger = CustomLogger('UpdateRequiredPage');  // Initialize logger

  const UpdateRequiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);  // Get current theme for styling
    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).update_required_title),  // Localized title
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                S.of(context).update_required_content,  // Localized content
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),  // Add spacing
              ElevatedButton(
                onPressed: () {
                  _launchAppStore(context);
                },
                child: Text(S.of(context).update_button_text),  // Localized button text
              ),
            ],
          ),
        ),
      ),
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
