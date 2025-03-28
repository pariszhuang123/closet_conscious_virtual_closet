import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../item_management/core/data/services/item_fetch_service.dart';
import '../../../../../data/services/core_save_services.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../../core/presentation/bloc/navigate_to_item_cubit/navigate_to_item_cubit.dart';
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
        BlocProvider<FetchItemImageCubit>(
          create: (_) {
            logger.i('Creating FetchItemImageCubit...');
            final cubit = FetchItemImageCubit(itemFetchService);
            cubit.fetchItemImage(itemId);
            return cubit;
          },
        ),
        BlocProvider<NavigateToItemCubit>(
          create: (_) => NavigateToItemCubit(coreSaveService),
        ),
        BlocProvider<FetchItemRelatedOutfitsCubit>(
          create: (_) {
            logger.i('Creating FetchItemRelatedOutfitsCubit...');
            final cubit = FetchItemRelatedOutfitsCubit(coreFetchService);
            cubit.fetchItemRelatedOutfits(itemId: itemId);
            return cubit;
          },
        ),

        /// **Fetches CrossAxisCount for Outfit Grid**
        BlocProvider<CrossAxisCountCubit>(
          create: (_) {
            logger.i('Creating CrossAxisCountCubit...');
            final cubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            cubit.fetchCrossAxisCount();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            logger.i('Creating OutfitFocusedDateCubit...');
            return OutfitFocusedDateCubit(coreSaveService);
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating MultiSelectionItemCubit...');
            final cubit = MultiSelectionItemCubit();
            cubit.initializeSelection;
            return cubit;
          },
        ),
        BlocProvider<UsageAnalyticsNavigationBloc>(
          create: (context) {
            logger.i('Creating UsageAnalyticsNavigationBloc...');
            final bloc = UsageAnalyticsNavigationBloc(coreFetchService: coreFetchService);
            bloc.add(CheckUsageAnalyticsAccessEvent());
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => FocusOrCreateClosetBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          )..add(FetchFocusOrCreateCloset()),
        ),
        BlocProvider<MultiSelectionOutfitCubit>(
          create: (_) {
            logger.i('Creating MultiSelectionOutfitCubit with selectedOutfitIds: $selectedOutfitIds');
            final cubit = MultiSelectionOutfitCubit();
            cubit.initializeSelection(selectedOutfitIds); // ✅ Pass correct data
            return cubit;
          },
        ),
        BlocProvider<SingleSelectionOutfitCubit>(
          create: (_) {
            logger.i('Creating SingleSelectionOutfitCubit...');
            return SingleSelectionOutfitCubit();
          },
        ),
      ],
      child: FocusedItemsAnalyticsScreen(
          isFromMyCloset: isFromMyCloset,
          itemId: itemId,
          selectedOutfitIds: selectedOutfitIds,
      ),
    );
  }
}
