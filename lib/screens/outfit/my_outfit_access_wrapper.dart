import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/utilities/app_router.dart';
import '../../core/core_enums.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../core/paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';
import '../../core/utilities/helper_functions/tutorial_helper.dart';
import '../../core/widgets/progress_indicator/outfit_progress_indicator.dart';

/// Wraps a screen with Tutorial → Trial → Paywall flow.
class MyOutfitAccessWrapper extends StatefulWidget {
  final Widget child;
  const MyOutfitAccessWrapper({required this.child, super.key});

  @override
  State<MyOutfitAccessWrapper> createState() => _MyOutfitAccessWrapperState();
}

class _MyOutfitAccessWrapperState extends State<MyOutfitAccessWrapper> {
  late final StreamSubscription<TutorialState> _tutorialSub;
  late final StreamSubscription<TrialState> _trialSub;
  late final StreamSubscription<PremiumFeatureAccessState> _premiumSub;

  bool _ready = false;

  @override
  void initState() {
    super.initState();

    // 1) Capture everything _before_ we enter async listeners
    final tutorialBloc = context.read<TutorialBloc>();
    final trialBloc    = context.read<TrialBloc>();
    final premiumBloc  = context.read<PremiumFeatureAccessBloc>();
    final router       = GoRouter.of(context);

    // 2) Kick off the tutorial check
    tutorialBloc.add(const CheckTutorialStatus(TutorialType.freeCreateOutfit));

    // 3) Tutorial → Trial
    _tutorialSub = tutorialBloc.stream.listen((state) {
      if (!mounted) return;

      if (state is ShowTutorial) {
        router.goNamed(
          AppRoutesName.tutorialVideoPopUp,
          extra: {
            'nextRoute': AppRoutesName.createOutfit,
            'tutorialInputKey': TutorialType.freeCreateOutfit.value,
            'isFromMyCloset': false,
          },
        );
      } else if (state is SkipTutorial) {
        trialBloc.add(const CheckTrialAccessByFeatureEvent(FeatureKey.multiOutfit));
      }
    });

    // 4) Trial → Paywall
    _trialSub = trialBloc.stream.listen((state) {
      if (!mounted) return;

      if (state is TrialAccessDenied) {
        router.goNamed(
          AppRoutesName.trialStarted,
          extra: {
            'selectedFeatureRoute': AppRoutesName.myCloset,
            'isFromMyCloset': false,
          },
        );
      } else if (state is TrialSuccess) {
        premiumBloc.add(const CheckOutfitCreationAccessEvent());
      }
    });

    // 5) Paywall → Ready (or redirect)
    _premiumSub = premiumBloc.stream.listen((state) {
      if (!mounted) return;

      if (state is OutfitAccessDeniedState) {
        router.goNamed(
          AppRoutesName.payment,
          extra: {
            'featureKey': FeatureKey.multiOutfit,
            'isFromMyCloset': false,
            'previousRoute': AppRoutesName.myCloset,
            'nextRoute': AppRoutesName.createOutfit,
          },
        );
      } else if (state is OutfitAccessGrantedState) {
        setState(() => _ready = true);
      }
    });
  }

  @override
  void dispose() {
    _tutorialSub.cancel();
    _trialSub.cancel();
    _premiumSub.cancel();
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
