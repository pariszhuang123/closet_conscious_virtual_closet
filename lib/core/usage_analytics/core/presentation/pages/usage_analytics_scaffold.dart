import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/theme/my_closet_theme.dart';
import '../../../../../core/theme/my_outfit_theme.dart';
import '../../../../../core/utilities/app_router.dart';
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
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          logger.i('Pop invoked: didPop = $didPop, result = $result');

          final destination = widget.isFromMyCloset
              ? AppRoutesName.myCloset
              : AppRoutesName.createOutfit;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed(destination); // 👈 Clean redirect
          });
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true, // already defaults to true
            leading: Navigator.of(context).canPop()
                ? const BackButton()
                : const BackButton(), // force showing only when stack can pop
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
