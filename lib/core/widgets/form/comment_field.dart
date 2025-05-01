import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../container/base_container.dart';

class CommentField extends StatelessWidget {
  final TextEditingController? controller;
  final ThemeData theme;
  final String? initialText; // For read-only mode
  final bool isReadOnly; // New flag for read-only mode
  final String? hintText;

  const CommentField({
    super.key,
    this.controller,
    required this.theme,
    this.initialText,
    this.isReadOnly = false,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      theme: theme,
      child: isReadOnly
          ? Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          initialText ?? S.of(context).noOutfitComments,
          style: theme.textTheme.bodyMedium,
          maxLines: 5, // Limit read-only comments to 5 lines
          overflow: TextOverflow.ellipsis, // Append "..." if text exceeds 5 lines
        ),
      )
          : TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: S.of(context).addYourComments,
          hintText: hintText,
          border: InputBorder.none,
        ),
        maxLines: 3,
      ),
    );
  }
}
