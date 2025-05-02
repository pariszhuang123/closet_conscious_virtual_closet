import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utilities/app_router.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/utilities/helper_functions/tutorial_helper.dart';
import '../bloc/edit_item_bloc.dart';

class EditItemListeners extends StatelessWidget {
  final Widget child;
  final String itemId;
  final CustomLogger logger;

  const EditItemListeners({
    super.key,
    required this.child,
    required this.itemId,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              logger.i('Tutorial trigger detected, navigating to tutorial video pop-up');
              context.goNamed(
                AppRoutesName.tutorialVideoPopUp,
                extra: {
                  'nextRoute': AppRoutesName.editItem,
                  'tutorialInputKey': TutorialType.freeEditCamera.value,
                  'isFromMyCloset': true,
                  'itemId': itemId,
                },
              );
            }
          },
        ),
        BlocListener<EditItemBloc, EditItemState>(
          listener: (context, state) {
            if (state is EditItemUpdateSuccess) {
              logger.i('Update successful, navigating to MyCloset');
              context.goNamed(AppRoutesName.myCloset);
            } else if (state is EditItemUpdateFailure) {
              logger.e('Update failed: ${state.errorMessage}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
