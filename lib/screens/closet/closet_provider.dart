import 'package:closet_conscious/item_management/item_service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';
import '../../item_management/core/data/services/item_fetch_service.dart';
import '../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import 'closet_screen.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../core/achievement_celebration/presentation/bloc/achievement_celebration_bloc/achievement_celebration_bloc.dart';
import '../../core/data/services/core_fetch_services.dart';
import '../../core/data/services/core_save_services.dart';
import '../../core/photo_library/presentation/bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../core/photo_library/usecase/photo_library_service.dart';
import '../../core/tutorial/scenario/presentation/bloc/first_time_scenario_bloc.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/tutorial/core/presentation/bloc/tutorial_cubit.dart';
import '../../core/presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';
import 'my_closet_access_wrapper.dart';
import '../../core/core_service_locator.dart';
import '../../outfit_management/outfit_service_locator.dart';
import '../outfit/achievement_wrapper.dart';
import '../../outfit_management/core/outfit_enums.dart';

class MyClosetProvider extends StatelessWidget {
  final ThemeData myClosetTheme;

  const MyClosetProvider({
    super.key,
    required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = itemLocator<ItemFetchService>();
    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();
    final photoLibraryService = coreLocator<PhotoLibraryService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UploadStreakBloc>(
          create: (context) => UploadStreakBloc()..add(CheckUploadStatus()),
        ),
        BlocProvider<NavigateItemBloc>(
          create: (context) => NavigateItemBloc(
            itemFetchService: itemFetchService,
            coreFetchService: coreFetchService
          ),
        ),
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            final crossAxisCountCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCountCubit.fetchCrossAxisCount(); // Trigger initial fetch
            return crossAxisCountCubit;
          },
        ),
        BlocProvider<SingleSelectionItemCubit>(
          create: (_) {
            return SingleSelectionItemCubit();
          },
        ),
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit(),
        ),
        BlocProvider<PhotoLibraryBloc>( // ✅ register PhotoLibraryBloc here
          create: (_) => PhotoLibraryBloc(
            photoLibraryService: photoLibraryService,
            itemFetchService: itemFetchService,
          ),
        ),
        BlocProvider<FirstTimeScenarioBloc>(
          create: (_) => FirstTimeScenarioBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          )..add(CheckFirstTimeScenario()),
        ),
        BlocProvider<TutorialBloc>(
          create: (context) {
            return TutorialBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
          },
        ),
        BlocProvider<TutorialTypeCubit>(
          create: (_) => TutorialTypeCubit(),
        ),
        BlocProvider<AchievementCelebrationBloc>(
          create: (_) => AchievementCelebrationBloc(
            outfitFetchService: outfitFetchService,
          ),
        ),
        BlocProvider<TrialBloc>(
          create: (_) => TrialBloc(coreFetchService),
        ),
        BlocProvider<GridPaginationCubit<ClosetItemMinimal>>(
          create: (_) => GridPaginationCubit<ClosetItemMinimal>(
            fetchPage: ({
              required int pageKey,
              OutfitItemCategory? category,
            }) => itemFetchService.fetchItems(pageKey), // ignores `category`
            initialCategory: null,
          ),
        ),
      ],
      child: MyClosetAccessWrapper(
    child: AchievementWrapper(
      isFromMyCloset: true,
      child: MyClosetScreen(myClosetTheme: myClosetTheme),
          ),
      ),
    );
  }
}
