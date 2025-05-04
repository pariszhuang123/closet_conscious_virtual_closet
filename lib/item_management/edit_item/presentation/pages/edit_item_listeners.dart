import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utilities/app_router.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/utilities/helper_functions/tutorial_helper.dart';
import '../../../../core/utilities/helper_functions/navigate_once_helper.dart';
import '../bloc/edit_item_bloc.dart';

class EditItemListeners extends StatefulWidget {
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
  State<EditItemListeners> createState() => _EditItemListenersState();
}

class _EditItemListenersState extends State<EditItemListeners> with NavigateOnceHelper{

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              widget.logger.i('Tutorial trigger detected for edit item screen');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.editItem,
                    'tutorialInputKey': TutorialType.freeEditCamera.value,
                    'isFromMyCloset': true,
                    'itemId': widget.itemId,
                  },
                );
              });
            }
          },
        ),
        BlocListener<EditItemBloc, EditItemState>(
          listener: (context, state) {
            if (state is EditItemUpdateSuccess) {
              widget.logger.i('Edit success, navigating back to MyCloset');
              navigateOnce(() {
                context.goNamed(AppRoutesName.myCloset);
              });
            } else if (state is EditItemUpdateFailure) {
              widget.logger.e('Edit failed: ${state.errorMessage}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
