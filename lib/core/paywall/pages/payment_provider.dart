import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/bloc/payment_bloc.dart';
import 'payment_screen.dart';
import '../data/feature_key.dart';

class PaymentProvider extends StatelessWidget {
  final FeatureKey featureKey;
  final bool isFromMyCloset;

  const PaymentProvider({
    super.key,
    required this.featureKey,
    required this.isFromMyCloset,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(), // Provide the PaymentBloc
      child: PaymentScreen(featureKey: featureKey, isFromMyCloset: isFromMyCloset), // Child is PaymentScreen
    );
  }
}
