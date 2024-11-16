import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../utilities/logger.dart';

class AllClosetToggle extends StatelessWidget {
  final bool isAllCloset;
  final Function(bool) onChanged;
  final CustomLogger logger;

  const AllClosetToggle({
    required this.isAllCloset,
    required this.onChanged,
    required this.logger,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('Rendering AllCloset toggle');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(S.of(context).allClosetLabel),
        Switch(
          value: isAllCloset,
          onChanged: (value) {
            logger.d('User toggled allCloset switch: $value');
            onChanged(value);
          },
          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
            return states.contains(WidgetState.selected)
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimary;
          }),
          thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
            return states.contains(WidgetState.selected)
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary;
          }),
        ),
      ],
    );
  }
}
