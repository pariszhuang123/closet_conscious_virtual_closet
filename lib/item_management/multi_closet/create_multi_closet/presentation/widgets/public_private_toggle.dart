import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';

class PublicPrivateToggle extends StatelessWidget {
  final bool isPublic;
  final Function(bool) onChanged;

  static final CustomLogger _logger = CustomLogger('PublicPrivateToggle');

  const PublicPrivateToggle({
    required this.isPublic,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Rendering PublicPrivateToggle');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isPublic ? S.of(context).public : S.of(context).private, // Flip logic here
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Switch(
          value: isPublic, // Invert the value here
          onChanged: (value) {
            _logger.d('Public/Private toggle changed: $value');
            onChanged(value);
          },
        ),
      ],
    );
  }
}
