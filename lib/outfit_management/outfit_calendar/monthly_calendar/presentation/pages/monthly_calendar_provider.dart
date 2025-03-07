import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utilities/logger.dart';
import 'monthly_calendar_screen.dart';
import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../../../../../item_management/multi_closet/core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../core/data/services/core_save_services.dart';
import '../../../../../core/core_service_locator.dart';
import '../../../../outfit_service_locator.dart';

class MonthlyCalendarProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds;

  const MonthlyCalendarProvider({
    super.key,
    required this.isFromMyCloset,
    this.selectedOutfitIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('MonthlyCalendarProvider');
    logger.i('Initializing MonthlyCalendarProvider with selectedOutfitIds: $selectedOutfitIds');

    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final outfitSaveService = outfitLocator<OutfitSaveService>();
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            logger.i('Creating OutfitSelectionBloc...');
            final bloc = OutfitSelectionBloc(
              outfitFetchService: outfitFetchService,
              logger: logger,
            );
            if (selectedOutfitIds.isNotEmpty) {
              bloc.add(BulkToggleOutfitSelectionEvent(selectedOutfitIds));
            }

            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating MonthlyCalendarMetadataBloc...');
            final bloc = MonthlyCalendarMetadataBloc(
              outfitFetchService: outfitFetchService,
              outfitSaveService: outfitSaveService,
            );
            bloc.add(FetchMonthlyCalendarMetadataEvent());
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating MonthlyCalendarImagesBloc...');
            final imagesBloc = MonthlyCalendarImagesBloc(
              outfitFetchService: outfitFetchService,
              outfitSaveService: outfitSaveService,
            );

            imagesBloc.add(FetchMonthlyCalendarImages(selectedOutfitIds: selectedOutfitIds));
            return imagesBloc;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating CrossAxisCountCubit...');
            final cubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            cubit.fetchCrossAxisCount();
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating CalendarNavigationBloc...');
            final bloc = CalendarNavigationBloc(coreFetchService: coreFetchService);
            bloc.add(CheckCalendarAccessEvent());
            return bloc;
          },
        ),
        BlocProvider(
          create: (_) {
            logger.i('Creating MultiClosetNavigationBloc...');
            final bloc = MultiClosetNavigationBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
            bloc.add(CheckMultiClosetAccessEvent());
            return bloc;
          },
        ),
      ],
      child: MonthlyCalendarScreen(
        isFromMyCloset: isFromMyCloset,
        selectedOutfitIds: selectedOutfitIds,
      ),
    );
  }
}
