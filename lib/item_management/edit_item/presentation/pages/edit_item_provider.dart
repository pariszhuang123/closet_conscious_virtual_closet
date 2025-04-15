import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/edit_item_bloc.dart';
import 'edit_item_screen.dart';
import '../../../core/data/services/item_fetch_service.dart';
import '../../../core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../item_service_locator.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/core_service_locator.dart';
import '../../../../core/data/services/core_save_services.dart';
import '../../../../core/data/services/core_fetch_services.dart';

class EditItemProvider extends StatelessWidget {
  final String itemId;

  final CustomLogger logger = CustomLogger('EditItemProvider');

  EditItemProvider({super.key, required this.itemId});


  @override
  Widget build(BuildContext context) {
    final itemFetchService = itemLocator<ItemFetchService>();
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditItemBloc(itemId: itemId)..add(LoadItemEvent(itemId: itemId, isPending: false)),
        ),
        BlocProvider(
          create: (context) => FetchItemImageCubit(itemFetchService)..fetchItemImage(itemId),
        ),
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
      child: EditItemScreen(itemId: itemId),
    );
  }
}
