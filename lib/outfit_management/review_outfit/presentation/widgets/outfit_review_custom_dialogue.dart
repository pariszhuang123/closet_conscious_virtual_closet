import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utilities/app_router.dart';
import '../../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../../generated/l10n.dart';

class OutfitReviewCustomDialog extends StatefulWidget {
  final ThemeData theme;

  const OutfitReviewCustomDialog({
    super.key,
    required this.theme,
  });

  @override
  OutfitReviewCustomDialogState createState() => OutfitReviewCustomDialogState();
}

class OutfitReviewCustomDialogState extends State<OutfitReviewCustomDialog> {
  @override
  void initState() {
    super.initState();

    // Schedule the navigation after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {  // Check if the widgets is still mounted
        Navigator.of(context).pop();
        context.goNamed(
          AppRoutesName.createOutfit,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents back navigation
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          // Do nothing, effectively preventing the back action
        }
      },
      child: AbsorbPointer(
        absorbing: true, // Absorb all interactions
        child: CustomAlertDialog(
          title: S.of(context).outfitReviewTitle,
          content: Text(S.of(context).outfitReviewContent),
          theme: widget.theme,
        ),
      ),
    );
  }
}
