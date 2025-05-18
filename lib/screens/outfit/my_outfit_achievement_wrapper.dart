import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utilities/app_router.dart';
import '../../core/achievement_celebration/presentation/bloc/achievement_celebration_bloc/achievement_celebration_bloc.dart';
import '../../core/achievement_celebration/helper/achievement_navigator.dart';
import '../../core/widgets/progress_indicator/outfit_progress_indicator.dart';

/// Wraps a screen with sequential achievement checks:
/// 0: Clothing Worn → 1: No‑Buy Milestone → 2: First Outfit → 3: First Selfie
/// If any succeeds, navigation happens immediately. If all fail, renders the child.
class MyOutfitAchievementWrapper extends StatefulWidget {
  final Widget child;
  const MyOutfitAchievementWrapper({required this.child, super.key});

  @override
  State<MyOutfitAchievementWrapper> createState() => _MyOutfitAchievementWrapperState();
}

class _MyOutfitAchievementWrapperState extends State<MyOutfitAchievementWrapper> {
  int _stage = 0;
  bool _ready = false;
  late final StreamSubscription<AchievementCelebrationState> _sub;

  @override
  void initState() {
    super.initState();
    // 1) Start the first achievement check
    context
        .read<AchievementCelebrationBloc>()
        .add(FetchAndSaveClothingWornAchievementEvent());

    // 2) Listen for results
    _sub = context.read<AchievementCelebrationBloc>().stream.listen(_onAchievementState);
  }

  void _onAchievementState(AchievementCelebrationState state) {
    // ignore the in-progress state
    if (state is AchievementInProgressState) return;

    // Did this stage succeed?
    final success =
        (state is ClothingWornAchievementSuccessState && _stage == 0) ||
            (state is NoBuyMilestoneAchievementSuccessState && _stage == 1) ||
            (state is FirstOutfitAchievementSuccessState && _stage == 2) ||
            (state is FirstSelfieAchievementSuccessState && _stage == 3);

    if (success) {
      final s = state as dynamic;
      handleAchievementNavigationWithTheme(
        context: context,
        achievementKey: s.achievementName,
        badgeUrl: s.badgeUrl,
        nextRoute: AppRoutesName.createOutfit,
        isFromMyCloset: false,
      );
      return;
    }

    // Otherwise, move to the next stage or finish
    _stage++;
    switch (_stage) {
      case 1:
        context
            .read<AchievementCelebrationBloc>()
            .add(FetchAndSaveNoBuyMilestoneAchievementEvent());
        break;
      case 2:
        context
            .read<AchievementCelebrationBloc>()
            .add(FetchFirstOutfitCreatedAchievementEvent());
        break;
      case 3:
        context
            .read<AchievementCelebrationBloc>()
            .add(FetchFirstSelfieTakenAchievementEvent());
        break;
      default:
      // All four failed → show the screen
        setState(() => _ready = true);
        _sub.cancel();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) {
      return widget.child;
    }
    return const Scaffold(
      body: Center(child: OutfitProgressIndicator()),
    );
  }
}
