import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/feedback/custom_snack_bar.dart';
import '../../core/achievement_celebration/helper/achievement_navigator.dart';
import '../../core/utilities/app_router.dart';
import '../../core/utilities/logger.dart';
import '../../core/widgets/dialog/trial_ended_dialog.dart';
import '../../generated/l10n.dart';

import '../../core/achievement_celebration/presentation/bloc/achievement_celebration_bloc/achievement_celebration_bloc.dart';
import '../../core/presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../core/photo_library/presentation/bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../core/tutorial/scenario/presentation/bloc/first_time_scenario_bloc.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/core_enums.dart';
import '../../core/utilities/helper_functions/tutorial_helper.dart';
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
        BlocListener<FirstTimeScenarioBloc, FirstTimeScenarioState>(
          listenWhen: (previous, current) => current is FirstTimeCheckSuccess,
          listener: (context, state) {
            if (state is FirstTimeCheckSuccess && state.isFirstTime) {
              context.goNamed(AppRoutesName.goalSelectionProvider);
            }
          },
        ),
        BlocListener<NavigateItemBloc, NavigateItemState>(
          listener: (context, state) {
            if (state is FetchDisappearedClosetsSuccessState) {
              context.pushNamed(
                AppRoutesName.reappearCloset,
                extra: {
                  'closetId': state.closetId,
                  'closetName': state.closetName,
                  'closetImage': state.closetImage,
                },
              );
            }
          },
        ),
        BlocListener<AchievementCelebrationBloc, AchievementCelebrationState>(
          listener: (context, state) {
            if (state is FirstItemUploadedAchievementSuccessState ||
                state is FirstItemGiftedAchievementSuccessState ||
                state is FirstItemSoldAchievementSuccessState ||
                state is FirstItemSwapAchievementSuccessState ||
                state is FirstItemPicEditedAchievementSuccessState) {
              final dynamic s = state;
              handleAchievementNavigationWithTheme(
                context: context,
                achievementKey: s.achievementName,
                badgeUrl: s.badgeUrl,
                nextRoute: AppRoutesName.myCloset,
                isFromMyCloset: true,
              );
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

              final firstTimeState = context.read<FirstTimeScenarioBloc>().state;
              final isNotFirstTimeUser = firstTimeState is FirstTimeCheckFailure ||
                  (firstTimeState is FirstTimeCheckSuccess &&
                      !firstTimeState.isFirstTime);

              if (isNotFirstTimeUser) {
                context.read<TutorialTypeCubit>().setType(TutorialType.freeClosetUpload);
                context.read<TutorialBloc>().add(
                  const CheckTutorialStatus(TutorialType.freeClosetUpload),
                );
              }
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            final lastTriggeredTutorialType = context.read<TutorialTypeCubit>().state;
            logger.i('TutorialBloc state received: ${tutorialState.runtimeType}');
            logger.i('Last triggered tutorial type: $lastTriggeredTutorialType');

            if (tutorialState is ShowTutorial) {
              switch (lastTriggeredTutorialType) {
                case TutorialType.freeUploadCamera:
                  logger.i('Showing tutorial popup for freeUploadCamera');
                  context.goNamed(
                    AppRoutesName.tutorialVideoPopUp,
                    extra: {
                      'nextRoute': AppRoutesName.uploadItemPhoto,
                      'tutorialInputKey': TutorialType.freeUploadCamera.value,
                      'isFromMyCloset': true,
                    },
                  );
                  break;

                case TutorialType.freeClosetUpload:
                  logger.i('Showing tutorial popup for freeClosetUpload');
                  context.goNamed(
                    AppRoutesName.tutorialVideoPopUp,
                    extra: {
                      'nextRoute': AppRoutesName.webView,
                      'tutorialInputKey': TutorialType.freeClosetUpload.value,
                      'isFromMyCloset': true,
                      'optionalUrl': S.of(context).streakBenefitsUrl,
                    },
                  );
                  break;

                default:
                  logger.w('TutorialType is null or unsupported: $lastTriggeredTutorialType');
                  break;
              }
            } else if (tutorialState is SkipTutorial) {
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
