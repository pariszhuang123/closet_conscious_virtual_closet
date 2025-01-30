import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utilities/logger.dart';
import 'monthly_calendar_screen.dart';
import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../../core/data/services/core_fetch_services.dart';

class MonthlyCalendarProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const MonthlyCalendarProvider({super.key, required this.myOutfitTheme});

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('MonthlyCalendarProvider');
    logger.i('Initializing MonthlyCalendarProvider...');

    final supabaseClient = Supabase.instance.client;
    logger.i('Supabase client initialized.');

    final fetchService = OutfitFetchService(client: supabaseClient);
    logger.i('OutfitFetchService created.');

    final saveService = OutfitSaveService(client: supabaseClient);
    logger.i('OutfitSaveService created.');

    final coreFetchService = CoreFetchService();
    logger.i('CoreFetchService created.');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            logger.i('Creating MonthlyCalendarMetadataBloc...');
            final bloc = MonthlyCalendarMetadataBloc(
              fetchService: fetchService,
              saveService: saveService,
            );
            bloc.add(FetchMonthlyCalendarMetadataEvent());
            logger.i('FetchMonthlyCalendarMetadataEvent dispatched.');
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating MonthlyCalendarImagesBloc...');
            final bloc = MonthlyCalendarImagesBloc(
              fetchService: fetchService,
              saveService: saveService,
            );
            bloc.add(FetchMonthlyCalendarImages());
            logger.i('FetchMonthlyCalendarImages event dispatched.');
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating CrossAxisCountCubit...');
            final cubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            cubit.fetchCrossAxisCount();
            logger.i('CrossAxisCount fetch operation initiated.');
            return cubit;
          },
        ),
      ],
      child: MonthlyCalendarScreen(
        theme: myOutfitTheme, // Pass myOutfitTheme explicitly if needed
      ),
    );
  }
}
