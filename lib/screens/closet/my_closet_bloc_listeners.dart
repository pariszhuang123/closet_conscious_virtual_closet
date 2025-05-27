import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/feedback/custom_snack_bar.dart';
import '../../core/utilities/app_router.dart';
import '../../core/utilities/logger.dart';
import '../../core/widgets/dialog/trial_ended_dialog.dart';
import '../../generated/l10n.dart';

import '../../core/presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../core/photo_library/presentation/bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/core_enums.dart';
import '../../core/tutorial/core/presentation/bloc/tutorial_cubit.dart';

class MyClosetBlocListeners extends StatelessWidget {
  final Widget child;

  const MyClosetBlocListeners({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('MyClosetListeners');

    return MultiBlocListener(
      listeners: [
        BlocListener<PhotoLibraryBloc, PhotoLibraryState>(
          listener: (context, state) {
            if (state is PhotoLibraryPendingItem) {
              context.pushNamed(AppRoutesName.viewPendingItem);
            } else if (state is PhotoLibraryNoPendingItem) {
              context.pushNamed(AppRoutesName.pendingPhotoLibrary);
            }
          },
        ),
        BlocListener<TrialBloc, TrialState>(
          listener: (context, state) {
            if (state is TrialEndedSuccessState) {
              logger.i('Trial has ended');
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext dialogContext) {
                  return TrialEndedDialog(
                    onClose: () {
                      Navigator.of(dialogContext).pop();
                    },
                  );
                },
              );
            }
          },
        ),
        BlocListener<UploadStreakBloc, UploadStreakState>(
          listener: (context, state) {
            if (state is UploadStreakSuccess) {
              if (!state.isUploadCompleted) {
                if (state.apparelCount == 0) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    CustomSnackbar(
                      message: S.of(context).clickUploadItemInCloset,
                      theme: Theme.of(context),
                    ).show(context);
                  });
                }
                return;
              }

            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            final lastTriggeredTutorialType = context.read<TutorialTypeCubit>().state;
            logger.i('TutorialBloc state received: ${tutorialState.runtimeType}');
            logger.i('Last triggered tutorial type: $lastTriggeredTutorialType');

            if (tutorialState is SkipTutorial) {
              if (lastTriggeredTutorialType == TutorialType.freeUploadCamera) {
                logger.i('SkipTutorial — navigating to uploadItemPhoto');
                context.pushNamed(AppRoutesName.uploadItemPhoto);
              } else {
                logger.w('SkipTutorial received but tutorial type was null');
              }

              // ✅ Clear cubit to avoid future confusion
              context.read<TutorialTypeCubit>().clear();
            }
          },
        ),
      ],
      child: child,
    );
  }
}
