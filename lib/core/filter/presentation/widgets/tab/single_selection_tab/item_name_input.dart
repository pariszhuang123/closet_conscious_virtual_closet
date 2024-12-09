import 'package:flutter/material.dart';
import '../../../../../widgets/form/custom_text_form.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../utilities/logger.dart';

class ItemNameInput extends StatefulWidget {
  final String initialText;
  final Function(String) onChanged;
  final CustomLogger logger;

  const ItemNameInput({
    required this.initialText,
    required this.onChanged,
    required this.logger,
    super.key,
  });

  @override
  State<ItemNameInput> createState() => _ItemNameInputState();
}

class _ItemNameInputState extends State<ItemNameInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    widget.logger.d('Initialized TextEditingController with text: ${widget.initialText}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.logger.d('Building item name input field');
    return CustomTextFormField(
      controller: _controller,
      labelText: S.of(context).itemNameLabel,
      hintText: S.of(context).ItemNameFilterHint,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      hintStyle: Theme.of(context).textTheme.bodyMedium,
      focusedBorderColor: Theme.of(context).colorScheme.primary,
      onChanged: (value) {
        widget.logger.d('User entered item name: $value');
        widget.onChanged(value);
      },
    );
  }
}
