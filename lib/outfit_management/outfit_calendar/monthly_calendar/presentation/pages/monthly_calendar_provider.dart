import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/utilities/logger.dart';
import 'monthly_calendar_screen.dart';
import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../../core/data/services/core_fetch_services.dart';

class MonthlyCalendarProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;
  final List<String> selectedOutfitIds; // ✅ Add this parameter

  const MonthlyCalendarProvider({
    super.key,
    required this.myOutfitTheme,
    this.selectedOutfitIds = const [], // ✅ Default to empty list
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('MonthlyCalendarProvider');
    logger.i('Initializing MonthlyCalendarProvider...');
    logger.i('Received selected outfits: $selectedOutfitIds'); // ✅ Log selected outfits

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
            final imagesBloc = MonthlyCalendarImagesBloc(
              fetchService: fetchService,
              saveService: saveService,
            );
            imagesBloc.add(SetInitialSelectedOutfits(selectedOutfitIds));

            // 3) Now fetch the calendar images
            imagesBloc.add(FetchMonthlyCalendarImages());

            return imagesBloc;
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
        BlocProvider(
          create: (_) {
            logger.i('Creating CalendarNavigationBloc...');
            final bloc = CalendarNavigationBloc(fetchService: coreFetchService);
            bloc.add(CheckCalendarAccessEvent()); // Dispatch the event to check access
            logger.i('CheckCalendarAccessEvent dispatched.');
            return bloc;
          },
        ),
      ],
      child: MonthlyCalendarScreen(
        theme: myOutfitTheme,
        selectedOutfitIds: selectedOutfitIds, // ✅ Forward to screen
      ),
    );
  }
}
