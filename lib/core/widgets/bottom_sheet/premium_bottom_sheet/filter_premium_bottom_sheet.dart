import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';

class PremiumFilterBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const PremiumFilterBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).filterSearchPremiumFeature,
      description: S.of(context).quicklyFindItems,
      rpcFunctionName: 'increment_filter_request',
    );
  }
}
