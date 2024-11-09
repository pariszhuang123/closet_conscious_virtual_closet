import 'package:flutter/material.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../../generated/l10n.dart';

class OutfitCreationSuccessDialog extends StatefulWidget {
  final ThemeData theme;

  const OutfitCreationSuccessDialog({
    super.key,
    required this.theme,
  });

  @override
  OutfitCreationSuccessDialogState createState() => OutfitCreationSuccessDialogState();
}

class OutfitCreationSuccessDialogState extends State<OutfitCreationSuccessDialog> {
  @override
  void initState() {
    super.initState();

    // Schedule the navigation after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {  // Check if the widgets is still mounted
        Navigator.of(context).pushReplacementNamed(AppRoutes.createOutfit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Disable interactions and show the custom dialog
    return AbsorbPointer(
      absorbing: true, // Absorb all interactions
      child: CustomAlertDialog(
        title: S.of(context).outfitCreationSuccessTitle,  // E.g., "Style On!"
        content: Text(S.of(context).outfitCreationSuccessContent),  // E.g., "Outfit ready. Go Slay the World!"
        theme: widget.theme,
      ),
    );
  }
}
