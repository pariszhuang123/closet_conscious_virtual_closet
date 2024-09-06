import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../generated/l10n.dart';

class ShareFeatureBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const ShareFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).shareFeatureTitle,
      description: S.of(context).shareFeatureDescription,
      rpcFunctionName: 'increment_share_request',
    );
  }
}
