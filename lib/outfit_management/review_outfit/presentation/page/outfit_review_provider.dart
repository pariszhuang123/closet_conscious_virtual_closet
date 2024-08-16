import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/outfit_review_bloc.dart';
import 'outfit_review_view.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';

class OutfitReviewProvider extends StatelessWidget {
  final DateTime date;
  final String outfitId;
  final ThemeData myOutfitTheme;
  final AuthBloc authBloc;

  const OutfitReviewProvider({
    super.key,
    required this.date,
    required this.outfitId,
    required this.myOutfitTheme,
    required this.authBloc,
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
