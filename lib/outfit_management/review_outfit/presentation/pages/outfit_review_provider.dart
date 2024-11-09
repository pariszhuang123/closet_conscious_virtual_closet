import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/services/outfits_fetch_services.dart';
import '../../../core/data/services/outfits_save_services.dart';
import '../bloc/outfit_review_bloc.dart';
import 'outfit_review_screen.dart';
import 'package:get_it/get_it.dart';


class OutfitReviewProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const OutfitReviewProvider({
    super.key,
    required this.myOutfitTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OutfitReviewBloc(
        GetIt.instance<OutfitFetchService>(),
        GetIt.instance<OutfitSaveService>(),   // Second argument
      ),
      child: OutfitReviewScreen(
        myOutfitTheme: myOutfitTheme,
      ),
    );
  }
}
