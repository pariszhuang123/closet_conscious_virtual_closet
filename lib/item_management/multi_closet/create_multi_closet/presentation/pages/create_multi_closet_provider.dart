import 'package:closet_conscious/core/data/services/core_save_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/data/services/item_fetch_service.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../core/utilities/logger.dart';
import '../bloc/create_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../core/presentation/bloc/update_closet_metadata_cubit/update_closet_metadata_cubit.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import 'create_multi_closet_screen.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';

class CreateMultiClosetProvider extends StatelessWidget {
  final List<String> selectedItemIds;

  final CustomLogger logger = CustomLogger('CreateMultiClosetProvider');

  CreateMultiClosetProvider({
    super.key,
    required this.selectedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = GetIt.instance<ItemFetchService>();
    final itemSaveService = GetIt.instance<ItemSaveService>();
    final coreFetchService = GetIt.instance<CoreFetchService>();
    final coreSaveService = GetIt.instance<CoreSaveService>();

    logger.i('CreateMultiClosetProvider initialized with selectedItemIds: $selectedItemIds');

    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewItemsBloc>(
          create: (context) => ViewItemsBloc(
            itemFetchService: itemFetchService,
          )..add(FetchItemsEvent(0, isPending: false)), // Fetch items on initialization
        ),
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit()..initializeSelection(selectedItemIds),
        ),
        BlocProvider<SingleSelectionItemCubit>(
          create: (context) => SingleSelectionItemCubit(),
        ),
        // Cubit for metadata update
        BlocProvider<UpdateClosetMetadataCubit>(
          create: (context) => UpdateClosetMetadataCubit(),
        ),

        // Bloc for saving the multi-closet
        BlocProvider<CreateMultiClosetBloc>(
          create: (context) => CreateMultiClosetBloc(
            itemSaveService,
          ),
        ),
        BlocProvider<CrossAxisCountCubit>(
          create: (context) {
            logger.d('Initializing CrossAxisCountCubit');
            final cubit = CrossAxisCountCubit(coreFetchService:coreFetchService);
            cubit.fetchCrossAxisCount(); // Trigger initial fetch
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => MultiClosetNavigationBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
      ],
      child: CreateMultiClosetScreen(
        selectedItemIds: selectedItemIds,
      ),
    );
  }
}
