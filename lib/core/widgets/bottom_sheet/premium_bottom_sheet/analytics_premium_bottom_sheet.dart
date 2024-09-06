import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';

class PremiumAnalyticsBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const PremiumAnalyticsBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).AnalyticsSearchPremiumFeature,
      description: S.of(context).trackAnalyticsDescription,
      rpcFunctionName: 'increment_analytics_request',
    );
  }
}
