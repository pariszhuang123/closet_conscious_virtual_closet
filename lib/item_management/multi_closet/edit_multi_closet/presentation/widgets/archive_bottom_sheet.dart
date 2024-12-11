import 'package:flutter/material.dart';

import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/widgets/feedback/custom_alert_dialog.dart';
import '../../../../../core/utilities/logger.dart';

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
  late final CustomLogger logger; // Initialize logger
  bool _isButtonDisabled = false; // To prevent multiple presses

  @override
  void initState() {
    super.initState();
    logger = CustomLogger('ArchiveBottomSheet');
    logger.d('Initialized ArchiveBottomSheet with closetId: ${widget.closetId}');
  }

  Future<void> _handleArchiveAction() async {
    setState(() {
      _isButtonDisabled = true; // Disable the button
    });

    try {
      final response = await itemSaveService.handleArchiveAction(widget.closetId);

      logger.i('Response: $response');

      if (!mounted) return;

      if (response != null && response['status'] == 'success') {
        _showCustomDialog(
          title: S.of(context).success,
          message: S.of(context).archiveSuccessMessage,
          onConfirm: () => _navigateToMyCloset(), // Navigate after dialog dismissal
        );
      } else {
        final message = response?['message'] ?? S.of(context).unexpectedResponseFormat;
        _showCustomDialog(
          title: S.of(context).error,
          message: message,
          onConfirm: () => Navigator.pop(context), // Close dialog only
        );
      }
    } catch (e) {
      logger.e('Error: $e');
      if (mounted) {
        _showCustomDialog(
          title: S.of(context).error,
          message: S.of(context).unexpectedErrorOccurred,
          onConfirm: () => Navigator.pop(context), // Close dialog only
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false; // Re-enable the button
        });
      }
    }
  }

  void _showCustomDialog({
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: Text(message),
          buttonText: S.of(context).ok,
          onPressed: onConfirm,
          theme: widget.theme,
        );
      },
    );
  }

  void _navigateToMyCloset() {
    // Close the bottom sheet and navigate to MyCloset
    Navigator.pop(context); // Close dialog
    Navigator.pop(context); // Close the bottom sheet
    Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
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
                  onPressed: () {
                    logger.i('User closed the archive bottom sheet.');
                    Navigator.pop(context); // Close the bottom sheet
                  },
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
                onPressed: _isButtonDisabled
                    ? null
                    : () {
                  logger.d('Archive button pressed.');
                  _handleArchiveAction();
                }, // Directly handle archive
              ),
            ),
          ],
        ),
      ),
    );
  }
}
