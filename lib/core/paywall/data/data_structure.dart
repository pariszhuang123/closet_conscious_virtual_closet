import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class FeatureData {
  final String Function(BuildContext) getTitle;
  final double price;
  final String featureKey;
  final List<FeaturePart> parts; // Each part can have an image and description
  final bool isUsageFeature; // Distinguishes between usage and one-off features

  FeatureData({
    required this.getTitle,
    required this.price,
    required this.featureKey,
    required this.parts,
    required this.isUsageFeature,
  });
}

class FeaturePart {
  final String imageUrl;
  final String Function(BuildContext) getDescription;

  FeaturePart({
    required this.imageUrl,
    required this.getDescription,
  });
}

// Example structure for features
class FeatureDataList {
  static List<FeatureData> features(BuildContext context) {
    return [
      FeatureData(
        getTitle: (context) => S.of(context).uploadItemBronzeTitle,
        price: 19.99,
        featureKey: 'upload_bronze_items',
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/bronze_upload.png',
            getDescription: (context) => S.of(context).uploadItemBronzeDescription,
          ),
          FeaturePart(
            imageUrl: 'https://example.com/silver_upload.png',
            getDescription: (context) => S.of(context).uploadItemSilverDescription,
          ),
          FeaturePart(
            imageUrl: 'https://example.com/gold_upload.png',
            getDescription: (context) => S.of(context).uploadItemGoldDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).multiOutfitTitle,
        price: 19.99,
        featureKey: 'multiple_outfits',
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).multiOutfitDescription,
          ),
        ],
      ),
    ];
  }
}
