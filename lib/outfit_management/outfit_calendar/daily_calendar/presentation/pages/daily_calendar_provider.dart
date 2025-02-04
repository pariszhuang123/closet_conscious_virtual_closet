import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import 'daily_calendar_screen.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/core_service_locator.dart';
import '../../../../outfit_service_locator.dart';

class DailyCalendarProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;

  static final _logger = CustomLogger('DailyCalendarProvider');

  const DailyCalendarProvider({
    super.key,
    required this.myOutfitTheme,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyCalendarProvider');

    return MultiBlocProvider(
      providers: [
        // Provide the DailyCalendarBloc
        BlocProvider<DailyCalendarBloc>(
          create: (context) {
            _logger.d('Creating DailyCalendarBloc');
            return DailyCalendarBloc(
                outfitFetchService: getIt<OutfitFetchService>(),
                outfitSaveService: getIt<OutfitSaveService>())
              ..add(const FetchDailyCalendarEvent()); // Fetch latest data from Supabase
          },
        ),
        // Provide the CrossAxisCountCubit
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            _logger.d('Creating CrossAxisCountCubit');
            return CrossAxisCountCubit(
                coreFetchService: coreLocator<CoreFetchService>())
              ..fetchCrossAxisCount();
          },
        ),
      ],
      // Wrap content in CalendarScaffold
      child: DailyCalendarScreen(
        theme: myOutfitTheme, // Pass myOutfitTheme explicitly if needed
      ),
    );
  }
}
