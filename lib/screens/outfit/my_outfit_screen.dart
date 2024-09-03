import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/core/data/services/outfits_fetch_service.dart';
import '../../outfit_management/core/data/services/outfits_save_service.dart';
import '../../outfit_management/navigate_outfit/presentation/bloc/navigate_outfit_bloc.dart';
import 'my_outfit_view.dart';

class MyOutfitScreen extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const MyOutfitScreen({super.key, required this.myOutfitTheme});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final outfitFetchService = GetIt.instance<OutfitFetchService>();
            final outfitSaveService = GetIt.instance<OutfitSaveService>();
            return CreateOutfitItemBloc(outfitFetchService, outfitSaveService)
              ..add(const SelectCategoryEvent(OutfitItemCategory.clothing));
          },
        ),
        BlocProvider(
          create: (context) {
            final outfitFetchService = GetIt.instance<OutfitFetchService>();
            return NavigateOutfitBloc(outfitFetchService: outfitFetchService);
          },
        ),
      ],
      child: MyOutfitView(myOutfitTheme: myOutfitTheme),
    );
  }
}
