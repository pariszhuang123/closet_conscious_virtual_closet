import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../../../../core/data/services/core_fetch_services.dart';
import '../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../bloc/outfit_review_bloc.dart';
import 'outfit_review_screen.dart';
import 'package:get_it/get_it.dart';

class OutfitReviewProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const OutfitReviewProvider({
    super.key,
    required this.myOutfitTheme,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OutfitReviewBloc(
            GetIt.instance<OutfitFetchService>(),
            GetIt.instance<OutfitSaveService>(),
          ),
        ),
        BlocProvider(
          create: (context) {
            final coreFetchService = GetIt.instance<CoreFetchService>();
            final crossAxisCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCubit.fetchCrossAxisCount(); // Fetch initial state
            return crossAxisCubit;
          },
        ),
      ],
      child: OutfitReviewScreen(
        myOutfitTheme: myOutfitTheme,
      ),
    );
  }
}
