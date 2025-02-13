import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';
import '../data/feature_key.dart';

class FeatureData {
  final String Function(BuildContext) getTitle;
  final FeatureKey featureKey;
  final List<FeaturePart> parts; // Each part can have an image and description
  final bool isUsageFeature; // Distinguishes between usage and one-off features

  FeatureData({
    required this.getTitle,
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
        featureKey: FeatureKey.uploadItemBronze,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/upload_item.jpg',
            getDescription: (context) => S.of(context).uploadItemBronzeDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).uploadItemSilverTitle,
        featureKey: FeatureKey.uploadItemSilver,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/upload_item.jpg',
            getDescription: (context) => S.of(context).uploadItemSilverDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).uploadItemGoldTitle,
        featureKey: FeatureKey.uploadItemGold,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/upload_item.jpg',
            getDescription: (context) => S.of(context).uploadItemGoldDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editItemBronzeTitle,
        featureKey: FeatureKey.editItemBronze,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/edit_item.jpg',
            getDescription: (context) => S.of(context).editItemBronzeDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editItemSilverTitle,
        featureKey: FeatureKey.editItemSilver,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/edit_item.jpg',
            getDescription: (context) => S.of(context).editItemSilverDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editItemGoldTitle,
        featureKey: FeatureKey.editItemGold,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/edit_item.jpg',
            getDescription: (context) => S.of(context).editItemGoldDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).selfieBronzeTitle,
        featureKey: FeatureKey.selfieBronze,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/selfie.jpg',
            getDescription: (context) => S.of(context).selfieBronzeDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).selfieSilverTitle,
        featureKey: FeatureKey.selfieSilver,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/selfie.jpg',
            getDescription: (context) => S.of(context).selfieSilverDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).selfieGoldTitle,
        featureKey: FeatureKey.selfieGold,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/selfie.jpg',
            getDescription: (context) => S.of(context).selfieGoldDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editClosetBronzeTitle,
        featureKey: FeatureKey.editClosetBronze,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/view_closet.jpg',
            getDescription: (context) => S.of(context).editClosetBronzeDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editClosetSilverTitle,
        featureKey: FeatureKey.editClosetSilver,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/view_closet.jpg',
            getDescription: (context) => S.of(context).editClosetSilverDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).editClosetGoldTitle,
        featureKey: FeatureKey.editClosetGold,
        isUsageFeature: true,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/view_closet.jpg',
            getDescription: (context) => S.of(context).editClosetGoldDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).multiOutfitTitle,
        featureKey: FeatureKey.multiOutfit,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/multi_outfit.jpg',
            getDescription: (context) => S.of(context).multiOutfitDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).customizeTitle,
        featureKey: FeatureKey.customize ,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/customize.jpg',
            getDescription: (context) => S.of(context).customizeDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/customize_closet.jpg',
            getDescription: (context) => S.of(context).customizeClosetPageDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/customize_outfit.jpg',
            getDescription: (context) => S.of(context).customizeOutfitPageDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).filterFeatureTitle,
        featureKey: FeatureKey.filter,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/filter_basic.jpg',
            getDescription: (context) => S.of(context).basicFilterDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/filter_advance.jpg',
            getDescription: (context) => S.of(context).advancedFilterDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/filter_closet.jpg',
            getDescription: (context) => S.of(context).filterClosetPageDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/filter_outfit.jpg',
            getDescription: (context) => S.of(context).filterOutfitPageDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).MultiClosetFeatureTitle,
        featureKey: FeatureKey.multicloset,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/view_closet.jpg',
            getDescription: (context) => S.of(context).viewMultiClosetDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/create_closet.jpg',
            getDescription: (context) => S.of(context).createMultiClosetDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/swap_closet.jpg',
            getDescription: (context) => S.of(context).editSingleMultiClosetDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/edit_all_closet.jpg',
            getDescription: (context) => S.of(context).editAllMultiClosetDescription,
          ),
        ],
      ),
      FeatureData(
        getTitle: (context) => S.of(context).calendarFeatureTitle,
        featureKey: FeatureKey.calendar,
        isUsageFeature: false,
        parts: [
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/monthly_calendar.jpg',
            getDescription: (context) => S.of(context).viewMonthlyCalendarDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/monthly_calendar_create_closet.jpg',
            getDescription: (context) => S.of(context).createClosetCalendarDescription,
          ),
          FeaturePart(
            imageUrl: 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/InAppPurchase/daily_calendar.jpg',
            getDescription: (context) => S.of(context).viewDailyCalendarDescription,
          ),
        ],
      ),
    ];
  }
}
