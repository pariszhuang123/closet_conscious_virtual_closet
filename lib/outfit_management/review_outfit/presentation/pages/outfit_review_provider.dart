import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../../../../core/data/services/core_fetch_services.dart';
import '../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../../core/presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';
import '../bloc/outfit_review_bloc.dart';
import 'outfit_review_screen.dart';
import '../../../../core/core_service_locator.dart';
import '../../../outfit_service_locator.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../../core/outfit_enums.dart';

class OutfitReviewProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const OutfitReviewProvider({
    super.key,
    required this.myOutfitTheme,
  });

  @override
  Widget build(BuildContext context) {
    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final outfitSaveService  = outfitLocator<OutfitSaveService>();
    final coreFetchService   = coreLocator<CoreFetchService>();

    return BlocProvider<OutfitReviewBloc>(
      create: (_) => OutfitReviewBloc(
        outfitFetchService,
        outfitSaveService,
      )..add(CheckAndLoadOutfit(OutfitReviewFeedback.like)),
      child: BlocBuilder<OutfitReviewBloc, OutfitReviewState>(
        builder: (context, state) {
          // Only render providers once outfit data is available
          if (state is OutfitReviewItemsLoaded || state is OutfitImageUrlAvailable) {
            final items = (state is OutfitReviewItemsLoaded)
                ? state.items
                : (state is OutfitImageUrlAvailable)
                ? state.items
                : <ClosetItemMinimal>[];

            return MultiBlocProvider(
              providers: [
                BlocProvider<GridPaginationCubit<ClosetItemMinimal>>(
                  create: (_) => GridPaginationCubit<ClosetItemMinimal>(
                    fetchPage: ({required int pageKey, OutfitItemCategory? category}) async {
                      if (pageKey == 0) return items;
                      return <ClosetItemMinimal>[]; // no more pages after the first
                    },
                    initialCategory: null, // not needed for this screen
                  ),
                ),
                BlocProvider(
                  create: (_) => CrossAxisCountCubit(
                    coreFetchService: coreFetchService,
                  )..fetchCrossAxisCount(),
                ),
                BlocProvider(create: (_) => MultiSelectionItemCubit()),
                BlocProvider(create: (_) => SingleSelectionItemCubit()),
                BlocProvider(
                  create: (_) => PersonalizationFlowCubit(
                    coreFetchService: coreFetchService,
                  )..fetchPersonalizationFlowType(),
                ),
              ],
              child: OutfitReviewScreen(myOutfitTheme: myOutfitTheme),
            );
          }

          // Show loading until valid outfit state is reached
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
