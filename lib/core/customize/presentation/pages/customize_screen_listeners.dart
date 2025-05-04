import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../core_enums.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../presentation/bloc/customize_bloc.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../utilities/helper_functions/navigate_once_helper.dart';

class CustomizeScreenListeners extends StatefulWidget {
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
  State<CustomizeScreenListeners> createState() => _CustomizeScreenListenersState();
}

class _CustomizeScreenListenersState extends State<CustomizeScreenListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomizeBloc, CustomizeState>(
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.saveSuccess) {
              widget.logger.i('Customization saved, navigating back to ${widget.returnRoute}');
              navigateOnce(() {
                context.goNamed(
                  widget.returnRoute,
                  extra: {'selectedItemIds': widget.selectedItemIds},
                );
              });
            } else if (state.accessStatus == AccessStatus.trialPending) {
              widget.logger.i('Trial pending, navigating to trialStarted');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.trialStarted,
                  extra: {
                    'selectedFeatureRoute': AppRoutesName.customize,
                    'isFromMyCloset': widget.isFromMyCloset,
                  },
                );
              });
            } else if (state.accessStatus == AccessStatus.denied) {
              widget.logger.i('Access denied, navigating to payment');
              navigateOnce(() {
                context.goNamed(
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
              });
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              widget.logger.i('Showing tutorial popup');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.customize,
                    'tutorialInputKey': TutorialType.paidCustomize.value,
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
