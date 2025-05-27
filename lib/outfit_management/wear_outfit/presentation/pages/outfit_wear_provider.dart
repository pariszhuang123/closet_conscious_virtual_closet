import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'outfit_wear_screen.dart';

import '../bloc/outfit_wear_bloc.dart';
import '../../../../core/data/services/core_fetch_services.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../../outfit_service_locator.dart';
import '../../../../core/core_service_locator.dart';
import '../../../core/outfit_enums.dart';

class OutfitWearProvider extends StatelessWidget {
  final String outfitId;

  const OutfitWearProvider({
    super.key,
    required this.outfitId,
  });

  @override
  Widget build(BuildContext context) {
    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final outfitSaveService = outfitLocator<OutfitSaveService>();
    final coreFetchService = coreLocator<CoreFetchService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return OutfitWearBloc(
              outfitFetchService: outfitFetchService,
              outfitSaveService: outfitSaveService,
            );
          },
        ),
        BlocProvider(
          create: (context) {
            final crossAxisCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCubit.fetchCrossAxisCount(); // Initialize the cubit state
            return crossAxisCubit;
          },
        ),
        BlocProvider(
          create: (context) => MultiSelectionItemCubit(), // ✅ Provide MultiSelectionItemCubit
        ),
        BlocProvider<GridPaginationCubit<ClosetItemMinimal>>(
          create: (_) => GridPaginationCubit<ClosetItemMinimal>(
            fetchPage: ({required int pageKey, OutfitItemCategory? category}) async {
              if (pageKey == 0) {
                return await outfitFetchService.fetchOutfitItems(outfitId);
              }
              return <ClosetItemMinimal>[];
            },
            initialCategory: null,
            tag: 'OutfitWearPagination',
          ),
        ),
      ],
      child: OutfitWearScreen(outfitId: outfitId),
    );
  }
}
