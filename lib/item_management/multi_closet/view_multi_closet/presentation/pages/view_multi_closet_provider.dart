import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../bloc/view_multi_closet_bloc.dart';
import 'view_multi_closet_screen.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../core/data/services/core_save_services.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../../item_management/multi_closet/core/presentation/bloc/single_selection_closet_cubit/single_selection_closet_cubit.dart';
import '../../../../../item_management/multi_closet/core/presentation/bloc/multi_selection_closet_cubit/multi_selection_closet_cubit.dart';
import '../../../../../core/core_service_locator.dart';


class ViewMultiClosetProvider extends StatelessWidget {
  final bool isFromMyCloset;

  final CustomLogger logger = CustomLogger('ViewMultiClosetProvider');

  ViewMultiClosetProvider({
    required this.isFromMyCloset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MultiClosetNavigationBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
        BlocProvider(
          create: (_) => ViewMultiClosetBloc(
            fetchService: coreFetchService,
          ),
        ),
        BlocProvider(
          create: (_) {
            logger.d('Creating CrossAxisCountCubit');
            return CrossAxisCountCubit(coreFetchService: coreFetchService);
          },
        ),
        BlocProvider(create: (_) => MultiSelectionClosetCubit()),
        BlocProvider(create: (_) => SingleSelectionClosetCubit()),
        BlocProvider<TutorialBloc>(
          create: (context) {
            logger.d('Creating TutorialBloc with core services');
            return TutorialBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
          },
        ),
      ],
      child: ViewMultiClosetScreen(
        isFromMyCloset: isFromMyCloset, // Pass to the screen if needed
      ),
    );
  }
}
