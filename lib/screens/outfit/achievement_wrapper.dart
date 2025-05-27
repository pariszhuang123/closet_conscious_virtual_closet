import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utilities/app_router.dart';
import '../../core/achievement_celebration/presentation/bloc/achievement_celebration_bloc/achievement_celebration_bloc.dart';
import '../../core/achievement_celebration/helper/achievement_navigator.dart';
import '../../core/widgets/progress_indicator/outfit_progress_indicator.dart';

/// Wraps a screen with a single consolidated achievement check.
class AchievementWrapper extends StatefulWidget {
  final Widget child;
  final bool isFromMyCloset;

  const AchievementWrapper(
      {required this.child,
        required this.isFromMyCloset,
        super.key});

  @override
  State<AchievementWrapper> createState() => _AchievementWrapperState();
}

class _AchievementWrapperState extends State<AchievementWrapper> {
  bool _ready = false;
  late final StreamSubscription<AchievementCelebrationState> _sub;

  @override
  void initState() {
    super.initState();

    // Trigger the consolidated achievement check
    context.read<AchievementCelebrationBloc>().add(AwardAchievementEvent());

    // Listen for the result
    _sub = context.read<AchievementCelebrationBloc>().stream.listen(_onAchievementState);
  }

  void _onAchievementState(AchievementCelebrationState state) {
    if (state is AchievementInProgressState) return;

    if (state is AchievementCelebrationSuccessState) {
      final nextRoute = widget.isFromMyCloset
          ? AppRoutesName.myCloset
          : AppRoutesName.createOutfit;

      handleAchievementNavigationWithTheme(
        context: context,
        achievementKey: state.achievementName,
        badgeUrl: state.badgeUrl,
        nextRoute: nextRoute,
        isFromMyCloset: widget.isFromMyCloset,
      );
      return;
    }

    // All checks done or no achievement unlocked
    setState(() => _ready = true);
    _sub.cancel();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ready
        ? widget.child
        : const Scaffold(
      body: Center(child: OutfitProgressIndicator()),
    );
  }
}
