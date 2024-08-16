import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/outfit_review_bloc.dart';
import 'outfit_review_view.dart';

class OutfitReviewProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;

  const OutfitReviewProvider({
    super.key,
    required this.myOutfitTheme,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OutfitReviewBloc(),
      child: OutfitReview(
        myOutfitTheme: myOutfitTheme,
      ),
    );
  }
}
