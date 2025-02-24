import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/theme/my_closet_theme.dart';
import '../../../../../core/theme/my_outfit_theme.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../widgets/layout/bottom_nav_bar/analytics_bottom_nav_bar.dart';

class UsageAnalyticsScaffold extends StatefulWidget {
  final Widget body;
  final bool isFromMyCloset; // Determines which theme to use

  const UsageAnalyticsScaffold({
    super.key,
    required this.body,
    required this.isFromMyCloset,
  });

  @override
  State<UsageAnalyticsScaffold> createState() => _UsageAnalyticsScaffoldState();
}

class _UsageAnalyticsScaffoldState extends State<UsageAnalyticsScaffold> {
  final CustomLogger logger = CustomLogger('UsageAnalyticsScaffold');

  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme; // Apply correct theme
    final title = S.of(context).usageAnalyticsTitle; // Localized title

    logger.i('Building UsageAnalyticsScaffold for ${widget.isFromMyCloset ? "Closet" : "Outfit"}');

    return Theme(
      data: theme,
      child: PopScope<Object?>(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          logger.i('Pop invoked: didPop = $didPop, result = $result');

          if (didPop) {
            final destination = widget.isFromMyCloset ? AppRoutes.myCloset : AppRoutes.createOutfit;
            logger.i('Navigating to ${widget.isFromMyCloset ? "My Closet" : "Create Outfit"} screen');

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(destination);
            });
          } else {
            logger.w('Pop action not allowed');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
          ),

          /// Dynamic body content
          body: widget.body,

          /// Custom Bottom Navigation Bar
          bottomNavigationBar: AnalyticsBottomNavBar(
            currentIndex: widget.isFromMyCloset ? 0 : 1, // Highlight correct tab
            isFromMyCloset: widget.isFromMyCloset,
          ),
        ),
      ),
    );
  }
}
