import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/widgets/feedback/custom_alert_dialog.dart';
import 'item_qr_code.dart';

void showSwapQrDialog(BuildContext context, String itemId) {
  final theme = myClosetTheme;
  final s = S.of(context);

  CustomAlertDialog.showCustomDialog(
    context: context,
    title: s.swapDialogTitle,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ItemQrCode(itemId: itemId),
        const SizedBox(height: 12),
      ],
    ),
    theme: theme,
    iconButton: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    ),
    barrierDismissible: true,
    canPop: true,
  );
}
