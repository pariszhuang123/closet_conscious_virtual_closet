import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String labelText;
  final String? hintText;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? resultStyle;
  final Color focusedBorderColor;
  final Color? enabledBorderColor;
  final String? errorText;
  final Function(T?)? onChanged;
  final Function(T?)? onSaved;
  final String? Function(T?)? validator;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.labelText,
    this.hintText,
    this.labelStyle,
    this.hintStyle,
    this.resultStyle,
    required this.focusedBorderColor,
    this.enabledBorderColor,
    this.errorText,
    this.onChanged,
    this.onSaved,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      style: resultStyle ?? Theme.of(context).textTheme.bodyMedium, // Use resultStyle here
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: labelStyle,
        hintStyle: hintStyle,
        border: InputBorder.none,
        enabledBorder: enabledBorderColor != null
            ? OutlineInputBorder(
          borderSide: BorderSide(
            color: enabledBorderColor!,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        )
            : null,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 2.0,
          ),
        ),
        errorText: errorText,
      ),
    );
  }
}
