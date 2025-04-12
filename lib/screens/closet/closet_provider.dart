import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';
import '../../item_management/core/data/services/item_fetch_service.dart';
import '../../item_management/view_items/presentation/bloc/view_items_bloc.dart';
import '../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import 'closet_screen.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../core/data/services/core_fetch_services.dart';
import '../../core/data/services/core_save_services.dart';
import '../../core/photo_library/presentation/bloc/photo_library_bloc.dart';
import '../../core/photo_library/usecase/photo_library_service.dart';
import '../../core/tutorial/scenario/presentation/bloc/first_time_scenario_bloc.dart';

class MyClosetProvider extends StatelessWidget {
  final ThemeData myClosetTheme;

  const MyClosetProvider({
    super.key,
    required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = GetIt.instance<ItemFetchService>();
    final coreFetchService = GetIt.instance<CoreFetchService>();
    final coreSaveService = GetIt.instance<CoreSaveService>();
    final photoLibraryService = GetIt.instance<PhotoLibraryService>();

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
        BlocProvider<ViewItemsBloc>(
          create: (context) => ViewItemsBloc()..add(FetchItemsEvent(0, isPending: false)),
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
      ],
      child: MyClosetScreen(
        myClosetTheme: myClosetTheme,
      ),
    );
  }
}
