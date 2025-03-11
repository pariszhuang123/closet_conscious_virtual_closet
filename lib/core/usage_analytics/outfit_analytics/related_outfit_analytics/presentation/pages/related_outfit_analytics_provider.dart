import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utilities/logger.dart';
import '../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../../core/data/services/core_save_services.dart';
import '../../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../presentation/bloc/single_outfit_cubit/single_outfit_cubit.dart';
import '../../presentation/bloc/related_outfits_cubit/related_outfits_cubit.dart';
import '../../../../../../core/core_service_locator.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../usage_analytics/core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import 'related_outfit_analytics_screen.dart';
import '../../../../../../outfit_management/core/presentation/bloc/multi_selection_outfit_cubit/multi_selection_outfit_cubit.dart';
import '../../../../../../outfit_management/core/presentation/bloc/single_selection_outfit_cubit/single_selection_outfit_cubit.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';

class RelatedOutfitAnalyticsProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final String outfitId;
  final List<String> selectedOutfitIds; // ✅ Pass selected outfits

  static final _logger = CustomLogger('RelatedOutfitAnalyticsProvider');

  const RelatedOutfitAnalyticsProvider({
    super.key,
    required this.isFromMyCloset,
    required this.outfitId,
    this.selectedOutfitIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Initializing RelatedOutfitAnalyticsProvider with outfitId: $outfitId');

    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        // ✅ Fetch Main Outfit
        BlocProvider(
          create: (_) {
            _logger.i('Creating FetchOutfitCubit...');
            final cubit = SingleOutfitCubit(coreFetchService);
            cubit.fetchOutfit(outfitId);
            return cubit;
          },
        ),

        // ✅ Fetch Related Outfits
        BlocProvider(
          create: (_) {
            _logger.i('Creating RelatedOutfitsCubit...');
            final cubit = RelatedOutfitsCubit(coreFetchService);
            cubit.fetchRelatedOutfits(outfitId: outfitId);
            return cubit;
          },
        ),

        // ✅ Fetch CrossAxisCount for Layout
        BlocProvider(
          create: (_) {
            _logger.i('Creating CrossAxisCountCubit...');
            final cubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            cubit.fetchCrossAxisCount();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            _logger.i('Creating OutfitFocusedDateCubit...');
            return OutfitFocusedDateCubit(coreSaveService);
          },
        ),
        BlocProvider(
          create: (_) {
            _logger.i('Creating MultiSelectionItemCubit...');
            final cubit = MultiSelectionItemCubit();
            cubit.initializeSelection;
            return cubit;
          },
        ),
        BlocProvider<UsageAnalyticsNavigationBloc>(
          create: (context) {
            _logger.i('Creating UsageAnalyticsNavigationBloc...');
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
            _logger.i('Creating MultiSelectionOutfitCubit with selectedOutfitIds: $selectedOutfitIds');
            final cubit = MultiSelectionOutfitCubit();
            cubit.initializeSelection(selectedOutfitIds); // ✅ Pass correct data
            return cubit;
          },
        ),
        BlocProvider<SingleSelectionOutfitCubit>(
          create: (_) {
            _logger.i('Creating SingleSelectionOutfitCubit...');
            return SingleSelectionOutfitCubit();
          },
        ),
      ],
      child: RelatedOutfitAnalyticsScreen(
        isFromMyCloset: isFromMyCloset,
        outfitId: outfitId,
        selectedOutfitIds: selectedOutfitIds,
      ),
    );
  }
}
