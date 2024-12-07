import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';

class PermanentClosetToggle extends StatelessWidget {
  final bool isPermanent;
  final Function(bool) onChanged;

  static final CustomLogger _logger = CustomLogger('PermanentClosetToggle');

  const PermanentClosetToggle({
    required this.isPermanent,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Rendering PermanentToggle');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isPermanent
              ? S.of(context).permanentCloset
              : S.of(context).disappearingCloset,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Switch(
          value: isPermanent,
          onChanged: (value) {
            _logger.d('User toggled PermanentToggle: $value');
            onChanged(value);
          },
        ),
      ],
    );
  }
}
