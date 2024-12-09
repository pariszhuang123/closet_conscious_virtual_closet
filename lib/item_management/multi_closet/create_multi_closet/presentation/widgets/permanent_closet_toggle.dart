import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_toggle.dart';

class PermanentClosetToggle extends StatelessWidget {
  final bool isPermanent;
  final Function(bool) onChanged;

  const PermanentClosetToggle({
    required this.isPermanent,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomToggle(
      value: isPermanent,
      onChanged: onChanged,
      trueLabel: S.of(context).permanentCloset,
      falseLabel: S.of(context).disappearingCloset,
    );
  }
}
