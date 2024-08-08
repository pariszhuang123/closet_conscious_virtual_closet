import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

import '../../../../../generated/l10n.dart';
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';
import '../../../utilities/logger.dart';
import '../../feedback/custom_alert_dialog.dart';

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
  late final CustomLogger logger;

  @override
  void initState() {
    super.initState();
    logger = CustomLogger(widget.title);
  }

  Future<void> _handleButtonPress() async {
    setState(() {
      _isButtonDisabled = true;
    });

    try {
      final response = await Supabase.instance.client.rpc(widget.rpcFunctionName).single();

      logger.i('Full response: ${jsonEncode(response)}');

      if (!mounted) return;

      if (response.containsKey('status')) {
        if (response['status'] == 'success') {
          _showCustomDialog(S.of(context).thankYou, S.of(context).interestAcknowledged);
        } else {
          _showCustomDialog(S.of(context).error, S.of(context).unexpectedResponseFormat);
        }
      } else {
        _showCustomDialog(S.of(context).error, S.of(context).unexpectedResponseFormat);
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      if (mounted) {
        _showCustomDialog(S.of(context).error, S.of(context).unexpectedErrorOccurred);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    }
  }

  void _showCustomDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: title,
          content: content,
          buttonText: S.of(context).ok,
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
    ColorScheme colorScheme = theme.colorScheme;

    return Container(
      color: colorScheme.surface,
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
                  icon: Icon(Icons.close, color: colorScheme.onSurface),
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
              child: ElevatedButton(
                onPressed: _isButtonDisabled ? null : _handleButtonPress,
                style: theme.elevatedButtonTheme.style,
                child: Text(S.of(context).interested, style: theme.textTheme.labelLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
