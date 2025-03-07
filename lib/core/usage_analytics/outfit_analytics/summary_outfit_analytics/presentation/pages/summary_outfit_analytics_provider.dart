import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/summary_outfit_analytics_bloc/summary_outfit_analytics_bloc.dart';
import 'summary_outfit_analytics_screen.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_fetch_services.dart';
import '../../../../../data/services/core_save_services.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/filtered_outfit_cubit/filtered_outfits_cubit.dart';
import '../../../../../core_service_locator.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../../item_management/multi_closet/core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../../../../../../outfit_management/outfit_calendar/core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../../../../../outfit_management/outfit_service_locator.dart';


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
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();
    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final logger = CustomLogger('SummaryOutfitAnalyticsProvider');

    logger.i('Initializing SummaryOutfitAnalyticsProvider for ${isFromMyCloset ? "Closet" : "Outfit"}');

    return MultiBlocProvider(
      providers: [
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
            cubit.fetchFilteredOutfits();  // ✅ Handles outfit filtering separately
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
        BlocProvider(
          create: (context) => FocusOrCreateClosetBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          )..add(FetchFocusOrCreateCloset()),
        ),
        BlocProvider(
          create: (context) => MultiClosetNavigationBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          )..add(CheckMultiClosetAccessEvent()), // Ensure it initializes with access check
        ),
        BlocProvider(
          create: (context) {
            logger.d('Creating OutfitSelectionBloc...');
            return OutfitSelectionBloc(
              outfitFetchService: outfitFetchService,
              logger: CustomLogger('OutfitSelectionBloc'),
            );
          },
        ),
        BlocProvider(
          create: (context) {
            logger.i('Creating OutfitFocusedDateCubit...');
            return OutfitFocusedDateCubit(coreSaveService);
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
