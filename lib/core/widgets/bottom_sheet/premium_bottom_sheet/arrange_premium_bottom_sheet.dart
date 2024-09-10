import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';

class ArrangeFeatureBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const ArrangeFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).arrangeFeatureTitle,
      description: S.of(context).arrangeFeatureDescription,
      rpcFunctionName: 'increment_arrange_request',
    );
  }
}
