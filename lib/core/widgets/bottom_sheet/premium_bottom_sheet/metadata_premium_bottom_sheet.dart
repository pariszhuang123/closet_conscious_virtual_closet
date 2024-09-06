import 'package:flutter/material.dart';
import '../base_bottom_sheet/base_premium_bottom_sheet.dart';
import '../../../../../generated/l10n.dart';

class MetadataFeatureBottomSheet extends StatelessWidget {
  final bool isFromMyCloset;

  const MetadataFeatureBottomSheet({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BasePremiumBottomSheet(
      isFromMyCloset: isFromMyCloset,
      title: S.of(context).metadataFeatureTitle,
      description: S.of(context).metadataFeatureDescription,
      rpcFunctionName: 'increment_metadata_request',
    );
  }
}
