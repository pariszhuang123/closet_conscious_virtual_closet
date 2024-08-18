import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/core/data/services/outfits_fetch_service.dart'; // Ensure this import is correct
import 'my_outfit_view.dart';

class MyOutfitScreen extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const MyOutfitScreen({super.key, required this.myOutfitTheme});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // Retrieve the required service from GetIt
        final outfitFetchService = GetIt.instance<OutfitFetchService>();

        // Pass the service to the BLoC
        return CreateOutfitItemBloc(outfitFetchService)
          ..add(const SelectCategoryEvent(OutfitItemCategory.clothing));
      },
      child: MyOutfitView(myOutfitTheme: myOutfitTheme),
    );
  }
}
