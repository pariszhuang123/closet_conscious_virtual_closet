import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/payment_bloc.dart';
import 'payment_screen.dart';
import '../../data/feature_key.dart';
import '../../../core_enums.dart';

class PaymentProvider extends StatelessWidget {
  final FeatureKey featureKey;
  final bool isFromMyCloset;
  final String previousRoute;
  final String nextRoute;
  final String? outfitId;  // Optional outfitId parameter
  final String? itemId;    // Optional itemId parameter
  final UploadSource? uploadSource;

  const PaymentProvider({
    super.key,
    required this.featureKey,
    required this.isFromMyCloset,
    required this.previousRoute,
    required this.nextRoute,
    this.outfitId,   // Optional, can be null
    this.itemId,     // Optional, can be null
    this.uploadSource,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(), // Provide the PaymentBloc
      child: PaymentScreen(
          featureKey: featureKey,
          isFromMyCloset: isFromMyCloset,
          previousRoute: previousRoute,
          nextRoute: nextRoute,
          outfitId: outfitId,
          itemId: itemId,
          uploadSource: uploadSource,
      ), // Child is PaymentScreen
    );
  }
}
