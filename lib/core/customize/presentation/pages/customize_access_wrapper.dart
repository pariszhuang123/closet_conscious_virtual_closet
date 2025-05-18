import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/app_router.dart';
import '../../../core_enums.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../../paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';
import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../utilities/logger.dart';

/// Wraps the Customize screen in Tutorial → Trial → Paywall flow
class CustomizeAccessWrapper extends StatefulWidget {
  final bool isFromMyCloset;
  final Widget child;

  const CustomizeAccessWrapper({
    required this.isFromMyCloset,
    required this.child,
    super.key,
  });

  @override
  State<CustomizeAccessWrapper> createState() => _CustomizeAccessWrapperState();
}

class _CustomizeAccessWrapperState extends State<CustomizeAccessWrapper> {
  late final StreamSubscription<TutorialState> _tutorialSub;
  late final StreamSubscription<TrialState> _trialSub;
  late final StreamSubscription<PremiumFeatureAccessState> _premiumSub;
  final CustomLogger _logger = CustomLogger('CustomizeAccessWrapper');

  bool _ready = false;

  @override
  void initState() {
    super.initState();

    final tutorialBloc = context.read<TutorialBloc>();
    final trialBloc    = context.read<TrialBloc>();
    final premiumBloc  = context.read<PremiumFeatureAccessBloc>();
    final router       = GoRouter.of(context);

    _logger.i('🛠 Starting access flow for Customize screen');

    // 1) Start tutorial check
    _logger.d('📘 Dispatching CheckTutorialStatus');
    tutorialBloc.add(const CheckTutorialStatus(TutorialType.paidCustomize));

    // 2) Tutorial → Trial
    _tutorialSub = tutorialBloc.stream.listen((state) {
      if (!mounted) return;
      _logger.d('📘 TutorialBloc state: ${state.runtimeType}');

      if (state is ShowTutorial) {
        _logger.i('🎬 Showing tutorial pop-up');
        router.goNamed(
          AppRoutesName.tutorialVideoPopUp,
          extra: {
            'nextRoute': AppRoutesName.customize,
            'tutorialInputKey': TutorialType.paidCustomize.value,
            'isFromMyCloset': widget.isFromMyCloset,
          },
        );
      } else if (state is SkipTutorial) {
        _logger.i('⏩ Skipping tutorial, checking trial access');
        trialBloc.add(const CheckTrialAccessByFeatureEvent(FeatureKey.customize));
      }
    });

    // 3) Trial → Paywall
    _trialSub = trialBloc.stream.listen((state) {
      if (!mounted) return;
      _logger.d('🧪 TrialBloc state: ${state.runtimeType}');

      if (state is TrialAccessDenied) {
        _logger.i('🚫 Trial denied, routing to trial start page');
        router.goNamed(
          AppRoutesName.trialStarted,
          extra: {
            'selectedFeatureRoute': AppRoutesName.customize,
            'isFromMyCloset': widget.isFromMyCloset,
          },
        );
      } else if (state is TrialSuccess) {
        _logger.i('✅ Trial success, checking premium access');
        premiumBloc.add(const CheckCustomizeAccessEvent());
      }
    });

    // 4) Paywall → Ready
    _premiumSub = premiumBloc.stream.listen((state) {
      if (!mounted) return;
      _logger.d('💎 PremiumAccessBloc state: ${state.runtimeType}');

      if (state is CustomizeAccessDeniedState) {
        _logger.i('🔒 Access denied, routing to payment');
        router.goNamed(
          AppRoutesName.payment,
          extra: {
            'featureKey': FeatureKey.customize,
            'isFromMyCloset': widget.isFromMyCloset,
            'previousRoute': widget.isFromMyCloset
                ? AppRoutesName.myCloset
                : AppRoutesName.createOutfit,
            'nextRoute': AppRoutesName.customize,
          },
        );
      } else if (state is CustomizeAccessGrantedState) {
        _logger.i('🎉 Customize access granted, displaying CustomizeScreen');
        if (mounted) {
          setState(() => _ready = true);
        }
      }
    });
  }

  @override
  void dispose() {
    _logger.d('🧹 Cleaning up stream subscriptions');
    _tutorialSub.cancel();
    _trialSub.cancel();
    _premiumSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _logger.d(_ready ? '🚪 Access granted — rendering child' : '🔄 Waiting for access — showing loading spinner');
    return _ready
        ? widget.child
        : const Scaffold(
      body: Center(child: ClosetProgressIndicator()),
    );
  }
}
