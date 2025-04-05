import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../presentation/bloc/filter_bloc.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import 'filter_screen.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';

class FilterProvider extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;
  final List<String> selectedOutfitIds;
  final String returnRoute;
  final bool showOnlyClosetFilter;

  final CustomLogger logger = CustomLogger('FilterProvider');

  FilterProvider({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
    required this.selectedOutfitIds,
    required this.returnRoute,
    required this.showOnlyClosetFilter,
  }) {
    logger.i('FilterProvider initialized with isFromMyCloset: $isFromMyCloset and selectedItemIds: $selectedItemIds and selectedOutfitIds: $selectedOutfitIds');
  }

  @override
  Widget build(BuildContext context) {
    // Fetch services from GetIt
    final coreFetchService = GetIt.instance<CoreFetchService>();
    final coreSaveService = GetIt.instance<CoreSaveService>();

    logger.d('Building FilterProvider widgets');

    return MultiBlocProvider(
      providers: [
        // FilterBloc for managing filter logic
        BlocProvider<FilterBloc>(
          create: (context) {
            logger.d('Initializing FilterBloc with core services');
            final filterBloc = FilterBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
            filterBloc.add(LoadFilterEvent());
            return filterBloc;
          },
        ),

        // CrossAxisCountCubit for managing grid layout
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            logger.d('Initializing CrossAxisCountCubit');
            final crossAxisCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCubit.fetchCrossAxisCount(); // Trigger initial fetch
            return crossAxisCubit;
          },
        ),
        BlocProvider<TutorialBloc>(
          create: (context) {
            logger.d('Initializing TutorialBloc');
            return TutorialBloc(
              fetchService: coreFetchService,
              saveService: coreSaveService,
            );
          },
        ),
      ],
      child: FilterScreen(
        isFromMyCloset: isFromMyCloset,
        selectedItemIds: selectedItemIds,
        selectedOutfitIds: selectedOutfitIds,
        returnRoute: returnRoute,
        showOnlyClosetFilter: showOnlyClosetFilter,
      ),
    );
  }
}
