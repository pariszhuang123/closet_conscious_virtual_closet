import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'outfit_wear_screen.dart';
import 'package:get_it/get_it.dart';

import '../bloc/outfit_wear_bloc.dart';
import '../../../../core/data/services/core_fetch_services.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';

class OutfitWearProvider extends StatelessWidget {
  final String outfitId;

  const OutfitWearProvider({
    super.key,
    required this.outfitId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final outfitFetchService = GetIt.instance<OutfitFetchService>();
            final outfitSaveService = GetIt.instance<OutfitSaveService>();
            return OutfitWearBloc(
              outfitFetchService: outfitFetchService,
              outfitSaveService: outfitSaveService,
            );
          },
        ),
        BlocProvider(
          create: (context) {
            final coreFetchService = GetIt.instance<CoreFetchService>();
            final crossAxisCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCubit.fetchCrossAxisCount(); // Initialize the cubit state
            return crossAxisCubit;
          },
        ),
        BlocProvider(
          create: (context) => MultiSelectionItemCubit(), // ✅ Provide MultiSelectionItemCubit
        ),
      ],
      child: OutfitWearScreen(outfitId: outfitId),
    );
  }
}
