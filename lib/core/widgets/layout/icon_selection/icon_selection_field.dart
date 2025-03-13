import 'package:flutter/material.dart';
import 'icon_row_builder.dart';
import '../../../data/type_data.dart';

class IconSelectionField extends StatelessWidget {
  final String label;
  final List<TypeData> options;
  final List<String> selected;
  final Function(String) onChanged;
  final String? errorText;

  const IconSelectionField({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        ...buildIconRows(
          options,
          selected,
              (selectedKeys) => onChanged(selectedKeys.first),
          context,
          true,
          false,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
