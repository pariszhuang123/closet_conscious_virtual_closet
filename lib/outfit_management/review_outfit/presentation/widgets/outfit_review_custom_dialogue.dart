import '../../../../core/utilities/routes.dart';
import 'package:flutter/material.dart';
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
      if (mounted) {  // Check if the widget is still mounted
        Navigator.of(context).pushReplacementNamed(AppRoutes.reviewOutfit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Disable interactions and show the custom dialog
    return AbsorbPointer(
      absorbing: true, // Absorb all interactions
      child: CustomAlertDialog(
        title: S.of(context).outfitReviewTitle,
        content: S.of(context).outfitReviewContent,
        theme: widget.theme,
      ),
    );
  }
}
