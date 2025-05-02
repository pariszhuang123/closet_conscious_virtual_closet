import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/utilities/helper_functions/tutorial_helper.dart';
import '../bloc/view_multi_closet_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';

class ViewMultiClosetListeners extends StatelessWidget {
  final bool isFromMyCloset;
  final CustomLogger logger;
  final Widget child;

  const ViewMultiClosetListeners({
    super.key,
    required this.isFromMyCloset,
    required this.logger,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
          listener: (context, state) {
            if (state is MultiClosetAccessState) {
              if (state.accessStatus == AccessStatus.trialPending) {
                logger.i('Trial pending, navigating to trialStarted screen');
                context.goNamed(
                  AppRoutesName.trialStarted,
                  extra: {
                    'selectedFeatureRoute': AppRoutesName.viewMultiCloset,
                    'isFromMyCloset': isFromMyCloset,
                  },
                );
              } else if (state.accessStatus == AccessStatus.granted) {
                logger.i('Access granted: Fetching data');
                context.read<ViewMultiClosetBloc>().add(FetchViewMultiClosetsEvent());
                context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
              } else if (state.accessStatus == AccessStatus.denied) {
                logger.w('Access denied: Navigating to payment page');
                context.goNamed(
                  AppRoutesName.payment,
                  extra: {
                    'featureKey': FeatureKey.multicloset,
                    'isFromMyCloset': isFromMyCloset,
                    'previousRoute': AppRoutesName.myCloset,
                    'nextRoute': AppRoutesName.viewMultiCloset,
                  },
                );
              }
            } else if (state is CreateMultiClosetNavigationState) {
              logger.i('Navigating to Create Multi Closet screen.');
              context.pushNamed(AppRoutesName.createMultiCloset);
            } else if (state is EditSingleMultiClosetNavigationState ||
                state is EditAllMultiClosetNavigationState) {
              logger.i('Navigating to Edit Multi Closet screen.');
              context.pushNamed(AppRoutesName.editMultiCloset);
            } else {
              logger.d('Unhandled state in MultiClosetNavigationBloc: ${state.runtimeType}');
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              logger.i('Tutorial trigger detected, navigating to tutorial video pop-up');
              context.goNamed(
                AppRoutesName.tutorialVideoPopUp,
                extra: {
                  'nextRoute': AppRoutesName.viewMultiCloset,
                  'tutorialInputKey': TutorialType.paidMultiCloset.value,
                  'isFromMyCloset': isFromMyCloset,
                },
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
