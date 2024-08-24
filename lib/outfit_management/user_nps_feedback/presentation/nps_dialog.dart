import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../core/core_service_locator.dart';
import '../../../core/utilities/logger.dart';
import '../../../user_management/user_service_locator.dart';
import '../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/theme/my_outfit_theme.dart';
import '../../../core/utilities/launch_email.dart';
import '../../core/data/services/outfits_save_service.dart';
import '../../outfit_service_locator.dart';
import 'app_store_review.dart';
import '../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../generated/l10n.dart';

class NpsDialog extends StatelessWidget {
  final int milestone;
  final CustomLogger logger = coreLocator.get<CustomLogger>(instanceName: 'OutfitReviewViewLogger');
  final OutfitSaveService outfitSaveService = getIt<OutfitSaveService>();
  final AppStoreReview appStoreReview;

  NpsDialog({super.key, required this.milestone})
      : appStoreReview = AppStoreReview(
    inAppReview: InAppReview.instance,
    logger: coreLocator.get<CustomLogger>(instanceName: 'OutfitReviewViewLogger'),
  );

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
      if (score >= 9) {
        await appStoreReview.tryInAppReview(context);
      } else {
        launchEmail(context, EmailType.npsReview);
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
  void showNpsDialog(BuildContext context) {
    CustomAlertDialog.showCustomDialog(
      context: context,
        title: S.of(context).recommendClosetConscious,
      content: _buildDialogContent(context), // This will be fixed below
      theme: myOutfitTheme,
      barrierDismissible: false,
    );
  }

  // Fixing the type issue
  Widget _buildDialogContent(BuildContext context) {
    return SizedBox(
      width: 300,  // Set a fixed width
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16.0),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 4 buttons per row
              crossAxisSpacing: 10,
              mainAxisSpacing: 20.0,
              childAspectRatio: 2.5, // Adjust button size as needed
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
    );
  }

  @override
  Widget build(BuildContext context) {
    // Return an empty Container or any Widget you desire
    return Container();
  }
}
