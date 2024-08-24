import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'dart:io' show Platform;

import '../../../core/widgets/webview_screen.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/core_service_locator.dart'; // Import the core service locator
import '../../../core/utilities/routes.dart';
import '../../../generated/l10n.dart'; // Import localization

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
      logger.i('Checking if in-app review is available...');
      final isAvailable = await inAppReview.isAvailable();
      logger.i('In-app review availability: $isAvailable');

      if (isAvailable && context.mounted) {
        logger.i('Requesting in-app review...');
        await inAppReview.requestReview();
        reviewRequested = true;
        logger.i('In-app review requested successfully.');
      } else {
        logger.w('In-app review is not available.');
      }
    } catch (e) {
      logger.e('In-app review failed: $e');
    }

    // Immediately return if the context is no longer mounted
    if (!context.mounted) return;

    if (!reviewRequested) {
      logger.i('Review not shown, redirecting to store review...');
      _redirectToStoreReview(context);
    } else {
      // Optionally wait a short while to ensure review was not suppressed
      await Future.delayed(const Duration(seconds: 3));

      if (context.mounted) {
        logger.i('Checking if user was prompted to review...');
        // If feedback or user interaction suggests review was not shown, proceed with redirect
        _redirectToStoreReview(context);
      }
    }

    if (context.mounted) {
      logger.i('Navigating back to createOutfit after successful in-app review.');
      _navigateToCreateOutfit(context);
    }
  }

  void _redirectToStoreReview(BuildContext context) {
    String url;
    String title;

    if (Platform.isAndroid) {
      url = S.of(context).androidAppStoreUrl;
      title = S.of(context).androidAppStoreTitle;
    } else if (Platform.isIOS) {
      // Fetch the localized App Store URL and title using S.of(context)
      url = S.of(context).iosAppStoreUrl;
      title = S.of(context).iosAppStoreTitle;
    } else {
      logger.w('Unsupported platform for store review redirection.');
      return;
    }

    logger.i('Opening store review in WebView with URL: $url');
    _openWebView(context, url, title);
  }

  void _openWebView(BuildContext context, String url, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          isFromMyCloset: false, // or true, depending on your logic
          title: title, // Pass the title to the WebViewScreen
        ),
      ),
    ).then((result) {
      // This block should only execute after the WebView is closed by the user
      if (context.mounted) {
        logger.i('User closed the store review WebView, navigating back to createOutfit.');
        _navigateToCreateOutfit(context);
      }
    }).catchError((error) {
      logger.e('Failed to open WebView for store review: $error');
    });
  }

  void _navigateToCreateOutfit(BuildContext context) {
    if (context.mounted) {
      logger.i('Navigating to createOutfit...');
      Navigator.of(context).pushReplacementNamed(AppRoutes.createOutfit);
    } else {
      logger.w('Context is no longer mounted, cannot navigate.');
    }
  }
}
