import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../outfit_management/save_outfit_items/presentation/bloc/save_outfit_items_bloc.dart';
import '../../core/widgets/bottom_sheet/usage_bottom_sheet/ai_stylist_usage_bottom_sheet.dart';
import '../../core/utilities/logger.dart';
import '../app_drawer.dart';
import '../../core/theme/ui_constant.dart';
import '../../outfit_management/fetch_outfit_items/presentation/widgets/outfit_feature_container.dart';
import '../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../core/core_enums.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/utilities/app_router.dart';
import '../../outfit_management/fetch_outfit_items/presentation/bloc/fetch_outfit_item_bloc.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc/navigate_outfit_bloc.dart';
import '../../outfit_management/fetch_outfit_items/presentation/widgets/outfit_type_container.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../core/presentation/bloc/navigation_status_cubit/navigation_status_cubit.dart';
import '../../core/widgets/layout/bottom_nav_bar/main_bottom_nav_bar.dart';
import 'my_outfit_bloc_listeners.dart';

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
  final OutfitFetchService _outfitFetchService = GetIt.instance<OutfitFetchService>();

  @override
  void initState() {
    super.initState();
    logger.i('MyOutfitView initialized');
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
    _fetchOutfitsCount();
    _checkNavigationToReview();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchMoreItems();
      }
    });
  }

  void _fetchMoreItems() {
    context.read<FetchOutfitItemBloc>().add(FetchMoreItemsEvent());
  }

  void _onSaveOutfit() {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.read<SaveOutfitItemsBloc>().add(SaveOutfitEvent(selectedItemIds));
  }

  void _checkNavigationToReview() {
    final userId = GetIt.instance<AuthBloc>().userId;
    if (userId != null) {
      context.read<NavigateOutfitBloc>().add(CheckNavigationToReviewEvent(userId: userId));
    }
  }

  void _triggerNpsSurveyIfNeeded() {
    logger.i(
        'Checking if NPS survey should be triggered for outfit count: $newOutfitCount');
    context.read<NavigateOutfitBloc>().add(
        TriggerNpsSurveyEvent(newOutfitCount));
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context
        .read<MultiSelectionItemCubit>()
        .state
        .selectedItemIds;
    context.pushNamed(
      AppRoutesName.filter,
      extra: {
        'isFromMyCloset': isFromMyCloset,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.createOutfit,
      },
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context
        .read<MultiSelectionItemCubit>()
        .state
        .selectedItemIds;
    context.pushNamed(
      AppRoutesName.customize,
      extra: {
        'isFromMyCloset': isFromMyCloset,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.createOutfit,
      },
    );
  }

  void _onCalendarButtonPressed() {
    context.pushNamed(
      AppRoutesName.monthlyCalendar,
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
    try {
      final result = await _outfitFetchService.fetchOutfitsCountAndNPS();
      final count = result['outfits_created'];
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building MyOutfitView...');

    final outfitClothingType = TypeDataList.outfitClothingType(context);
    final outfitAccessoryType = TypeDataList.outfitAccessoryType(context);
    final outfitShoesType = TypeDataList.outfitShoesType(context);

    return Theme(
      data: widget.myOutfitTheme,
      child: MyOutfitBlocListeners(
        logger: logger,
        newOutfitCount: newOutfitCount,
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
                              context.read<NavigationStatusCubit>().setSnackBarShown(false);
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
                                isLocalImage: false,
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