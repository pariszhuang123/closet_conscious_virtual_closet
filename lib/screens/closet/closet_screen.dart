import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_enums.dart';
import '../../core/widgets/feedback/custom_snack_bar.dart';
import '../../core/achievement_celebration/helper/achievement_navigator.dart';
import '../../core/utilities/app_router.dart';
import '../../core/utilities/logger.dart';
import '../../core/utilities/helper_functions/tutorial_helper.dart';
import '../../core/theme/ui_constant.dart';
import '../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../core/widgets/dialog/trial_ended_dialog.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../core/widgets/layout/bottom_nav_bar/main_bottom_nav_bar.dart';
import '../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../core/photo_library/presentation/bloc/photo_library_bloc.dart';
import '../../core/tutorial/scenario/presentation/bloc/first_time_scenario_bloc.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../item_management/view_items/presentation/bloc/view_items_bloc.dart'; // Import ViewItemsBloc
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';
import '../../item_management/view_items/presentation/widgets/my_closet_container.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/public_closet_premium_bottom_sheet.dart';
import '../../item_management/upload_item/presentation/widgets/upload_confirmation_bottom_sheet.dart';
import '../app_drawer.dart';
import '../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';

class MyClosetScreen extends StatefulWidget {
  final ThemeData myClosetTheme;

  const MyClosetScreen({super.key, required this.myClosetTheme});

  @override
  MyClosetScreenState createState() => MyClosetScreenState();
}

class MyClosetScreenState extends State<MyClosetScreen> {
  final int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  TutorialType? _lastTriggeredTutorialType;
  final CustomLogger logger = CustomLogger('MyClosetPage');

  @override
  void initState() {
    super.initState();
    context.read<UploadStreakBloc>().add(CheckUploadStatus());
    context.read<FirstTimeScenarioBloc>().add(CheckFirstTimeScenario());
    _triggerItemUploadAchievement();
    _triggerItemPicEditedAchievement();
    _triggerItemGiftedAchievement();
    _triggerItemSoldAchievement();
    _triggerItemSwapAchievement();
    _triggerDisappearingClosetPermanent();
    _triggerTrialEndedDialog();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final currentState = context
            .read<ViewItemsBloc>()
            .state;
        if (currentState is ItemsLoaded) {
          final currentPage = currentState.currentPage;
          context.read<ViewItemsBloc>().add(
              FetchItemsEvent(currentPage, isPending: false));
        }
      }
    });
  }

  void _triggerItemUploadAchievement() {
    logger.i('Checking if Item Upload Milestone is successful');
    context.read<NavigateItemBloc>().add(
        const FetchFirstItemUploadedAchievementEvent());
  }

  void _triggerItemPicEditedAchievement() {
    logger.i('Checking if Item Pic Edited Milestone is successful');
    context.read<NavigateItemBloc>().add(
        const FetchFirstItemPicEditedAchievementEvent());
  }

  void _triggerItemGiftedAchievement() {
    logger.i('Checking if Item Gifted Milestone is successful');
    context.read<NavigateItemBloc>().add(
        const FetchFirstItemGiftedAchievementEvent());
  }

  void _triggerItemSoldAchievement() {
    logger.i('Checking if Item Sold Milestone is successful');
    context.read<NavigateItemBloc>().add(
        const FetchFirstItemSoldAchievementEvent());
  }

  void _triggerItemSwapAchievement() {
    logger.i('Checking if Item Swap Milestone is successful');
    context.read<NavigateItemBloc>().add(
        const FetchFirstItemSwapAchievementEvent());
  }

  void _triggerDisappearingClosetPermanent() {
    logger.i('Checking if Disappearing Closet becomes permanent is successful');
    context.read<NavigateItemBloc>().add(const FetchDisappearedClosetsEvent());
  }

  void _triggerTrialEndedDialog() {
    logger.i('Trigger Trial Ended Dialog if it is completed');
    context.read<NavigateItemBloc>().add(const TrialEndedEvent());
  }

  void _onUploadButtonPressed() {
    context.read<PhotoLibraryBloc>().add(CheckForPendingItems());
  }

  void _onPhotoButtonPressed() {
    _lastTriggeredTutorialType = TutorialType.freeUploadCamera;
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.freeUploadCamera),
    );
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    context.pushNamed(
      AppRoutesName.filter,
      extra: {
        'isFromMyCloset': isFromMyCloset,
        'returnRoute': AppRoutesName.myCloset,
      },
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    context.pushNamed(
      AppRoutesName.customize,
      extra: {
        'isFromMyCloset': isFromMyCloset,
        'returnRoute': AppRoutesName.myCloset,
      },
    );
  }

  void _onMultiClosetButtonPressed(BuildContext context, bool isFromMyCloset) {
    context.pushNamed(
      AppRoutesName.viewMultiCloset,
      extra: {
        'isFromMyCloset': isFromMyCloset
      }, // Pass isFromMyCloset as an argument
    );
  }

  void _onPublicClosetButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PublicClosetFeatureBottomSheet(isFromMyCloset: true);
      },
    );
  }

  void _onUploadCompletedButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const UploadConfirmationBottomSheet(isFromMyCloset: true);
      },
    );
  }

  void _onItemSelected(BuildContext context) {
    final itemId = context
        .read<SingleSelectionItemCubit>()
        .state
        .selectedItemId;

    if (itemId != null) {
      logger.i("Navigating to edit Item for itemId: $itemId");

      context.pushNamed(
        AppRoutesName.editItem, // ✅ Ensure this route exists
        extra: itemId,
      );
    } else {
      logger.w("No item selected, navigation not triggered.");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemUploadData = TypeDataList.itemUploaded(context);
    final uploadData = TypeDataList.bulkUpload(context);
    final filterData = TypeDataList.filter(context);
    final arrangeData = TypeDataList.arrange(context);
    final addClosetData = TypeDataList.addCloset(context);
    final publicClosetData = TypeDataList.publicCloset(context);
    final currentStreakData = TypeDataList.currentStreak(context);
    final highestStreakData = TypeDataList.highestStreak(context);
    final costOfNewItemsData = TypeDataList.costOfNewItems(context);
    final numberOfNewItemsData = TypeDataList.numberOfNewItems(context);

    return Theme(
      data: widget.myClosetTheme,
      child: MultiBlocListener(
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
              if (state is FetchFirstItemUploadedMilestoneSuccessState ||
                  state is FetchFirstItemGiftedMilestoneSuccessState ||
                  state is FetchFirstItemSoldMilestoneSuccessState ||
                  state is FetchFirstItemSwapMilestoneSuccessState ||
                  state is FetchFirstItemPicEditedMilestoneSuccessState) {
                final dynamic s = state;
                handleAchievementNavigationWithTheme(
                  context: context,
                  achievementKey: s.achievementName,
                  badgeUrl: s.badgeUrl,
                  nextRoute: AppRoutesName.myCloset,
                  isFromMyCloset: true,
                );
              }
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
              if (state is TrialEndedSuccessState) {
                logger.i(
                    'Trial has ended');
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  // Prevent dismissing by clicking elsewhere
                  builder: (BuildContext dialogContext) {
                    return TrialEndedDialog(
                      onClose: () {
                        Navigator.of(dialogContext).pop(); // Close the dialog
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
                  // Optional: still show snack if closet is empty and not uploaded
                  if (state.apparelCount == 0) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      CustomSnackbar(
                        message: S.of(context).clickUploadItemInCloset,
                        theme: Theme.of(context),
                      ).show(context);
                    });
                  }

                  return; // ❌ Don’t trigger tutorial if not uploaded
                }

                final firstTimeState = context.read<FirstTimeScenarioBloc>().state;

                final isNotFirstTimeUser = firstTimeState is FirstTimeCheckFailure ||
                    (firstTimeState is FirstTimeCheckSuccess && !firstTimeState.isFirstTime);

                if (isNotFirstTimeUser) {
                  _lastTriggeredTutorialType = TutorialType.freeClosetUpload;
                  context.read<TutorialBloc>().add(
                    const CheckTutorialStatus(TutorialType.freeClosetUpload),
                  );
                }
              }
            },
          ),
          BlocListener<TutorialBloc, TutorialState>(
            listener: (context, tutorialState) {
              if (tutorialState is ShowTutorial) {
                switch (_lastTriggeredTutorialType) {
                  case TutorialType.freeUploadCamera:
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
                    break;
                }
              } else if (tutorialState is SkipTutorial) {
                if (_lastTriggeredTutorialType == TutorialType.freeUploadCamera) {
                  context.goNamed(AppRoutesName.uploadItemPhoto);
                }
              }
            },
          )
          ],
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: AppBar(
              title: Text(
                S
                    .of(context)
                    .myClosetTitle,
                style: widget.myClosetTheme.textTheme.titleMedium,
              ),
              automaticallyImplyLeading: true,
              backgroundColor: widget.myClosetTheme.appBarTheme.backgroundColor,
            ),
          ),
          drawer: AppDrawer(isFromMyCloset: true),
          backgroundColor: widget.myClosetTheme.colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                /// UploadStreakBloc just for this section
                BlocBuilder<UploadStreakBloc, UploadStreakState>(
                  builder: (context, uploadStreakState) {
                    if (uploadStreakState is UploadStreakLoading) {
                      return const ClosetProgressIndicator();
                    }

                    if (uploadStreakState is UploadStreakSuccess) {
                      return MyClosetContainer(
                        theme: widget.myClosetTheme,
                        apparelCount: uploadStreakState.apparelCount,
                        uploadData: uploadData,
                        filterData: filterData,
                        arrangeData: arrangeData,
                        addClosetData: addClosetData,
                        publicClosetData: publicClosetData,
                        itemUploadData: itemUploadData,
                        currentStreakData: uploadStreakState.isUploadCompleted
                            ? currentStreakData
                            : null,
                        highestStreakData: uploadStreakState.isUploadCompleted
                            ? highestStreakData
                            : null,
                        costOfNewItemsData: uploadStreakState.isUploadCompleted
                            ? costOfNewItemsData
                            : null,
                        numberOfNewItemsData: uploadStreakState
                            .isUploadCompleted ? numberOfNewItemsData : null,
                        currentStreakCount: uploadStreakState
                            .currentStreakCount,
                        highestStreakCount: uploadStreakState
                            .highestStreakCount,
                        newItemsCost: uploadStreakState.newItemsCost,
                        newItemsCount: uploadStreakState.newItemsCount,
                        isUploadCompleted: uploadStreakState.isUploadCompleted,
                        onUploadButtonPressed: _onUploadButtonPressed,
                        onUploadCompletedButtonPressed: _onUploadCompletedButtonPressed,
                        onFilterButtonPressed: () =>
                            _onFilterButtonPressed(context, true),
                        onArrangeButtonPressed: () =>
                            _onArrangeButtonPressed(context, true),
                        onMultiClosetButtonPressed: () =>
                            _onMultiClosetButtonPressed(context, true),
                        onPublicClosetButtonPressed: _onPublicClosetButtonPressed,
                      );
                    }

                    return const SizedBox.shrink(); // Default fallback
                  },
                ),

                /// ViewItemsBloc + CrossAxisCountCubit for Interactive Grid
                Expanded(
                  child: BlocBuilder<ViewItemsBloc, ViewItemsState>(
                    builder: (context, viewItemsState) {
                      if (viewItemsState is ItemsLoading) {
                        return const ClosetProgressIndicator();
                      }

                      if (viewItemsState is ItemsLoaded) {
                        return BlocBuilder<CrossAxisCountCubit, int>(
                          builder: (context, crossAxisCount) {
                            return InteractiveItemGrid(
                              items: viewItemsState.items,
                              scrollController: _scrollController,
                              crossAxisCount: crossAxisCount,
                              selectedItemIds: const [],
                              itemSelectionMode: ItemSelectionMode.action,
                              enablePricePerWear: false,
                              enableItemName: true,
                              isOutfit: false,
                              isLocalImage: false,
                              onAction: () => _onItemSelected(context),
                            );
                          },
                        );
                      }

                      if (viewItemsState is ItemsError) {
                        return Center(child: Text(
                            'Error: ${viewItemsState.error}'));
                      }

                      return const ClosetProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _onPhotoButtonPressed,
            backgroundColor: widget.myClosetTheme.colorScheme.primary,
            child: const Icon(Icons.camera_alt, size: 30),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
          bottomNavigationBar: MainBottomNavBar(
            currentIndex: _selectedIndex,
            isFromMyCloset: true,
          ),
        ),
      ),
    );
  }
}
