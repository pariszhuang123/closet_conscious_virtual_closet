import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';
import '../../feedback/custom_alert_dialog.dart';
import '../../../data/services/core_save_services.dart';
import '../../../widgets/button/themed_elevated_button.dart'; // Import the ThemedElevatedButton


class BasePremiumBottomSheet extends StatefulWidget {
  final bool isFromMyCloset;
  final String title;
  final String description;
  final String rpcFunctionName;

  const BasePremiumBottomSheet({
    super.key,
    required this.isFromMyCloset,
    required this.title,
    required this.description,
    required this.rpcFunctionName,
  });

  @override
  BasePremiumBottomSheetState createState() => BasePremiumBottomSheetState();
}

class BasePremiumBottomSheetState extends State<BasePremiumBottomSheet> {
  bool _isButtonDisabled = false;
  late final CoreSaveService coreSaveService;

  @override
  void initState() {
    super.initState();
    coreSaveService = CoreSaveService(); // Initialize without passing logger
  }

  Future<void> _handleButtonPress() async {
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      final response = await coreSaveService.callSupabaseRpc(
          widget.rpcFunctionName);

      if (!mounted) return;

      if (response['status'] == 'success') {
        _showCustomDialog(S
            .of(context)
            .thankYou, Text(S
            .of(context)
            .interestAcknowledged));
      } else {
        _showCustomDialog(S
            .of(context)
            .error, Text(S
            .of(context)
            .unexpectedResponseFormat));
      }
    } catch (e) {
      if (mounted) {
        _showCustomDialog(S
            .of(context)
            .error, Text(S
            .of(context)
            .unexpectedErrorOccurred));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  void _showCustomDialog(String title, Widget content) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by clicking outside
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          buttonText: S
              .of(context)
              .ok,
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          theme: widget.isFromMyCloset ? myClosetTheme : myOutfitTheme,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return Theme(
      data: theme, // Wrap the widget tree with the selected theme
      child: Container(
        color: theme.colorScheme.surface,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.description,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ThemedElevatedButton(
                  onPressed: _isButtonDisabled ? null : _handleButtonPress,
                  text: S
                      .of(context)
                      .interested,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}