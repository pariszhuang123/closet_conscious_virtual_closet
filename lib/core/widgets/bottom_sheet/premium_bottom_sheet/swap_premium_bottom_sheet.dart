import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';

class SwapFeatureBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const SwapFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).swapFeatureTitle,
      description: S.of(context).swapFeatureDescription,
      rpcFunctionName: 'increment_swap_request',
    );
  }
}
