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
import 'related_outfit_analytics_screen.dart';

class RelatedOutfitAnalyticsProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final String outfitId;

  static final _logger = CustomLogger('RelatedOutfitAnalyticsProvider');

  const RelatedOutfitAnalyticsProvider({
    super.key,
    required this.isFromMyCloset,
    required this.outfitId,
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
      ],
      child: RelatedOutfitAnalyticsScreen(
        isFromMyCloset: isFromMyCloset,
        outfitId: outfitId,
      ),
    );
  }
}
