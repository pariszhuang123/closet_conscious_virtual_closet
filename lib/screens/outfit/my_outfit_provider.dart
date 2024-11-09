import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/select_outfit_items/presentation/bloc/select_outfit_items_bloc.dart';
import '../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../outfit_management/core/data/services/outfits_save_services.dart';
import '../../outfit_management/core/outfit_enums.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc.dart';
import 'my_outfit_screen.dart';
import '../../core/utilities/logger.dart';

class MyOutfitProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;
  final List<String> selectedItemIds;

  // Initialize logger for MyOutfitProvider
  final CustomLogger _logger = CustomLogger('MyOutfitProvider');

  MyOutfitProvider({
    super.key,
    required this.myOutfitTheme,
    required this.selectedItemIds,
  }) {
    _logger.i('MyOutfitProvider initialized with selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building MyOutfitProvider widgets');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            _logger.d('Initializing CreateOutfitItemBloc');
            final outfitFetchService = GetIt.instance<OutfitFetchService>();
            final outfitSaveService = GetIt.instance<OutfitSaveService>();
            _logger.d('Fetched services for CreateOutfitItemBloc: OutfitFetchService and OutfitSaveService');
            final createOutfitItemBloc = CreateOutfitItemBloc(outfitFetchService, outfitSaveService)
              ..add(const SelectCategoryEvent(OutfitItemCategory.clothing));
            _logger.i('SelectCategoryEvent added to CreateOutfitItemBloc with category: OutfitItemCategory.clothing');
            return createOutfitItemBloc;
          },
        ),
        BlocProvider(
          create: (context) {
            _logger.d('Initializing NavigateOutfitBloc');
            final outfitFetchService = GetIt.instance<OutfitFetchService>();
            final outfitSaveService = GetIt.instance<OutfitSaveService>();
            _logger.d('Fetched services for NavigateOutfitBloc: OutfitFetchService and OutfitSaveService');
            return NavigateOutfitBloc(outfitFetchService: outfitFetchService, outfitSaveService: outfitSaveService);
          },
        ),
        BlocProvider(
          create: (context) {
            _logger.d('Initializing SelectionOutfitItemsBloc');
            final outfitSaveService = GetIt.instance<OutfitSaveService>();
            _logger.d('Fetched service for SelectionOutfitItemsBloc: OutfitSaveService');
            return SelectionOutfitItemsBloc(outfitSaveService);
          },
        ),
      ],
      child: MyOutfitScreen(
        myOutfitTheme: myOutfitTheme,
        selectedItemIds: selectedItemIds,
      ),
    );
  }
}
