import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';

class AiStylistUsageBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const AiStylistUsageBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).aiStylistFeatureTitle,
      description: S.of(context).aiStylistFeatureDescription,
      rpcFunctionName: 'increment_ai_stylist_usage_request',
    );
  }
}
