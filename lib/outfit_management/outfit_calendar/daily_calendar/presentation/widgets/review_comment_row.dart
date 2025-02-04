import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/outfit_review_button.dart';
import '../../../../../core/widgets/form/comment_field.dart';

class ReviewAndCommentRow extends StatelessWidget {
  final String outfitId;
  final String? feedback;
  final ThemeData theme;
  final TextEditingController? controller;
  final bool isReadOnly; // New flag to control editability

  const ReviewAndCommentRow({
    super.key,
    required this.outfitId,
    required this.feedback,
    required this.theme,
    this.controller,
    this.isReadOnly = false, // Default to false for editable mode
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Review Button (Left Side)
          OutfitReviewButton(
            outfitId: outfitId,
            feedback: feedback,
          ),

          const SizedBox(width: 12), // Spacing between button and comment field

          // Expanded Comment Field (Right Side)
          Expanded(
            child: CommentField(
              controller: isReadOnly ? null : controller,
              initialText: feedback, // Use feedback as read-only text
              theme: theme,
              isReadOnly: isReadOnly, // Toggle between editable & read-only
            ),
          ),
        ],
      ),
    );
  }
}
