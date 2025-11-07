import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

class SuggestionMessageHelper {
  /// Converts suggestion keywords like 'scarf', 'hat' into a readable sentence.
  static String buildSuggestionMessage(BuildContext context, List<String> keywords) {
    if (keywords.isEmpty) return '';

    final localized = keywords.map((k) {
      switch (k.toLowerCase()) {
        case 'scarf':
          return S.of(context).scarf;
        case 'hat':
          return S.of(context).hat;
      // Add more cases like 'gloves', 'boots', etc. if needed
        default:
          return k;
      }
    }).toList();

    if (localized.length == 1) {
      return S.of(context).suggestionSingle(localized.first);
    } else if (localized.length == 2) {
      return S.of(context).suggestionDouble(localized[0], localized[1]);
    } else {
      final allButLast = localized.sublist(0, localized.length - 1).join(', ');
      final last = localized.last;
      return S.of(context).suggestionMultiple(allButLast, last);
    }
  }
}
