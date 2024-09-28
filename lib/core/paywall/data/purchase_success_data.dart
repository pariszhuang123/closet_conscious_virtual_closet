import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import '../data/feature_key.dart';  // Import your enum here

class PurchaseSuccessData {
  final String Function(BuildContext) getSuccessTitle;
  final String Function(BuildContext) getSuccessMessage;
  final FeatureKey featureKey;  // Use FeatureKey enum instead of String

  PurchaseSuccessData({
    required this.getSuccessTitle,
    required this.getSuccessMessage,
    required this.featureKey,
  });
}

class SuccessPart {
  final String imageUrl;
  final String Function(BuildContext) getDescription;

  SuccessPart({
    required this.imageUrl,
    required this.getDescription,
  });
}

class PurchaseSuccessDataList {
  static List<PurchaseSuccessData> successfulPurchases(BuildContext context) {
    return [
      PurchaseSuccessData(
        getSuccessTitle: (context) => S.of(context).uploadItemBronzeSuccessTitle,
        getSuccessMessage: (context) => S.of(context).uploadItemBronzeSuccessMessage,
        featureKey: FeatureKey.uploadItemBronze,  // Use enum here
      ),
      PurchaseSuccessData(
        getSuccessTitle: (context) => S.of(context).uploadItemSilverSuccessTitle,
        getSuccessMessage: (context) => S.of(context).uploadItemSilverSuccessMessage,
        featureKey: FeatureKey.uploadItemSilver,  // Use enum here
      ),
      PurchaseSuccessData(
        getSuccessTitle: (context) => S.of(context).uploadItemGoldSuccessTitle,
        getSuccessMessage: (context) => S.of(context).uploadItemGoldSuccessMessage,
        featureKey: FeatureKey.uploadItemGold,  // Use enum here
      )
    ];
  }
}