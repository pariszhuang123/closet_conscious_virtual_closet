import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/services/outfits_save_service.dart';
import '../bloc/outfit_review_bloc.dart';
import 'outfit_review_view.dart';
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
      child: OutfitReview(
        myOutfitTheme: myOutfitTheme,
      ),
    );
  }
}
