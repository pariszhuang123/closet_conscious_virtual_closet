import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/summary_outfit_analytics_bloc/summary_outfit_analytics_bloc.dart';
import 'summary_outfit_analytics_screen.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_fetch_services.dart';
import '../../../../../data/services/core_save_services.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/filtered_outfit_cubit/filtered_outfits_cubit.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';

class SummaryOutfitAnalyticsProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds;
  final List <String> selectedItemIds;

  const SummaryOutfitAnalyticsProvider({
    super.key,
    required this.isFromMyCloset,
    this.selectedOutfitIds = const [],
    this.selectedItemIds = const []

  });

  @override
  Widget build(BuildContext context) {
    final coreFetchService = GetIt.instance<CoreFetchService>();
    final coreSaveService = GetIt.instance<CoreSaveService>();
    final logger = CustomLogger('SummaryOutfitAnalyticsProvider');

    logger.i('Initializing SummaryOutfitAnalyticsProvider for ${isFromMyCloset ? "Closet" : "Outfit"}');

    return MultiBlocProvider(
      providers: [
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit()..initializeSelection(selectedItemIds),
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating UsageAnalyticsNavigationBloc...');
            final bloc = UsageAnalyticsNavigationBloc(coreFetchService: coreFetchService);
            bloc.add(CheckUsageAnalyticsAccessEvent());
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.d('Creating SummaryOutfitAnalyticsBloc...');
            final bloc = SummaryOutfitAnalyticsBloc(coreFetchService, coreSaveService);
            bloc.add(FetchOutfitAnalytics());
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = FilteredOutfitsCubit(coreFetchService);
            cubit.fetchFilteredOutfits(0);  // ✅ Handles outfit filtering separately
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating CrossAxisCountCubit...');
            final cubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            cubit.fetchCrossAxisCount(); // Fetch grid organization settings
            return cubit;
          },
        ),
      ],
      child: SummaryOutfitAnalyticsScreen(
          isFromMyCloset: isFromMyCloset,
          selectedOutfitIds: selectedOutfitIds,
      ),
    );
  }
}
