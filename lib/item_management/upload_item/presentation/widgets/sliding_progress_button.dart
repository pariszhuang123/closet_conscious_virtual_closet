import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';


class SlidingProgressButton extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSubmit;
  final bool isUploadingItem;  // Pass the loading state from the Bloc
  final int totalSteps;
  final ThemeData myClosetTheme;
  final int currentPage;  // Track current page (or step)

  const SlidingProgressButton({
    super.key,
    required this.onNext,
    required this.onSubmit,
    required this.isUploadingItem,  // Loading state provided by the Bloc
    required this.myClosetTheme,
    required this.currentPage,
    this.totalSteps = 3,
  });

  // Define button text based on the current step using S.of(context) for localization
  String _buttonText(BuildContext context) {
    return currentPage < totalSteps - 1
        ? S.of(context).next  // Localized "Next"
        : S.of(context).upload;  // Localized "Upload"
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment((currentPage / (totalSteps - 1)) * 2 - 1, 0),  // Slide button
      child: ElevatedButton(
        onPressed: isUploadingItem ? null : (currentPage < totalSteps - 1 ? onNext : onSubmit),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          foregroundColor: isUploadingItem
              ? myClosetTheme.colorScheme.onPrimary.withOpacity(0.5)
              : myClosetTheme.colorScheme.onPrimary,
          backgroundColor: isUploadingItem
              ? myClosetTheme.colorScheme.primary.withOpacity(0.5)  // Dim button during loading
              : myClosetTheme.colorScheme.primary,
          
        ),
        child: isUploadingItem
            ? const SizedBox(
          width: 36.0,
          height: 36.0,
          child: ClosetProgressIndicator(
            size: 24.0,
          ),
        )
            : Text(
          _buttonText(context),
          style: myClosetTheme.textTheme.bodyMedium?.copyWith(
            color: myClosetTheme.colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
