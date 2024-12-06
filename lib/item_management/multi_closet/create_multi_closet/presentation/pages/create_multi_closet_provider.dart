import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/services/item_fetch_service.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/utilities/logger.dart';
import '../bloc/create_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import 'create_multi_closet_screen.dart';

class CreateMultiClosetProvider extends StatelessWidget {

  final CustomLogger logger = CustomLogger('CreateMultiClosetProvider');

  CreateMultiClosetProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = ItemFetchService();
    final itemSaveService = ItemSaveService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ViewItemsBloc>(
          create: (context) => ViewItemsBloc(
            itemFetchService: itemFetchService,
          )..add(FetchItemsEvent(0)), // Fetch items on initialization
        ),
        BlocProvider<CreateMultiClosetBloc>(
          create: (context) => CreateMultiClosetBloc(
            itemSaveService,
            itemFetchService,
          ),
        ),
      ],
      child: const CreateMultiClosetScreen(),
    );
  }
}
