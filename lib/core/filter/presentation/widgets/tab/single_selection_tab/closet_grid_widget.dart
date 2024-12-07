import 'package:flutter/material.dart';
import '../../../../../utilities/logger.dart';
import '../../../widgets/closet_grid.dart';
import '../../../../../../item_management/core/data/models/multi_closet_minimal.dart';
import '../../../../../../generated/l10n.dart';

class ClosetGridWidget extends StatelessWidget {
  final List<MultiClosetMinimal> closets; // Use MultiCloset here
  final String selectedClosetId;
  final Function(String) onSelectCloset;

  final CustomLogger logger = CustomLogger('ClosetGridWidget');

  ClosetGridWidget({
    required this.closets,
    required this.selectedClosetId,
    required this.onSelectCloset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    logger.i('Rendering ClosetGrid');

    final localizedClosets = closets.map((closet) {
      return closet.copyWith(
        closetName: closet.closetName == 'cc_closet'
            ? S.of(context).defaultClosetName // Localized name
            : closet.closetName,
      );
    }).toList();

    return ClosetGrid(
      closets: localizedClosets,
      scrollController: ScrollController(),
      myClosetTheme: Theme.of(context),
      selectedClosetId: selectedClosetId,
      onSelectCloset: (closetId) {
        logger.d('User selected closet with ID: $closetId');
        onSelectCloset(closetId);
      },
    );
  }
}
