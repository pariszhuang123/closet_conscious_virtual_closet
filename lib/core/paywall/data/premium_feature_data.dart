import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import '../data/feature_key.dart';

class FeatureData {
  final String Function(BuildContext) getTitle;
  final double price;
  final FeatureKey featureKey;
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
        featureKey: FeatureKey.uploadItemBronze,
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
        getTitle: (context) => S.of(context).uploadItemSilverTitle,
        price: 19.99,
        featureKey: FeatureKey.uploadItemSilver,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).uploadItemSilverDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).uploadItemGoldTitle,
        price: 19.99,
        featureKey: FeatureKey.uploadItemGold,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).uploadItemGoldDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editItemBronzeTitle,
        price: 19.99,
        featureKey: FeatureKey.editItemBronze,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).editItemBronzeDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editItemSilverTitle,
        price: 19.99,
        featureKey: FeatureKey.editItemSilver,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).editItemSilverDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editItemGoldTitle,
        price: 19.99,
        featureKey: FeatureKey.editItemGold,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).editItemGoldDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).selfieBronzeTitle,
        price: 19.99,
        featureKey: FeatureKey.selfieBronze,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).selfieBronzeDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).selfieSilverTitle,
        price: 19.99,
        featureKey: FeatureKey.selfieSilver,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).selfieSilverDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).selfieGoldTitle,
        price: 19.99,
        featureKey: FeatureKey.selfieGold,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://example.com/multiple_outfits.png',
            getDescription: (context) => S.of(context).selfieGoldDescription,
          ),
        ],
      ),

      FeatureData(
        getTitle: (context) => S.of(context).multiOutfitTitle,
        price: 19.99,
        featureKey: FeatureKey.multiOutfit,
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
