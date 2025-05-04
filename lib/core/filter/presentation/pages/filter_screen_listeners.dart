import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/bloc/filter_bloc.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../core_enums.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../utilities/helper_functions/navigate_once_helper.dart';
import '../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';

class FilterScreenListeners extends StatefulWidget {
  final bool isFromMyCloset;
  final String returnRoute;
  final List<String> selectedItemIds;
  final List<String> selectedOutfitIds;
  final bool showOnlyClosetFilter;
  final CustomLogger logger;
  final Widget child;

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
  State<FilterScreenListeners> createState() => _FilterScreenListenersState();
}

class _FilterScreenListenersState extends State<FilterScreenListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FilterBloc, FilterState>(
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.saveSuccess) {
              widget.logger.i('saveSuccess → returning to ${widget.returnRoute}');
              navigateOnce(() {
                context.goNamed(
                  widget.returnRoute,
                  extra: {
                    'selectedItemIds'   : widget.selectedItemIds,
                    'selectedOutfitIds' : widget.selectedOutfitIds,
                  },
                );
              });
            } else if (state.accessStatus == AccessStatus.trialPending) {
              widget.logger.i('trialPending → trialStarted');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.trialStarted,
                  extra: {
                    'selectedFeatureRoute': AppRoutesName.filter,
                    'isFromMyCloset'     : widget.isFromMyCloset,
                  },
                );
              });
            } else if (state.accessStatus == AccessStatus.denied) {
              widget.logger.i('accessDenied → payment');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.payment,
                  extra: {
                    'featureKey'  : FeatureKey.filter,
                    'isFromMyCloset': widget.isFromMyCloset,
                    'previousRoute': widget.isFromMyCloset
                        ? AppRoutesName.myCloset
                        : AppRoutesName.createOutfit,
                    'nextRoute': AppRoutesName.filter,
                  },
                );
              });
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorial) {
            if (tutorial is ShowTutorial) {
              widget.logger.i('showTutorial → popup');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute'       : AppRoutesName.filter,
                    'tutorialInputKey': TutorialType.paidFilter.value,
                    'isFromMyCloset'  : widget.isFromMyCloset,
                  },
                );
              });
            }
          },
        ),
        BlocListener<FilterBloc, FilterState>(
          listenWhen: (prev, curr) =>
          prev.hasMultiClosetFeature != curr.hasMultiClosetFeature,
          listener: (context, state) {
            if (state.hasMultiClosetFeature) {
              widget.logger.i('multiCloset → fetchCrossAxisCount');
              context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
