import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../generated/l10n.dart';

class MultiClosetFeatureBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const MultiClosetFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).multiClosetFeatureTitle,
      description: S.of(context).multiClosetFeatureDescription,
      rpcFunctionName: 'increment_multi_closet_request',
    );
  }
}
