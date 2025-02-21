import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/theme/my_closet_theme.dart';
import '../../../../../core/theme/my_outfit_theme.dart';
import '../../../../../core/utilities/routes.dart';

class UsageAnalyticsScaffold extends StatelessWidget {
  final Widget body;
  final bool isFromMyCloset; // Determines the theme
  final CustomLogger logger = CustomLogger('UsageAnalyticsScaffold');

  UsageAnalyticsScaffold({
    super.key,
    required this.body,
    required this.isFromMyCloset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = isFromMyCloset ? myClosetTheme : myOutfitTheme; // Apply correct theme
    final title = S.of(context).usageAnalyticsTitle; // Localized title
    final tabItemAnalytics = S.of(context).tabItemAnalytics;
    final tabOutfitAnalytics = S.of(context).tabOutfitAnalytics;

    logger.i('Building UsageAnalyticsScaffold for ${isFromMyCloset ? "Closet" : "Outfit"}');

    return Theme(
      data: theme,
      child: PopScope<Object?>(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          logger.i('Pop invoked: didPop = $didPop, result = $result');

          if (didPop) {
            final destination = isFromMyCloset ? AppRoutes.myCloset : AppRoutes.createOutfit;
            logger.i('Navigating to ${isFromMyCloset ? "My Closet" : "Create Outfit"} screen');

            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(destination);
            });
          } else {
            logger.w('Pop action not allowed');
          }
        },
        child: DefaultTabController(
          length: 2, // Two tabs: Item Analytics & Outfit Analytics
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
              bottom: TabBar(
                indicatorColor: theme.colorScheme.primary, // Themed indicator
                labelColor: theme.colorScheme.onSurface, // Active tab text color
                unselectedLabelColor: theme.colorScheme.secondary, // Inactive tab text color
                tabs: [
                  Tab(text: tabItemAnalytics),
                  Tab(text: tabOutfitAnalytics),
                ],
              ),
            ),
            body: body, // Injects the dynamic body
          ),
        ),
      ),
    );
  }
}
