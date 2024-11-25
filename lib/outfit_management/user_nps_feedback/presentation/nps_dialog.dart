import 'package:flutter/material.dart';
import 'dart:io';

import '../../../core/utilities/logger.dart';
import '../../../user_management/user_service_locator.dart';
import '../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/theme/my_outfit_theme.dart';
import '../../../core/core_enums.dart';
import '../../../core/utilities/launch_email.dart';
import '../../core/data/services/outfits_save_services.dart';
import '../../outfit_service_locator.dart';
import 'app_store_review.dart';
import '../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../generated/l10n.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/widgets/button/themed_elevated_button.dart';


class NpsDialog extends StatelessWidget {
  final int milestone;
  final CustomLogger logger = CustomLogger('NPSDialogLogger');
  final OutfitSaveService outfitSaveService = getIt<OutfitSaveService>();
  final AppStoreReview appStoreReview = AppStoreReview(); // Updated to use the new AppStoreReview class

  NpsDialog({super.key, required this.milestone});

  Future<void> _sendNpsScore(BuildContext context, int score) async {
    final AuthBloc authBloc = locator<AuthBloc>();
    final String? userId = authBloc.userId;

    if (userId == null) {
      logger.e('User ID is null, cannot send NPS score.');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            S.of(context).unableToRetrieveUserId,
            style: myOutfitTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: myOutfitTheme.snackBarTheme.backgroundColor,
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
      if (Platform.isIOS) {
        // For iOS, launch email regardless of score
        logger.i('Launching email for iOS.');
        launchEmail(context, EmailType.npsReview);
      } else if (Platform.isAndroid) {
        // For Android, follow app store review logic
        if (score >= 9) {
          await appStoreReview.startReviewFlow(context);
        } else {
          launchEmail(context, EmailType.npsReview);
        }
      }
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.createOutfit);
      }

    } else {
      logger.e('Failed to record NPS score.');
      CustomSnackbar(
        message: S.of(context).failedToSubmitScore,
        theme: myOutfitTheme,
      ).show(context);
    }
  }

  // Use this method to trigger the dialog
  Future<void> showNpsDialog(BuildContext context) async {
    return await CustomAlertDialog.showCustomDialog(
      context: context,
      title: S.of(context).recommendClosetConscious,
      content: _buildDialogContent(context),
      theme: myOutfitTheme,
      barrierDismissible: false,
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return SizedBox(
      width: 300, // Maintain the fixed width
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).npsExplanation,
            style: myOutfitTheme.textTheme.bodyMedium, // Adjust style as needed
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16.0),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true, // Ensures the GridView only takes up the space it needs
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 buttons per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 20.0,
                childAspectRatio: 2.5, // Adjust button size as needed
              ),
              itemCount: 11, // Fixed number of buttons
              itemBuilder: (context, index) {
                return ThemedElevatedButton( // Use ThemedElevatedButton here
                  onPressed: () => _sendNpsScore(context, index),
                  text: index.toString(), // Pass the index as text
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty Container or any Widget you desire
    return Container();
  }
}
