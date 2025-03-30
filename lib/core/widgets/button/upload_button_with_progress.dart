import 'package:flutter/material.dart';
import '../progress_indicator/closet_progress_indicator.dart';
import '../progress_indicator/outfit_progress_indicator.dart';

class UploadButtonWithProgress extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final bool isFromMyCloset; // ← use this to switch indicators

  const UploadButtonWithProgress({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.text,
    required this.isFromMyCloset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final buttonStyle = ElevatedButton.styleFrom(
      foregroundColor: theme.colorScheme.onPrimary,
      backgroundColor: theme.colorScheme.primary,
      textStyle: theme.textTheme.bodyMedium,
    );

    return SizedBox(
      width: 180,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: isLoading
            ? SizedBox(
          width: 36,
          height: 36,
          child: isFromMyCloset
              ? const ClosetProgressIndicator(size: 24, usePrimary: false)
              : const OutfitProgressIndicator(size: 24, usePrimary: false),
        )
            : Text(text),
      ),
    );
  }
}