import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../widgets/form/custom_toggle.dart';

class OnlyItemsUnwornToggle extends StatelessWidget {
  final bool onlyItemsUnworn;
  final Function(bool) onChanged;

  const OnlyItemsUnwornToggle({
    required this.onlyItemsUnworn,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomToggle(
      value: !onlyItemsUnworn,  // Flip the value
      onChanged: (newValue) => onChanged(!newValue),  // Flip it back when changed
      trueLabel: S.of(context).allItems,
      falseLabel: S.of(context).onlyItemsUnworn,
    );
  }
}
