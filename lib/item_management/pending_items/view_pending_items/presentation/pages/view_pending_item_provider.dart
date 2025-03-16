import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../view_items/presentation/bloc/view_items_bloc.dart'; // Import ViewItemsBloc
import '../../../../core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';

import 'view_pending_item_screen.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/data/services/core_fetch_services.dart';

class ViewPendingItemProvider extends StatelessWidget {
  final ThemeData myClosetTheme;

  const ViewPendingItemProvider({
    super.key,
    required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    final coreFetchService = GetIt.instance<CoreFetchService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewItemsBloc>(
          create: (context) => ViewItemsBloc()..add(FetchItemsEvent(0, isPending: true)),
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

      ],
      child: ViewPendingItemScreen(
        myClosetTheme: myClosetTheme,
      ),
    );
  }
}
