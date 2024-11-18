import 'package:flutter/material.dart';
import '../../../../../utilities/logger.dart';
import '../../../widgets/closet_grid.dart';
import '../../../../../multi_closet/data/models/multi_closet.dart';
import '../../../../../../generated/l10n.dart';

class ClosetGridWidget extends StatelessWidget {
  final List<MultiCloset> closets; // Use MultiCloset here
  final String selectedClosetId;
  final Function(String) onSelectCloset;
  final CustomLogger logger;

  const ClosetGridWidget({
    required this.closets,
    required this.selectedClosetId,
    required this.onSelectCloset,
    required this.logger,
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

    return Expanded(
      child: ClosetGrid(
        closets: localizedClosets,
        scrollController: ScrollController(),
        myClosetTheme: Theme.of(context),
        logger: logger,
        selectedClosetId: selectedClosetId,
        onSelectCloset: (closetId) {
          logger.d('User selected closet with ID: $closetId');
          onSelectCloset(closetId);
        },
      ),
    );
  }
}
