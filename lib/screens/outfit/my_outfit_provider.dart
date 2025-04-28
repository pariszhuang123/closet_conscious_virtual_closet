import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../outfit_management/fetch_outfit_items/presentation/bloc/fetch_outfit_item_bloc.dart';
import '../../outfit_management/save_outfit_items/presentation/bloc/save_outfit_items_bloc.dart';
import '../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../outfit_management/core/data/services/outfits_save_services.dart';
import '../../outfit_management/core/outfit_enums.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc/navigate_outfit_bloc.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import 'my_outfit_screen.dart';
import '../../core/utilities/logger.dart';
import '../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../core/data/services/core_fetch_services.dart';
import '../../core/data/services/core_save_services.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/presentation/bloc/navigation_status_cubit/navigation_status_cubit.dart';


class MyOutfitProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;
  final List<String> selectedItemIds;


  // Initialize logger for MyOutfitProvider
  final CustomLogger _logger = CustomLogger('MyOutfitProvider');

  MyOutfitProvider({
    super.key,
    required this.myOutfitTheme,
    required this.selectedItemIds,

  }) {
    _logger.i('MyOutfitProvider initialized with selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building MyOutfitProvider widgets');

    final outfitFetchService = GetIt.instance<OutfitFetchService>();
    final outfitSaveService = GetIt.instance<OutfitSaveService>();
    final coreFetchService = GetIt.instance<CoreFetchService>();
    final coreSaveService = GetIt.instance<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            _logger.d('Initializing FetchOutfitItemBloc');
            final fetchOutfitItemBloc = FetchOutfitItemBloc(outfitFetchService, outfitSaveService)
              ..add(const SelectCategoryEvent(OutfitItemCategory.clothing));
            _logger.i('SelectCategoryEvent added to FetchOutfitItemBloc with category: OutfitItemCategory.clothing');
            return fetchOutfitItemBloc;
          },
        ),
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit()..initializeSelection(selectedItemIds),
        ),

        BlocProvider<SingleSelectionItemCubit>(
          create: (context) => SingleSelectionItemCubit(),
        ),

        BlocProvider(
          create: (context) {
            _logger.d('Initializing NavigateOutfitBloc');
            return NavigateOutfitBloc(outfitFetchService: outfitFetchService, outfitSaveService: outfitSaveService, coreFetchService: coreFetchService);
          },
        ),
        BlocProvider(
          create: (context) {
            _logger.d('Initializing OutfitSaveBloc');
            return SaveOutfitItemsBloc(outfitSaveService);
          },
        ),
        BlocProvider(
          create: (context) {
            _logger.d('Initializing CrossAxisCountCubit');
            final crossAxisCountCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCountCubit.fetchCrossAxisCount(); // Trigger initial fetch
            return crossAxisCountCubit;
          },
        ),
        BlocProvider<TutorialBloc>(
          create: (context) {
            _logger.d('Creating TutorialBloc with core services');
            return TutorialBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
          },
        ),
        BlocProvider(
          create: (context) => NavigationStatusCubit(),
        ),
      ],
      child: MyOutfitScreen(
        myOutfitTheme: myOutfitTheme,
        selectedItemIds: selectedItemIds,
      ),
    );
  }
}
