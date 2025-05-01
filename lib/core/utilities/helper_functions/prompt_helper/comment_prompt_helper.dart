import 'package:flutter/widgets.dart';

import '../../../../generated/l10n.dart';

class CommentPromptHelper {
  static String getPrompt(BuildContext context, String flowType) {
    switch (flowType) {
      case 'memory_flow':
        return S.of(context).memoryOutfitReviewCommentPrompt;
      case 'personal_style_flow':
        return S.of(context).personalStyleOutfitReviewCommentPrompt;
      case 'life_change_flow':
        return S.of(context).lifeChangeOutfitReviewCommentPrompt;
      default:
        return S.of(context).defaultOutfitReviewCommentPrompt;
    }
  }
}
