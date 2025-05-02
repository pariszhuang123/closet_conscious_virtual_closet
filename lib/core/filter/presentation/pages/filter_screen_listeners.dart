import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/bloc/filter_bloc.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../core_enums.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';

class FilterScreenListeners extends StatelessWidget {
  final bool isFromMyCloset;
  final String returnRoute;
  final List<String> selectedItemIds;
  final List<String> selectedOutfitIds;
  final bool showOnlyClosetFilter;
  final CustomLogger logger;
  final Widget child; // <- wrap this

  const FilterScreenListeners({
    super.key,
    required this.isFromMyCloset,
    required this.returnRoute,
    required this.selectedItemIds,
    required this.selectedOutfitIds,
    required this.showOnlyClosetFilter,
    required this.logger,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilterBloc, FilterState>(
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.saveSuccess) {
              logger.i('Save success, navigating back to $returnRoute');
              context.goNamed(
                returnRoute,
                extra: {
                  'selectedItemIds': selectedItemIds,
                  'selectedOutfitIds': selectedOutfitIds,
                },
              );
            } else if (state.accessStatus == AccessStatus.trialPending) {
              logger.i('Trial pending, navigating to trialStarted');
              context.goNamed(
                AppRoutesName.trialStarted,
                extra: {
                  'selectedFeatureRoute': AppRoutesName.filter,
                  'isFromMyCloset': isFromMyCloset,
                },
              );
            } else if (state.accessStatus == AccessStatus.denied) {
              logger.i('Access denied, navigating to payment');
              context.goNamed(
                AppRoutesName.payment,
                extra: {
                  'featureKey': FeatureKey.filter,
                  'isFromMyCloset': isFromMyCloset,
                  'previousRoute': isFromMyCloset ? AppRoutesName.myCloset : AppRoutesName.createOutfit,
                  'nextRoute': AppRoutesName.filter,
                },
              );
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              logger.i('Showing tutorial popup');
              context.goNamed(
                AppRoutesName.tutorialVideoPopUp,
                extra: {
                  'nextRoute': AppRoutesName.filter,
                  'tutorialInputKey': TutorialType.paidFilter.value,
                  'isFromMyCloset': isFromMyCloset,
                },
              );
            }
          },
        ),
        BlocListener<FilterBloc, FilterState>(
          listenWhen: (previous, current) =>
          previous.hasMultiClosetFeature != current.hasMultiClosetFeature,
          listener: (context, state) {
            if (state.hasMultiClosetFeature) {
              logger.i('Multi-closet feature active — fetching cross axis count');
              context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
            }
          },
        ),
      ],
      child: child,
    );
  }
}
