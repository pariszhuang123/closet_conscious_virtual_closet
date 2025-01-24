import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../bloc/view_multi_closet_bloc.dart';
import 'view_multi_closet_screen.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../core/data/services/core_save_services.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';

class ViewMultiClosetProvider extends StatelessWidget {
  final bool isFromMyCloset;

  final CustomLogger logger = CustomLogger('ViewMultiClosetProvider');

  ViewMultiClosetProvider({
    required this.isFromMyCloset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coreFetchService = GetIt.instance<CoreFetchService>();
    final coreSaveService = GetIt.instance<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MultiClosetNavigationBloc(
            fetchService: coreFetchService,
            saveService: coreSaveService,
          ),
        ),
        BlocProvider(
          create: (_) => ViewMultiClosetBloc(
            fetchService: coreFetchService,
          )..add(FetchViewMultiClosetsEvent()),
        ),
        BlocProvider(
          create: (_) {
            logger.d('Initializing CrossAxisCountCubit');
            final cubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            cubit.fetchCrossAxisCount(); // Trigger initial fetch
            return cubit;
          },
        ),
      ],
      child: ViewMultiClosetScreen(
        isFromMyCloset: isFromMyCloset, // Pass to the screen if needed
      ),
    );
  }
}
