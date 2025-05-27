import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/summary_items_bloc.dart';
import 'summary_items_screen.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_fetch_services.dart';
import '../../../../../data/services/core_save_services.dart';
import '../../../../../../item_management/core/data/services/item_fetch_service.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../../item_management/view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../../item_management/multi_closet/core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../../../../../../item_management/item_service_locator.dart';
import '../../../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../../../core_service_locator.dart';
import '../../../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../../../outfit_management/core/outfit_enums.dart';

class SummaryItemsProvider extends StatelessWidget {
  final bool isFromMyCloset; // Determines the theme
  final List<String> selectedItemIds;

  const SummaryItemsProvider({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = itemLocator<ItemFetchService>();
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();


    final logger = CustomLogger('SummaryItemsProvider');
    logger.i(
        'Initializing SummaryItemsProvider with isFromMyCloset=$isFromMyCloset');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ViewItemsBloc(itemFetchService: itemFetchService)),
        BlocProvider(create: (_) => MultiSelectionItemCubit()),
        BlocProvider(create: (_) => SingleSelectionItemCubit()),
        BlocProvider(create: (_) =>
            SummaryItemsBloc(coreFetchService: coreFetchService)),
        BlocProvider(create: (_) =>
            UsageAnalyticsNavigationBloc(coreFetchService: coreFetchService)),
        BlocProvider(create: (_) =>
            CrossAxisCountCubit(coreFetchService: coreFetchService)),
        BlocProvider(create: (_) =>
            FocusOrCreateClosetBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            )),
        BlocProvider(create: (_) =>
            MultiClosetNavigationBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            )),
        BlocProvider(create: (_) =>
            TutorialBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            )),
        BlocProvider<GridPaginationCubit<ClosetItemMinimal>>(
          create: (_) => GridPaginationCubit<ClosetItemMinimal>(
            fetchPage: ({
              required int pageKey,
              OutfitItemCategory? category,
            }) => itemFetchService.fetchItems(pageKey), // ignores `category`
            initialCategory: null,
          ),
        ),
      ],
      child: SummaryItemsScreen(
        isFromMyCloset: isFromMyCloset,
        selectedItemIds: selectedItemIds,
      ),
    );
  }
}