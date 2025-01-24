import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/data/services/item_fetch_service.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/utilities/logger.dart';
import '../bloc/edit_multi_closet_bloc/edit_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import 'edit_multi_closet_screen.dart';
import '../bloc/edit_closet_metadata_bloc/edit_closet_metadata_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/data/services/core_fetch_services.dart';

class EditMultiClosetProvider extends StatelessWidget {
  final List<String> selectedItemIds;

  final CustomLogger logger = CustomLogger('EditMultiClosetProvider');

  EditMultiClosetProvider({
    super.key,
    required this.selectedItemIds,

  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = GetIt.instance<ItemFetchService>();
    final itemSaveService = GetIt.instance<ItemSaveService>();
    final coreFetchService = GetIt.instance<CoreFetchService>();

    logger.i('EditMultiClosetProvider initialized with selectedItemIds: $selectedItemIds');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewItemsBloc>(
          create: (context) => ViewItemsBloc(
            itemFetchService: itemFetchService,
          )..add(FetchItemsEvent(0)), // Fetch items on initialization
        ),
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit()..initializeSelection(selectedItemIds),
        ),

        // Cubit for metadata update
        BlocProvider<EditClosetMetadataBloc>(
          create: (context) => EditClosetMetadataBloc(itemFetchService: itemFetchService),
        ),

        // Bloc for saving the multi-closet
        BlocProvider<EditMultiClosetBloc>(
          create: (context) => EditMultiClosetBloc(
            itemSaveService,
          ),
        ),
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            logger.d('Initializing CrossAxisCountCubit');
            final crossAxisCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCubit.fetchCrossAxisCount(); // Trigger initial fetch
            return crossAxisCubit;
          },
        ),
      ],
      child: EditMultiClosetScreen(
        selectedItemIds: selectedItemIds,
      ),
    );
  }
}
