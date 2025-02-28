import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/summary_items_bloc.dart';
import 'summary_items_screen.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_fetch_services.dart';
import '../../../../../../item_management/core/data/services/item_fetch_service.dart';
import '../../../../../../user_management/user_service_locator.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../../item_management/view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';

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
    final itemFetchService = GetIt.instance<ItemFetchService>();
    final coreFetchService = GetIt.instance<CoreFetchService>();

    final logger = CustomLogger('SummaryItemsProvider');
    logger.i('Initializing SummaryItemsProvider with isFromMyCloset=$isFromMyCloset');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewItemsBloc>(
          create: (context) => ViewItemsBloc(itemFetchService: itemFetchService)
            ..add(FetchItemsEvent(0)), // Fetch items on initialization
        ),
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit()..initializeSelection(selectedItemIds),
        ),
        BlocProvider<SummaryItemsBloc>(
          create: (context) => SummaryItemsBloc(coreFetchService: coreFetchService)
            ..add(FetchSummaryItemEvent()), // Fetch summary data on initialization
        ),
        BlocProvider<UsageAnalyticsNavigationBloc>(
          create: (context) {
            logger.i('Creating UsageAnalyticsNavigationBloc...');
            final bloc = UsageAnalyticsNavigationBloc(coreFetchService: coreFetchService);
            bloc.add(CheckUsageAnalyticsAccessEvent());
            return bloc;
          },
        ),
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            logger.d('Creating CrossAxisCountCubit');
            final cubit = CrossAxisCountCubit(coreFetchService: locator<CoreFetchService>());
            cubit.fetchCrossAxisCount(); // Fetch cross-axis count from Supabase
            return cubit;
          },
        ),
      ],
      child: SummaryItemsScreen(
        isFromMyCloset: isFromMyCloset,
        selectedItemIds: selectedItemIds, // Pass `selectedItemIds` once
      ),
    );
  }
}
