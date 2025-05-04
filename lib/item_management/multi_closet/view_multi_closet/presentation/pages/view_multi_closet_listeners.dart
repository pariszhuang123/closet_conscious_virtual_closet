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
import '../../../../../core/utilities/helper_functions/navigate_once_helper.dart';

class ViewMultiClosetListeners extends StatefulWidget {
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
  State<ViewMultiClosetListeners> createState() => _ViewMultiClosetListenersState();
}

class _ViewMultiClosetListenersState extends State<ViewMultiClosetListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
          listener: (context, state) {
            if (state is MultiClosetAccessState) {
              if (state.accessStatus == AccessStatus.trialPending) {
                widget.logger.i('Trial pending → navigating to trialStarted');
                navigateOnce(() {
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.viewMultiCloset,
                      'isFromMyCloset': widget.isFromMyCloset,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.granted) {
                widget.logger.i('Access granted → fetching closets and crossAxisCount');
                context.read<ViewMultiClosetBloc>().add(FetchViewMultiClosetsEvent());
                context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
              } else if (state.accessStatus == AccessStatus.denied) {
                widget.logger.w('Access denied → navigating to payment');
                navigateOnce(() {
                  context.goNamed(
                    AppRoutesName.payment,
                    extra: {
                      'featureKey': FeatureKey.multicloset,
                      'isFromMyCloset': widget.isFromMyCloset,
                      'previousRoute': AppRoutesName.myCloset,
                      'nextRoute': AppRoutesName.viewMultiCloset,
                    },
                  );
                });
              }
            } else if (state is CreateMultiClosetNavigationState) {
              widget.logger.i('Navigation → CreateMultiCloset');
              navigateOnce(() {
                context.pushNamed(AppRoutesName.createMultiCloset);
              });
            } else if (state is EditSingleMultiClosetNavigationState ||
                state is EditAllMultiClosetNavigationState) {
              widget.logger.i('Navigation → EditMultiCloset');
              navigateOnce(() {
                context.pushNamed(AppRoutesName.editMultiCloset);
              });
            } else {
              widget.logger.d('Unhandled state: ${state.runtimeType}');
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              widget.logger.i('Tutorial trigger → navigating to tutorial video');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.viewMultiCloset,
                    'tutorialInputKey': TutorialType.paidMultiCloset.value,
                    'isFromMyCloset': widget.isFromMyCloset,
                  },
                );
              });
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
