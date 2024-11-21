import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

import '../../../core/utilities/logger.dart';
import '../../../core/utilities/routes.dart'; // Import your app routes

class AppStoreReview {
  final CustomLogger logger = CustomLogger('AppStoreReviewLogger');

  AppStoreReview();

  Future<void> startReviewFlow(BuildContext context) async {
    if (!context.mounted) {
      logger.i('Context is no longer mounted, returning.');
      return;
    }

    logger.i('Redirecting directly to store review...');
    if (context.mounted) {
      _redirectToStoreReview(context);
    }
  }

  void _redirectToStoreReview(BuildContext context) async {
    if (!context.mounted) return;

    Uri uri;

    if (Platform.isAndroid) {
      uri = Uri.parse(
          "https://play.google.com/store/apps/details?id=com.makinglifeeasie.closetconscious");
    } else if (Platform.isIOS) {
      uri = Uri.parse("https://apps.apple.com/us/app/closet-conscious/id6737871636");
    } else {
      logger.w('Unsupported platform for store review redirection.');
      return;
    }

    logger.i('Launching store review with URL: $uri');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);

      // After async operation, check if context is still valid
      if (context.mounted) {
        _navigateToMyOutfit(context); // Navigate after successfully launching the URL
      } else {
        logger.w('Context is no longer mounted after launching URL.');
      }
    } else {
      logger.e('Could not launch $uri');
    }
  }

  void _navigateToMyOutfit(BuildContext context) {
    if (context.mounted) {
      logger.i('Navigating to my_outfit.dart...');
      Navigator.of(context).pushReplacementNamed(AppRoutes.createOutfit);
    } else {
      logger.w('Context is no longer mounted, cannot navigate.');
    }
  }
}