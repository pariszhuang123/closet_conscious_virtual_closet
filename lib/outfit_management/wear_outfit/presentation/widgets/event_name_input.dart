import 'package:flutter/material.dart';
import '../../../../core/widgets/form/custom_text_form.dart';
import '../../../../generated/l10n.dart';

class EventNameInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String value)? onChanged;

  const EventNameInput({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      labelText: S.of(context).enterEventName,
      hintText: S.of(context).hintEventName,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      focusedBorderColor: Theme.of(context).colorScheme.primary,
      enabledBorderColor: Theme.of(context).colorScheme.secondary,
      onChanged: onChanged,
    );
  }
}
