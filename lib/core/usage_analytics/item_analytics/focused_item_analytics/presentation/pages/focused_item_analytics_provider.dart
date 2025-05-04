import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../item_management/core/data/services/item_fetch_service.dart';
import '../../../../../data/services/core_save_services.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../../../utilities/logger.dart';
import 'focused_items_analytics_screen.dart';
import '../../../../../core_service_locator.dart';
import '../../../../../../item_management/item_service_locator.dart';
import '../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../item_analytics/focused_item_analytics/presentation/bloc/fetch_item_related_outfits_cubit.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../usage_analytics/core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../../outfit_management/core/presentation/bloc/multi_selection_outfit_cubit/multi_selection_outfit_cubit.dart';
import '../../../../../../outfit_management/core/presentation/bloc/single_selection_outfit_cubit/single_selection_outfit_cubit.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';

class FocusedItemsAnalyticsProvider extends StatelessWidget {
  final bool isFromMyCloset; // Determines the theme
  final String itemId;
  final List<String> selectedOutfitIds; // ✅ Pass selected outfits

  const FocusedItemsAnalyticsProvider({
    super.key,
    required this.isFromMyCloset,
    required this.itemId,
    this.selectedOutfitIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = itemLocator<ItemFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();
    final coreFetchService = coreLocator<CoreFetchService>();

    final logger = CustomLogger('FocusedItemsAnalyticsProvider');

    logger.i('Initializing FocusedItemsAnalyticsProvider for item ID: $itemId');

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FetchItemImageCubit(itemFetchService)),
        BlocProvider(create: (_) => FetchItemRelatedOutfitsCubit(coreFetchService)),
        BlocProvider(create: (_) => CrossAxisCountCubit(coreFetchService: coreFetchService)),
        BlocProvider(create: (_) => OutfitFocusedDateCubit(coreSaveService)),
        BlocProvider(create: (_) => MultiSelectionItemCubit()),
        BlocProvider(create: (_) => UsageAnalyticsNavigationBloc(coreFetchService: coreFetchService)),
        BlocProvider(
          create: (_) => FocusOrCreateClosetBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
        BlocProvider(create: (_) => MultiSelectionOutfitCubit()),
        BlocProvider(create: (_) => SingleSelectionOutfitCubit()),
      ],
      child: FocusedItemsAnalyticsScreen(
          isFromMyCloset: isFromMyCloset,
          itemId: itemId,
          selectedOutfitIds: selectedOutfitIds,
      ),
    );
  }
}
