import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../core_enums.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../presentation/bloc/customize_bloc.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';

class CustomizeScreenListeners extends StatelessWidget {
  final bool isFromMyCloset;
  final String returnRoute;
  final List<String> selectedItemIds;
  final CustomLogger logger;
  final Widget child;

  const CustomizeScreenListeners({
    super.key,
    required this.isFromMyCloset,
    required this.returnRoute,
    required this.selectedItemIds,
    required this.logger,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomizeBloc, CustomizeState>(
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.saveSuccess) {
              logger.i('Customization saved, navigating back');
              context.goNamed(
                returnRoute,
                extra: {'selectedItemIds': selectedItemIds},
              );
            } else if (state.accessStatus == AccessStatus.trialPending) {
              logger.i('Trial pending, navigating to trialStarted');
              context.goNamed(
                AppRoutesName.trialStarted,
                extra: {
                  'selectedFeatureRoute': AppRoutesName.customize,
                  'isFromMyCloset': isFromMyCloset,
                },
              );
            } else if (state.accessStatus == AccessStatus.denied) {
              logger.i('Access denied, navigating to payment');
              context.goNamed(
                AppRoutesName.payment,
                extra: {
                  'featureKey': FeatureKey.customize,
                  'isFromMyCloset': isFromMyCloset,
                  'previousRoute':
                  isFromMyCloset ? AppRoutesName.myCloset : AppRoutesName.createOutfit,
                  'nextRoute': AppRoutesName.customize,
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
                  'nextRoute': AppRoutesName.customize,
                  'tutorialInputKey': TutorialType.paidCustomize.value,
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
