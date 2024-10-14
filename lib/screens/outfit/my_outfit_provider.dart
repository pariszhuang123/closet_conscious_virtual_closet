import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../outfit_management/core/data/services/outfits_save_services.dart';
import '../../outfit_management/core/outfit_enums.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc.dart';
import 'my_outfit_screen.dart';

class MyOutfitProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const MyOutfitProvider({super.key, required this.myOutfitTheme});

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
            final outfitSaveService = GetIt.instance<OutfitSaveService>();
            return NavigateOutfitBloc(outfitFetchService: outfitFetchService, outfitSaveService: outfitSaveService);
          },
        ),
      ],
      child: MyOutfitScreen(myOutfitTheme: myOutfitTheme),
    );
  }
}
