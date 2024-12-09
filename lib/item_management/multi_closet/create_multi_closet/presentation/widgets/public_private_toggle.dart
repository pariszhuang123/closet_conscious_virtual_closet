import 'package:flutter/material.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_toggle.dart';

class PublicPrivateToggle extends StatelessWidget {
  final bool isPublic;
  final Function(bool) onChanged;

  const PublicPrivateToggle({
    required this.isPublic,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomToggle(
      value: isPublic,
      onChanged: onChanged,
      trueLabel: S.of(context).public, // Label for "Public"
      falseLabel: S.of(context).private, // Label for "Private"
    );
  }
}
