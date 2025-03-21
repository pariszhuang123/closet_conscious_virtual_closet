import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../outfit_management/save_outfit_items/presentation/bloc/save_outfit_items_bloc.dart';
import '../../core/widgets/bottom_sheet/usage_bottom_sheet/ai_stylist_usage_bottom_sheet.dart';
import '../../core/utilities/logger.dart';
import '../app_drawer.dart';
import '../../core/theme/ui_constant.dart';
import '../../core/widgets/feedback/custom_snack_bar.dart';
import '../../outfit_management/fetch_outfit_items/presentation/widgets/outfit_feature_container.dart';
import '../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../core/core_enums.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/utilities/routes.dart';
import '../../outfit_management/fetch_outfit_items/presentation/bloc/fetch_outfit_item_bloc.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc/navigate_outfit_bloc.dart';
import '../../outfit_management/fetch_outfit_items/presentation/widgets/outfit_type_container.dart';
import '../../outfit_management/user_nps_feedback/presentation/nps_dialog.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../core/screens/achievement_completed_screen.dart';
import '../../core/paywall/data/feature_key.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../core/widgets/layout/bottom_nav_bar/main_bottom_nav_bar.dart';

class MyOutfitScreen extends StatefulWidget {
  final ThemeData myOutfitTheme;
  final List<String> selectedItemIds;

  const MyOutfitScreen({
    super.key,
    required this.myOutfitTheme,
    required this.selectedItemIds,
  });

  @override
  MyOutfitScreenState createState() => MyOutfitScreenState();

}

class MyOutfitScreenState extends State<MyOutfitScreen> {
  final int _selectedIndex = 1;
  final CustomLogger logger = CustomLogger('OutfitPage');
  final ScrollController _scrollController = ScrollController();
  int newOutfitCount = 2;
  bool _snackBarShown = false;
  bool _isNavigating = false; // New flag to track if navigation is in progress

  final OutfitFetchService _outfitFetchService = GetIt.instance<
      OutfitFetchService>();

  @override
  void initState() {
    super.initState();
    logger.i('MyOutfitView initialized');
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount(); // Trigger fetch
    _fetchOutfitsCount();
    _checkNavigationToReview(context);
    _triggerClothingAchievement();
    _triggerNoBuyAchievement(); // Call the method after setting the outfit count
    _triggerOutfitCreation();
    _triggerOutfitCreateAchievement();
    _triggerSelfieTakenAchievement();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        logger.i('Reached the end of the list, fetching more items...');
        _fetchMoreItems();
      }
    });
  }

  void _fetchMoreItems() {
    logger.i('Fetching more items...');
    context.read<FetchOutfitItemBloc>().add(FetchMoreItemsEvent());
  }

  void _onSaveOutfit() {
    logger.i('Save outfit button pressed');
    final selectedItemIds = context
        .read<MultiSelectionItemCubit>()
        .state
        .selectedItemIds;
    logger.d('Selected items: $selectedItemIds');

    context.read<SaveOutfitItemsBloc>().add(SaveOutfitEvent(selectedItemIds));
  }

  void _checkNavigationToReview(BuildContext context) {
    final userId = GetIt
        .instance<AuthBloc>()
        .userId; // Access userId from AuthBloc

    if (userId != null) {
      logger.i(
          'Attempting to check navigation to review pages with userId: $userId');
      context.read<NavigateOutfitBloc>().add(
          CheckNavigationToReviewEvent(userId: userId));
    } else {
      logger.e('Error: userId is null. Cannot check navigation to review.');
    }
  }

  void _triggerNpsSurveyIfNeeded() {
    logger.i(
        'Checking if NPS survey should be triggered for outfit count: $newOutfitCount');
    context.read<NavigateOutfitBloc>().add(
        TriggerNpsSurveyEvent(newOutfitCount));
  }


  void _triggerClothingAchievement() {
    logger.i('Checking if Clothing Achievement Milestone is successful');
    context.read<NavigateOutfitBloc>().add(
        const FetchAndSaveClothingWornAchievementEvent());
  }

  void _triggerNoBuyAchievement() {
    logger.i('Checking if Clothing Achievement Milestone is successful');
    context.read<NavigateOutfitBloc>().add(
        const FetchAndSaveNoBuyMilestoneAchievementEvent());
  }


  void _triggerOutfitCreateAchievement() {
    logger.i('Checking if Outfit Create Milestone is successful');
    context.read<NavigateOutfitBloc>().add(
        const FetchFirstOutfitCreatedAchievementEvent());
  }

  void _triggerSelfieTakenAchievement() {
    logger.i('Checking if Selfie Taken Milestone is successful');
    context.read<NavigateOutfitBloc>().add(
        const FetchFirstSelfieTakenAchievementEvent());
  }

  void _triggerOutfitCreation() {
    logger.i('Checking if Outfit can be created');
    context.read<NavigateOutfitBloc>().add(
        const CheckOutfitCreationAccessEvent());
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context
        .read<MultiSelectionItemCubit>()
        .state
        .selectedItemIds;
    Navigator.of(context).pushNamed(
      AppRoutes.filter,
      arguments: {
        'isFromMyCloset': isFromMyCloset,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.createOutfit,
      },
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context
        .read<MultiSelectionItemCubit>()
        .state
        .selectedItemIds;
    Navigator.of(context).pushNamed(
      AppRoutes.customize,
      arguments: {
        'isFromMyCloset': isFromMyCloset,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.createOutfit,
      },
    );
  }

  void _onCalendarButtonPressed() {
    Navigator.of(context).pushNamed(
      AppRoutes.monthlyCalendar,
    );
  }

  void _onAiStylistButtonPressed() {
    logger.i('AI Stylist button pressed, showing ai stylist...');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AiStylistUsageBottomSheet(isFromMyCloset: false);
      },
    );
  }

  Future<void> _fetchOutfitsCount() async {
    logger.i('Fetching outfits count...');
    try {
      final result = await _outfitFetchService.fetchOutfitsCountAndNPS();
      final count = result['outfits_created'];

      logger.i('Outfits count fetched: $count');

      if (mounted) {
        setState(() {
          newOutfitCount = count;
        });
        logger.i('New outfit count set to $newOutfitCount');
        _triggerNpsSurveyIfNeeded();
      }
    } catch (e) {
      logger.e('Error fetching new outfits count: $e');
    }
  }

  @override
  void dispose() {
    logger.i('Disposing MyOutfitView...');
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building MyOutfitView...');

    final outfitClothingType = TypeDataList.outfitClothingType(context);
    final outfitAccessoryType = TypeDataList.outfitAccessoryType(context);
    final outfitShoesType = TypeDataList.outfitShoesType(context);

    return Theme( // Apply the relevant theme higher up
      data: widget.myOutfitTheme,
      child: MultiBlocListener( // BlocListener now inside the theme
        listeners: [
          BlocListener<NavigateOutfitBloc, NavigateOutfitState>(
            listener: (context, state) {
              logger.i(
                  'NavigateOutfitBloc listener triggered with state: $state');
              if (state is NpsSurveyTriggeredState) {
                logger.i(
                    'NPS Survey triggered for milestone: ${state.milestone}');
                NpsDialog(milestone: state.milestone).showNpsDialog(context);
              }
              if (state is NavigateToReviewPageState) {
                logger.i(
                    'Navigating to OutfitReviewProvider for outfitId: ${state
                        .outfitId}');
                _isNavigating =
                true; // Set navigating to true when navigating to review page
                Navigator.pushNamed(
                  context,
                  AppRoutes.reviewOutfit,
                ).then((_) {
                  _isNavigating = false; // Reset navigating after returning
                });
              }
              if (state is FetchAndSaveClothingAchievementMilestoneSuccessState) {
                logger.i(
                    'Navigating to achievement pages for achievement: ${state
                        .badgeUrl}');
                _isNavigating =
                true; // Set navigating to true when navigating to review page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Theme(
                          data: widget.myOutfitTheme,
                          // Apply the relevant theme
                          child: AchievementScreen(
                            achievementKey: state.achievementName,
                            achievementUrl: state.badgeUrl,
                            // Pass the badge URL
                            nextRoute: AppRoutes
                                .createOutfit, // Define the next route if needed
                          ),
                        ),
                  ),
                ).then((_) {
                  _isNavigating = false; // Reset navigating after returning
                });
              }
              if (state is FetchAndSaveNoBuyMilestoneSuccessState) {
                logger.i(
                    'Navigating to achievement pages for achievement: ${state
                        .badgeUrl}');
                _isNavigating =
                true; // Set navigating to true when navigating to review page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Theme(
                          data: widget.myOutfitTheme,
                          // Apply the relevant theme
                          child: AchievementScreen(
                            achievementKey: state.achievementName,
                            achievementUrl: state.badgeUrl,
                            // Pass the badge URL
                            nextRoute: AppRoutes
                                .createOutfit, // Define the next route if needed
                          ),
                        ),
                  ),
                ).then((_) {
                  _isNavigating = false; // Reset navigating after returning
                });
              }
              if (state is FetchFirstOutfitMilestoneSuccessState) {
                logger.i(
                    'Navigating to achievement pages for achievement: ${state
                        .badgeUrl}');
                _isNavigating =
                true; // Set navigating to true when navigating to review page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Theme(
                          data: widget.myOutfitTheme,
                          // Apply the relevant theme
                          child: AchievementScreen(
                            achievementKey: state.achievementName,
                            achievementUrl: state.badgeUrl,
                            // Pass the badge URL
                            nextRoute: AppRoutes
                                .createOutfit, // Define the next route if needed
                          ),
                        ),
                  ),
                ).then((_) {
                  _isNavigating = false; // Reset navigating after returning
                });
              }
              if (state is FetchFirstSelfieTakenMilestoneSuccessState) {
                logger.i(
                    'Navigating to achievement pages for achievement: ${state
                        .badgeUrl}');
                _isNavigating =
                true; // Set navigating to true when navigating to review page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Theme(
                          data: widget.myOutfitTheme,
                          // Apply the relevant theme
                          child: AchievementScreen(
                            achievementKey: state.achievementName,
                            achievementUrl: state.badgeUrl,
                            // Pass the badge URL
                            nextRoute: AppRoutes
                                .createOutfit, // Define the next route if needed
                          ),
                        ),
                  ),
                ).then((_) {
                  _isNavigating = false; // Reset navigating after returning
                });
              }
              if (state is MultiOutfitAccessState) {
                if (state.accessStatus == AccessStatus.denied) {
                  logger.w('Access denied: Navigating to payment page');
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.multiOutfit,
                      'isFromMyCloset': false,
                      'previousRoute': AppRoutes.myCloset,
                      'nextRoute': AppRoutes.createOutfit,
                    },
                  );
                } else if (state.accessStatus == AccessStatus.trialPending) {
                  logger.i('Trial pending, navigating to trialStarted screen');
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.trialStarted,
                    arguments: {
                      'selectedFeatureRoute': AppRoutes.myCloset,
                      // ✅ Correct AppRoutes value
                      'isFromMyCloset': false,
                    },
                  );
                }
              }
            },
          ),
          BlocListener<SaveOutfitItemsBloc, SaveOutfitItemsState>(
            listener: (context, state) {
              if (state.saveStatus == SaveStatus.success &&
                  state.outfitId != null) {
                logger.i('Navigating to OutfitWearProvider for outfitId: ${state
                    .outfitId}');
                Navigator.pushNamed(
                    context, AppRoutes.wearOutfit, arguments: state.outfitId);
              }
              if (state.saveStatus == SaveStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(S
                      .of(context)
                      .failedToSaveOutfit)),
                );
              }
            },
          ),
          BlocListener<FetchOutfitItemBloc, FetchOutfitItemState>(
            listener: (context, state) {
              logger.i(
                  'CreateOutfitItemBloc listener triggered with state: $state');

              if (state.saveStatus == SaveStatus.success &&
                  state.outfitId != null) {
                logger.i('Navigating to OutfitWearProvider for outfitId: ${state
                    .outfitId}');
                _isNavigating =
                true; // Set navigating to true when navigating to wear outfit page
                Navigator.pushNamed(
                  context,
                  AppRoutes.wearOutfit,
                  arguments: state.outfitId,
                ).then((_) =>
                _isNavigating = false); // Reset navigating after returning
              }

              // Show SnackBar if no items are selected
              if (!state.hasSelectedItems && !_snackBarShown &&
                  !_isNavigating && newOutfitCount == 0) {
                _isNavigating =
                true; // Prevent the SnackBar from showing during navigation
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final snackBar = CustomSnackbar(
                    message: S
                        .of(context)
                        .selectItemsToCreateOutfit,
                    theme: Theme.of(context),
                  );
                  snackBar.show(
                      context); // Call show separately, don't treat it like a value
                  _snackBarShown =
                  true; // Set the flag to true after the snackbar is shown
                  _isNavigating = false; // Reset after SnackBar is shown
                });
              }
            },
          ),
        ],
        child: PopScope(
          canPop: false,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(appBarHeight),
              child: AppBar(
                title: Text(S
                    .of(context)
                    .myOutfitTitle,
                    style: widget.myOutfitTheme.textTheme.titleMedium),
                automaticallyImplyLeading: true,
                backgroundColor: widget.myOutfitTheme.appBarTheme
                    .backgroundColor,
              ),
            ),
            drawer: AppDrawer(isFromMyCloset: false),
            backgroundColor: widget.myOutfitTheme.colorScheme.surface,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  OutfitTypeContainer(
                    outfitClothingType: outfitClothingType,
                    outfitAccessoryType: outfitAccessoryType,
                    outfitShoesType: outfitShoesType,
                    theme: widget.myOutfitTheme,
                  ),
                  const SizedBox(height: 16),
                  OutfitFeatureContainer(
                    theme: widget.myOutfitTheme,
                    outfitCount: newOutfitCount,
                    onFilterButtonPressed: () =>
                        _onFilterButtonPressed(context, false),
                    onArrangeButtonPressed: () =>
                        _onArrangeButtonPressed(context, false),
                    onCalendarButtonPressed: _onCalendarButtonPressed,
                    onStylistButtonPressed: _onAiStylistButtonPressed,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: BlocBuilder<CrossAxisCountCubit, int>(
                      builder: (context, crossAxisCount) {
                        return BlocBuilder<
                            FetchOutfitItemBloc,
                            FetchOutfitItemState>(
                          builder: (context, state) {
                            logger.i(
                                'FetchOutfitItemBloc builder triggered with state: $state');

                            final currentItems =
                                state.categoryItems[state.currentCategory] ??
                                    [];

                            if (state.saveStatus == SaveStatus.failure) {
                              return Center(
                                  child: Text(S
                                      .of(context)
                                      .failedToLoadItems));
                            } else if (currentItems.isEmpty) {
                              _snackBarShown = false;
                              return Center(
                                  child: Text(S
                                      .of(context)
                                      .noItemsInOutfitCategory));
                            } else {
                              return InteractiveItemGrid(
                                scrollController: _scrollController,
                                items: currentItems,
                                itemSelectionMode: ItemSelectionMode.multiSelection,
                                crossAxisCount: crossAxisCount,
                                selectedItemIds: widget.selectedItemIds,
                                isOutfit: false,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<
                        MultiSelectionItemCubit,
                        MultiSelectionItemState>(
                      builder: (context, state) {
                        logger.i(
                            'SelectionOutfitItemBloc bottom button builder triggered with state: $state');
                        return state.hasSelectedItems
                            ? ElevatedButton(
                          onPressed: _onSaveOutfit,
                          child: Text(S
                              .of(context)
                              .OutfitDay),
                        )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: MainBottomNavBar(
              currentIndex: _selectedIndex, // My Outfit tab
              isFromMyCloset: false, // This is the outfit screen, not the closet
            ),
          ),
        ),
      ),
    );
  }
}