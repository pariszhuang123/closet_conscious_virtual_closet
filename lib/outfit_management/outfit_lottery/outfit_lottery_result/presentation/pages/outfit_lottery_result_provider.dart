import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../outfit_lottery_result/presentation/bloc/outfit_lottery_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../../../core/core_service_locator.dart';
import '../../../../outfit_service_locator.dart';
import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../save_outfit_items/presentation/bloc/save_outfit_items_bloc.dart';
import 'outfit_lottery_result_screen.dart';

class OutfitLotteryResultProvider extends StatelessWidget {
  final String? occasion;
  final String? season;
  final bool useAllClosets;

  const OutfitLotteryResultProvider({
    super.key,
    this.occasion,
    this.season,
    required this.useAllClosets,
  });

  @override
  Widget build(BuildContext context) {
    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final coreFetchService = coreLocator<CoreFetchService>();
    final outfitSaveService  = outfitLocator<OutfitSaveService>(); // NEW

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OutfitLotteryBloc(outfitFetchService: outfitFetchService),
        ),
        BlocProvider(
          create: (_) => CrossAxisCountCubit(coreFetchService: coreFetchService),
        ),
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit(),
        ),

        BlocProvider<SingleSelectionItemCubit>(
          create: (context) => SingleSelectionItemCubit(),
        ),
        BlocProvider<SaveOutfitItemsBloc>(
          create: (context) => SaveOutfitItemsBloc(outfitSaveService),
        ),
      ],
      child: OutfitLotteryResultScreen(
        occasion: occasion,
        season: season,
        useAllClosets: useAllClosets,
      ),
    );
  }
}
