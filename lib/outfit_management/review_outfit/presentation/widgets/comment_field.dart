import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/container/base_container.dart';

class CommentField extends StatelessWidget {
  final TextEditingController controller;
  final ThemeData theme;

  const CommentField({
    super.key,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      theme: theme,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: S.of(context).addYourComments,
          border: InputBorder.none,
        ),
        maxLines: 3,
      ),
    );
  }
}
