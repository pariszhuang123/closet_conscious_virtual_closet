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
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc/navigate_outfit_bloc.dart';
import '../../outfit_management/fetch_outfit_items/presentation/widgets/outfit_type_container.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../core/widgets/layout/bottom_nav_bar/main_bottom_nav_bar.dart';
import '../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';
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
  int newOutfitCount = 2;
  final OutfitFetchService _outfitFetchService = GetIt.instance<OutfitFetchService>();

  @override
  void initState() {
    super.initState();
    logger.i('MyOutfitView initialized');
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
    _fetchOutfitsCount();
    _checkNavigationToReview();
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
    logger.i('Checking if NPS survey should be triggered for outfit count: $newOutfitCount');
    context.read<NavigateOutfitBloc>().add(TriggerNpsSurveyEvent(newOutfitCount));
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.pushNamed(AppRoutesName.filter, extra: {
      'isFromMyCloset': isFromMyCloset,
      'selectedItemIds': selectedItemIds,
      'returnRoute': AppRoutesName.createOutfit,
    });
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.pushNamed(AppRoutesName.customize, extra: {
      'isFromMyCloset': isFromMyCloset,
      'selectedItemIds': selectedItemIds,
      'returnRoute': AppRoutesName.createOutfit,
    });
  }

  void _onCalendarButtonPressed() {
    context.pushNamed(AppRoutesName.monthlyCalendar);
  }

  void _onAiStylistButtonPressed() {
    logger.i('AI Stylist button pressed');
    showModalBottomSheet(
      context: context,
      builder: (context) => const AiStylistUsageBottomSheet(isFromMyCloset: false),
    );
  }

  Future<void> _fetchOutfitsCount() async {
    try {
      final result = await _outfitFetchService.fetchOutfitsCountAndNPS();
      if (mounted) {
        setState(() {
          newOutfitCount = result['outfits_created'];
        });
        _triggerNpsSurveyIfNeeded();
      }
    } catch (e) {
      logger.e('Error fetching outfit count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building MyOutfitScreen');

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
                title: Text(S.of(context).myOutfitTitle,
                    style: widget.myOutfitTheme.textTheme.titleMedium),
                backgroundColor: widget.myOutfitTheme.appBarTheme.backgroundColor,
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
                    onCategorySelected: (newCategory) {
                      context.read<GridPaginationCubit<ClosetItemMinimal>>()
                          .updateCategory(newCategory);
                    },
                  ),
                  const SizedBox(height: 16),
                  OutfitFeatureContainer(
                    theme: widget.myOutfitTheme,
                    outfitCount: newOutfitCount,
                    onFilterButtonPressed: () => _onFilterButtonPressed(context, false),
                    onArrangeButtonPressed: () => _onArrangeButtonPressed(context, false),
                    onCalendarButtonPressed: _onCalendarButtonPressed,
                    onStylistButtonPressed: _onAiStylistButtonPressed,
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: BlocBuilder<CrossAxisCountCubit, int>(
                      builder: (context, crossAxisCount) {
                        return InteractiveItemGrid(
                          usePagination: true,
                          itemSelectionMode: ItemSelectionMode.multiSelection,
                          crossAxisCount: crossAxisCount,
                          selectedItemIds: widget.selectedItemIds,
                          isOutfit: false,
                          isLocalImage: false,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                      builder: (context, state) {
                        return state.hasSelectedItems
                            ? ElevatedButton(
                          onPressed: _onSaveOutfit,
                          child: Text(S.of(context).OutfitDay),
                        )
                            : const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: MainBottomNavBar(
              currentIndex: _selectedIndex,
              isFromMyCloset: false,
            ),
          ),
        ),
      ),
    );
  }
}
