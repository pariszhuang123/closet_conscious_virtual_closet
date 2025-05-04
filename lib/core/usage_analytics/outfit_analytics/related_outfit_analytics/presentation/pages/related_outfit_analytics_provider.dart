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
  final List<String> selectedOutfitIds;

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
        BlocProvider(create: (_) => SingleOutfitCubit(coreFetchService)),
        BlocProvider(create: (_) => RelatedOutfitsCubit(coreFetchService)),
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
        BlocProvider(
          create: (_) => MultiSelectionOutfitCubit(),
        ),
        BlocProvider(create: (_) => SingleSelectionOutfitCubit()),
      ],
      child: RelatedOutfitAnalyticsScreen(
        isFromMyCloset: isFromMyCloset,
        outfitId: outfitId,
        selectedOutfitIds: selectedOutfitIds,
      ),
    );
  }
}
