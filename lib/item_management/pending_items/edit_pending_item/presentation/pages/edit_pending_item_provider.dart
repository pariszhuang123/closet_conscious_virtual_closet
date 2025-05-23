import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../edit_item/presentation/bloc/edit_item_bloc.dart';
import 'edit_pending_item_screen.dart';
import '../../../../core/data/services/item_fetch_service.dart';
import '../../../../core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../../item_service_locator.dart';
import '../../../../../core/photo_library/presentation/bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../../../../core/photo_library/usecase/photo_library_service.dart';
import '../../../../../core/core_service_locator.dart';
import '../../../../../core/data/services/core_save_services.dart';

class EditPendingItemProvider extends StatelessWidget {
  final String itemId;

  const EditPendingItemProvider({super.key, required this.itemId});


  @override
  Widget build(BuildContext context) {
    final itemFetchService = itemLocator<ItemFetchService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditItemBloc(itemId: itemId)..add(LoadItemEvent(itemId: itemId, isPending: true)),
        ),
        BlocProvider(
          create: (context) => FetchItemImageCubit(itemFetchService)..fetchItemImage(itemId),
        ),
        BlocProvider<PhotoLibraryBloc>(
          create: (context) => PhotoLibraryBloc(
            photoLibraryService: PhotoLibraryService(
              coreLocator<CoreSaveService>(),
            ),
          ),
        ),
      ],
      child: EditPendingItemScreen(itemId: itemId, key: key),
    );
  }
}
