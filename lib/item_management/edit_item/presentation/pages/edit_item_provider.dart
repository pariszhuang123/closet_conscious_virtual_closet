import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/edit_item_bloc.dart';
import 'edit_item_screen.dart';
import '../../../core/data/services/item_fetch_service.dart';
import '../../../core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../item_service_locator.dart';

class EditItemProvider extends StatelessWidget {
  final String itemId;

  const EditItemProvider({super.key, required this.itemId});


  @override
  Widget build(BuildContext context) {
    final itemFetchService = itemLocator<ItemFetchService>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EditItemBloc(itemId: itemId)..add(LoadItemEvent(itemId: itemId, isPending: false)),
        ),
        BlocProvider(
          create: (context) => FetchItemImageCubit(itemFetchService)..fetchItemImage(itemId),
        ),
      ],
      child: EditItemScreen(itemId: itemId),
    );
  }
}
