import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../daily_calendar/presentation/bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import 'daily_detailed_calendar_screen.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/core_service_locator.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../../outfit_service_locator.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../core/data/services/core_save_services.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';

class DailyDetailedCalendarProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;
  final String? outfitId; // ✅ Accept outfitId as an argument
  final List<String> selectedItemIds; // ✅ Add this parameter

  static final _logger = CustomLogger('DailyCalendarProvider');

  const DailyDetailedCalendarProvider({
    super.key,
    required this.myOutfitTheme,
    this.outfitId, // ✅ Make it optional for flexibility
    this.selectedItemIds = const [], // ✅ Default to empty list to avoid null issues
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyDetailedCalendarProvider');
    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final outfitSaveService = outfitLocator<OutfitSaveService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DailyCalendarBloc(
            outfitFetchService: outfitFetchService,
            outfitSaveService: outfitSaveService,
          ),
        ),
        BlocProvider(
          create: (_) => CrossAxisCountCubit(
            coreFetchService: coreLocator<CoreFetchService>(),
          ),
        ),
        BlocProvider(
          create: (_) {
            final cubit = MultiSelectionItemCubit();
            cubit.initializeSelection(selectedItemIds);
            return cubit;
          },
        ),
        BlocProvider(create: (_) => SingleSelectionItemCubit()),
        BlocProvider(create: (_) => OutfitFocusedDateCubit(coreSaveService)),
        BlocProvider(
          create: (_) => OutfitSelectionBloc(
            outfitFetchService: outfitFetchService,
            logger: CustomLogger('OutfitSelectionBloc'),
          ),
        ),
      ],
      child: DailyDetailedCalendarScreen(
        theme: myOutfitTheme,
        outfitId: outfitId,
      ),
    );
  }
}
