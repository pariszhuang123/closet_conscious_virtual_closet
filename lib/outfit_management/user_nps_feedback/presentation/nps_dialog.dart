import 'package:flutter/material.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';

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
import '../../../core/utilities/app_router.dart';
import '../../../core/widgets/button/themed_elevated_button.dart';

class NpsDialog extends StatefulWidget {
  final int milestone;

  const NpsDialog({super.key, required this.milestone});

  /// Static method to show dialog and handle score submission
  static Future<void> show(BuildContext context, int milestone) async {
    final logger = CustomLogger('NPSDialogLogger');
    final outfitSaveService = outfitLocator<OutfitSaveService>();
    final appStoreReview = AppStoreReview();

    Future<void> handleScore(int score) async {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        logger.e('User ID is null, cannot send NPS score.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            S.of(context).unableToRetrieveUserId,
            style: myOutfitTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: myOutfitTheme.snackBarTheme.backgroundColor,
        ));
        return;
      }

      logger.i('Sending NPS score: $score for milestone: $milestone and user ID: $userId');

      final success = await outfitSaveService.recordUserReview(
        userId: userId,
        score: score,
        milestone: milestone,
      );

      if (!context.mounted) return;

      if (success) {
        logger.i('NPS score successfully recorded.');
        if (Platform.isIOS) {
          logger.i('Launching email for iOS.');
          launchEmail(context, EmailType.npsReview);
          // Wait for resume — handled in State class via _npsWasSubmitted
        } else if (Platform.isAndroid) {
          if (score >= 9) {
            await appStoreReview.startReviewFlow(context);
          } else {
            launchEmail(context, EmailType.npsReview);
          }
          if (context.mounted) {
            context.goNamed(AppRoutesName.createOutfit);
          }
        }
      } else {
        logger.e('Failed to record NPS score.');
        CustomSnackbar(
          message: S.of(context).failedToSubmitScore,
          theme: myOutfitTheme,
        ).show(context);
      }
    }

    await CustomAlertDialog.showCustomDialog(
      context: context,
      title: S.of(context).recommendClosetConscious,
      theme: myOutfitTheme,
      barrierDismissible: false,
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).npsExplanation,
              style: myOutfitTheme.textTheme.bodyMedium,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 2.5,
                ),
                itemCount: 11,
                itemBuilder: (context, index) {
                  return ThemedElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // Close dialog
                      await handleScore(index);
                    },
                    text: index.toString(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<NpsDialog> createState() => _NpsDialogState();
}

class _NpsDialogState extends State<NpsDialog> with WidgetsBindingObserver {
  bool _npsWasSubmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _npsWasSubmitted = true; // We know this screen exists only after submit
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _npsWasSubmitted) {
      if (mounted) {
        context.goNamed(AppRoutesName.createOutfit);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Not used, dialog handles everything
  }
}
