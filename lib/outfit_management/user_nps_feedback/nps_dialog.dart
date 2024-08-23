import 'package:flutter/material.dart';

import '../../core/core_service_locator.dart'; // Import the core service locator
import '../../core/utilities/logger.dart'; // Import your custom logger
import '../../user_management/user_service_locator.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart'; // Import AuthBloc from your authentication module
import '../../core/theme/my_outfit_theme.dart'; // Import the custom theme
import '../../core/utilities/launch_email.dart';
import '../core/data/services/outfits_save_service.dart';
import '../outfit_service_locator.dart';

class NpsDialog extends StatelessWidget {
  final int milestone;
  final CustomLogger logger = coreLocator.get<CustomLogger>(instanceName: 'OutfitReviewViewLogger');
  final OutfitSaveService outfitSaveService = getIt<OutfitSaveService>();

  NpsDialog({super.key, required this.milestone});

  Future<void> _sendNpsScore(BuildContext context, int score) async {
    final AuthBloc authBloc = locator<AuthBloc>(); // Retrieve AuthBloc instance
    final String? userId = authBloc.userId; // Get the user ID

    if (userId == null) {
      logger.e('User ID is null, cannot send NPS score.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Unable to retrieve user ID. Please sign in again.',
            style: myOutfitTheme.snackBarTheme.contentTextStyle, // Apply the text style
          ),
          backgroundColor: myOutfitTheme.snackBarTheme.backgroundColor, // Set the background color
        ));
      }
      return;
    }

    logger.i('Sending NPS score: $score for milestone: $milestone and user ID: $userId');
    bool success = await outfitSaveService.recordUserReview(
      userId: userId,
      score: score,
      milestone: milestone,
    );

    if (!context.mounted) return;

    if (success) {
      logger.i('NPS score successfully recorded.');
      if (score <= 8) {
        launchEmail(context, EmailType.npsReview); // Trigger email feedback for scores 0-8
      } else {
        _showThankYouDialog(context); // Show a thank you dialog for scores 9-10
      }
    } else {
      logger.e('Failed to record NPS score.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to submit score.',
          style: myOutfitTheme.snackBarTheme.contentTextStyle, // Apply the text style
        ),
        backgroundColor: myOutfitTheme.snackBarTheme.backgroundColor, // Set the background color
      ));
    }
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank you!', style: myOutfitTheme.dialogTheme.titleTextStyle),
          content: Text('We appreciate your feedback.', style: myOutfitTheme.dialogTheme.contentTextStyle),
          backgroundColor: myOutfitTheme.dialogTheme.backgroundColor,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: myOutfitTheme.textTheme.labelLarge),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button dismissal
      child: Dialog(
        backgroundColor: myOutfitTheme.dialogTheme.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How likely will you recommend Closet Conscious to a friend?",
                style: myOutfitTheme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 buttons per row
                  crossAxisSpacing: 6.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 2, // Adjust button size as needed
                ),
                itemCount: 11, // Buttons 0 to 10
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () => _sendNpsScore(context, index),
                    style: myOutfitTheme.elevatedButtonTheme.style,
                    child: Text(
                      index.toString(),
                      style: myOutfitTheme.textTheme.labelLarge,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showNpsDialog(BuildContext context, int milestone) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissal by tapping outside
    builder: (BuildContext context) {
      return NpsDialog(milestone: milestone);
    },
  );
}
