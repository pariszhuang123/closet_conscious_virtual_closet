import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../generated/l10n.dart';

class PublicClosetFeatureBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const PublicClosetFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).publicClosetFeatureTitle,
      description: S.of(context).publicClosetFeatureDescription,
      rpcFunctionName: 'increment_public_closet_request',
    );
  }
}
