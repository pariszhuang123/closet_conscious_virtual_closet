import 'package:flutter/material.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../widgets/form/custom_toggle.dart';

class AllClosetToggle extends StatelessWidget {
  final bool isAllCloset;
  final Function(bool) onChanged;

  const AllClosetToggle({
    required this.isAllCloset,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomToggle(
      value: isAllCloset,
      onChanged: onChanged,
      trueLabel: S.of(context).allClosetShown,
      falseLabel: S.of(context).singleClosetShown,
    );
  }
}
