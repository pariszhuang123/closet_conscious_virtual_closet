import 'package:flutter/material.dart';

import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';

class ArchiveBottomSheet extends StatefulWidget {
  final ThemeData theme;
  final String closetId; // Closet ID to be passed for the archive action

  const ArchiveBottomSheet({
    super.key,
    required this.theme,
    required this.closetId,
  });

  @override
  ArchiveBottomSheetState createState() => ArchiveBottomSheetState();
}

class ArchiveBottomSheetState extends State<ArchiveBottomSheet> {
  final ItemSaveService itemSaveService = ItemSaveService(); // Initialize service
  bool _isButtonDisabled = false; // To prevent multiple presses

  Future<void> _handleArchiveAction() async {
    setState(() {
      _isButtonDisabled = true; // Disable button during the async operation
    });

    try {
      final response = await itemSaveService.handleArchiveAction(widget.closetId);

      if (!mounted) return;

      if (response != null && response['status'] == 'success') {
        // Show success snackbar
        CustomSnackbar(
          message: S.of(context).archiveSuccessMessage, // Success message
          theme: widget.theme,
        ).show(context);

        // Navigate to myCloset after showing the snackbar
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context); // Close the bottom sheet
            Navigator.pushNamed(context, AppRoutes.myCloset);
          }
        });
      } else {
        // Show error snackbar
        final message = response?['message'] ?? S.of(context).unexpectedResponseFormat;
        CustomSnackbar(
          message: message,
          theme: widget.theme,
        ).show(context);
      }
    } catch (e) {
      if (mounted) {
        // Show unexpected error snackbar
        CustomSnackbar(
          message: S.of(context).unexpectedErrorOccurred,
          theme: widget.theme,
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false; // Re-enable button after operation
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      theme: widget.theme,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).archiveCloset, // Title for the archive feature
                  style: widget.theme.textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(Icons.close, color: widget.theme.colorScheme.onSurface),
                  onPressed: () => Navigator.pop(context), // Close the bottom sheet
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              S.of(context).archiveClosetDescription, // Description for the archive feature
              style: widget.theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24.0),
            Center(
              child: ThemedElevatedButton(
                text: S.of(context).archive, // Archive button text
                onPressed: _isButtonDisabled ? null : _handleArchiveAction, // Directly handle archive
              ),
            ),
          ],
        ),
      ),
    );
  }
}
