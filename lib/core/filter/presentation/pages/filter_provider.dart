import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/services/core_fetch_services.dart';
import '../../../data/services/core_save_services.dart';
import '../../presentation/bloc/filter_bloc.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import 'filter_screen.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../core_service_locator.dart';
import '../../../../../item_management/multi_closet/core/presentation/bloc/single_selection_closet_cubit/single_selection_closet_cubit.dart';
import '../../../../../item_management/multi_closet/core/presentation/bloc/multi_selection_closet_cubit/multi_selection_closet_cubit.dart';

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
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    logger.d('Building FilterProvider widgets');

    return MultiBlocProvider(
      providers: [
        // FilterBloc for managing filter logic
        BlocProvider<FilterBloc>(
          create: (context) {
            logger.d('Initializing FilterBloc with core services');
            return FilterBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
          },
        ),

        // CrossAxisCountCubit for managing grid layout
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            logger.d('Initializing CrossAxisCountCubit');
            return CrossAxisCountCubit(coreFetchService: coreFetchService);
          },
        ),
        BlocProvider<TutorialBloc>(
          create: (context) {
            logger.d('Initializing TutorialBloc');
            return TutorialBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
          },
        ),
        BlocProvider(create: (_) => MultiSelectionClosetCubit()),
        BlocProvider(create: (_) => SingleSelectionClosetCubit()),
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
