import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:io' show Platform;

import '../../../core/widgets/webview_screen.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/core_service_locator.dart'; // Import the core service locator


class AppStoreReview {
  final InAppReview inAppReview;
  CustomLogger logger = coreLocator.get<CustomLogger>(instanceName: 'AppStoreReviewLogger');

  AppStoreReview({
    required this.inAppReview,
    required this.logger,
  });

  Future<void> tryInAppReview(BuildContext context) async {
    bool reviewRequested = false;

    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
        reviewRequested = true;
      }
    } catch (e) {
      logger.e('In-app review failed: $e');
    }

    if (!reviewRequested && context.mounted) {
      _redirectToStoreReview(context); // Ensure context is still valid
    }
  }

  void _redirectToStoreReview(BuildContext context) {
    String url;
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=com.looko.acloset';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/us/app/acloset-ai-fashion-assistant/id1542311809';
    } else {
      return;
    }

    _openWebView(context, url);
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          isFromMyCloset: false, // or true, depending on your logic
        ),
      ),
    );
  }
}
