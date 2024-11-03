import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextStyle? labelStyle;
  final Color focusedBorderColor;
  final Color? enabledBorderColor;
  final String? errorText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.labelStyle,
    required this.focusedBorderColor,
    this.enabledBorderColor,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.edit),
        labelText: labelText,
        hintText: hintText,
        labelStyle: labelStyle,
        border: InputBorder.none,
        enabledBorder: enabledBorderColor != null
            ? OutlineInputBorder(
          borderSide: BorderSide(
            color: enabledBorderColor!,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        )
            : null, // Set to null if no enabledBorderColor is provided
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 2.0,
          ),
        ),
        errorText: errorText, // errorText is displayed if non-null
      ),
      keyboardType: keyboardType,
      validator: validator, // validator logic is applied here
      onChanged: onChanged,
    );
  }
}
