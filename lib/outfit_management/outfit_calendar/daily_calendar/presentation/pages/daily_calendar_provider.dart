import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../core/data/services/core_save_services.dart';
import 'daily_calendar_screen.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/core_service_locator.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../outfit_service_locator.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';

class DailyCalendarProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;
  final String? outfitId;
  final List<String> selectedItemIds;

  static final _logger = CustomLogger('DailyCalendarProvider');

  const DailyCalendarProvider({
    super.key,
    required this.myOutfitTheme,
    this.outfitId,
    this.selectedItemIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyCalendarProvider');
    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final outfitSaveService = outfitLocator<OutfitSaveService>();
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<DailyCalendarBloc>(
          create: (context) {
            _logger.d('Creating DailyCalendarBloc');
            return DailyCalendarBloc(
              outfitFetchService: outfitFetchService,
              outfitSaveService: outfitSaveService,
            );
          },
        ),
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            _logger.d('Creating CrossAxisCountCubit');
            return CrossAxisCountCubit(
              coreFetchService: coreFetchService,
            );
          },
        ),
        BlocProvider(
          create: (_) {
            _logger.i('Creating MultiSelectionItemCubit...');
            final cubit = MultiSelectionItemCubit();
            cubit.initializeSelection(selectedItemIds);
            _logger.i('MultiSelectionItemCubit initialized with selected items.');
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            _logger.i('Creating CalendarNavigationBloc...');
            return CalendarNavigationBloc(coreFetchService: coreFetchService);
          },
        ),
        BlocProvider(
          create: (_) {
            _logger.i('Creating OutfitFocusedDateCubit...');
            return OutfitFocusedDateCubit(coreSaveService);
          },
        ),
        BlocProvider(
          create: (_) {
            _logger.d('Creating OutfitSelectionBloc...');
            return OutfitSelectionBloc(
              outfitFetchService: outfitFetchService,
              logger: CustomLogger('OutfitSelectionBloc'),
            );
          },
        ),
      ],
      child: DailyCalendarScreen(
        myOutfitTheme: myOutfitTheme,
        outfitId: outfitId,
      ),
    );
  }
}
