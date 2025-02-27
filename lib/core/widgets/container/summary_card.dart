import 'package:flutter/material.dart';

import 'base_container.dart';
import '../../utilities/number_formatter.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final num value;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedValue = formatNumber(value); // Apply formatting inside widget

    return BaseContainer(
      theme: theme,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${formattedValue.value}${formattedValue.suffix}', // Format applied here
              style: theme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
