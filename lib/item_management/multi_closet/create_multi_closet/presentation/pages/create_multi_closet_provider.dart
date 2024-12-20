import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/services/item_fetch_service.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/utilities/logger.dart';
import '../bloc/create_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../core/presentation/bloc/update_closet_metadata_cubit/update_closet_metadata_cubit.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import 'create_multi_closet_screen.dart';

class CreateMultiClosetProvider extends StatelessWidget {
  final List<String> selectedItemIds;

  final CustomLogger logger = CustomLogger('CreateMultiClosetProvider');

  CreateMultiClosetProvider({
    super.key,
    required this.selectedItemIds,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = ItemFetchService();
    final itemSaveService = ItemSaveService();

    logger.i('CreateMultiClosetProvider initialized with selectedItemIds: $selectedItemIds');

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
        BlocProvider<UpdateClosetMetadataCubit>(
          create: (context) => UpdateClosetMetadataCubit(),
        ),

        // Bloc for saving the multi-closet
        BlocProvider<CreateMultiClosetBloc>(
          create: (context) => CreateMultiClosetBloc(
            itemSaveService,
          ),
        ),
      ],
      child: CreateMultiClosetScreen(
        selectedItemIds: selectedItemIds,
      ),
    );
  }
}
