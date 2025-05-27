import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/utilities/app_router.dart';
import '../../core/utilities/logger.dart';
import '../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../generated/l10n.dart';

import '../../core/core_enums.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/tutorial/core/presentation/bloc/tutorial_cubit.dart';
import '../../core/tutorial/scenario/presentation/bloc/first_time_scenario_bloc.dart';
import '../../core/utilities/helper_functions/tutorial_helper.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';


class MyClosetAccessWrapper extends StatefulWidget {
  final Widget child;

  const MyClosetAccessWrapper({super.key, required this.child});

  @override
  State<MyClosetAccessWrapper> createState() => _MyClosetAccessWrapperState();
}

class _MyClosetAccessWrapperState extends State<MyClosetAccessWrapper> {
  final _logger = CustomLogger('MyClosetAccessWrapper');

  late final StreamSubscription _firstTimeSub;
  late final StreamSubscription _tutorialSub;
  late final StreamSubscription _navigateItemSub;

  bool _ready = false;

  @override
  void initState() {
    super.initState();

    // Step 1: Check goal selection
    context.read<FirstTimeScenarioBloc>().add(CheckFirstTimeScenario());

    _firstTimeSub = context.read<FirstTimeScenarioBloc>().stream.listen((state) {
      if (!mounted) return;

      if (state is FirstTimeCheckSuccess) {
        if (state.isFirstTime) {
          GoRouter.of(context).goNamed(AppRoutesName.goalSelectionProvider);
        } else {
          // Proceed to Step 2: Check tutorial
          context.read<TutorialTypeCubit>().setType(TutorialType.freeClosetUpload);
          context.read<TutorialBloc>().add(const CheckTutorialStatus(TutorialType.freeClosetUpload));
        }
      } else if (state is FirstTimeCheckFailure) {
        // Proceed even if check fails
        context.read<TutorialTypeCubit>().setType(TutorialType.freeClosetUpload);
        context.read<TutorialBloc>().add(const CheckTutorialStatus(TutorialType.freeClosetUpload));
      }
    });

    // Step 2: Tutorial flow
    _tutorialSub = context.read<TutorialBloc>().stream.listen((state) {
      if (!mounted) return;

      final tutorialType = context.read<TutorialTypeCubit>().state;
      if (tutorialType == null) {
        _logger.w('Tutorial type is null – skipping tutorial navigation');
        return;
      }

      final router = GoRouter.of(context);

      if (state is ShowTutorial) {
        switch (tutorialType) {
          case TutorialType.freeClosetUpload:
            router.goNamed(
              AppRoutesName.tutorialVideoPopUp,
              extra: {
                'nextRoute': AppRoutesName.webView,
                'tutorialInputKey': tutorialType.value,
                'isFromMyCloset': true,
                'optionalUrl': S.of(context).streakBenefitsUrl,
              },
            );
            break;

          case TutorialType.freeUploadCamera:
            router.goNamed(
              AppRoutesName.tutorialVideoPopUp,
              extra: {
                'nextRoute': AppRoutesName.uploadItemPhoto,
                'tutorialInputKey': tutorialType.value,
                'isFromMyCloset': true,
              },
            );
            break;

          default:
            _logger.w('Unhandled tutorial type: $tutorialType');
        }
      } else if (state is SkipTutorial) {
        // Step 3: Fetch disappearing closet
        context.read<NavigateItemBloc>().add(const FetchDisappearedClosetsEvent());
      }
    });

    // Step 3: Disappearing Closet
    _navigateItemSub = context.read<NavigateItemBloc>().stream.listen((state) {
      if (!mounted) return;

      if (state is FetchDisappearedClosetsSuccessState) {
        GoRouter.of(context).pushNamed(
          AppRoutesName.reappearCloset,
          extra: {
            'closetId': state.closetId,
            'closetName': state.closetName,
            'closetImage': state.closetImage,
          },
        );
      }

      // ✅ Final step — mark ready
      setState(() {
        _ready = true;
      });
    });
  }

  @override
  void dispose() {
    _firstTimeSub.cancel();
    _tutorialSub.cancel();
    _navigateItemSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return widget.child;

    return const Scaffold(
      body: Center(child: ClosetProgressIndicator()),
    );
  }
}
