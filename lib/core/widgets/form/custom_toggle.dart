import 'package:flutter/material.dart';
import '../../../../../core/utilities/logger.dart';

class CustomToggle extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;
  final String trueLabel;
  final String falseLabel;

  static final CustomLogger _logger = CustomLogger('CustomToggle');

  const CustomToggle({
    required this.value,
    required this.onChanged,
    required this.trueLabel,
    required this.falseLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Rendering CustomToggle');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value ? trueLabel : falseLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Switch(
          value: value,
          onChanged: (newValue) {
            _logger.d('User toggled CustomToggle: $newValue');
            onChanged(newValue);
          },
          trackColor: WidgetStateProperty.resolveWith<Color>((states) {
            return states.contains(WidgetState.selected)
                ? Theme.of(context).colorScheme.primary.withValues()
                : Theme.of(context).colorScheme.surface;
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
