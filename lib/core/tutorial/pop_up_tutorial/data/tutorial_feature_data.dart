import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';

class TutorialVideoPart {
  final String youtubeId;
  final String Function(BuildContext) getDescription;

  const TutorialVideoPart({
    required this.youtubeId,
    required this.getDescription,
  });
}

class TutorialFeatureData {
  final String Function(BuildContext) getTitle;
  final String tutorialInputKey;
  final List<TutorialVideoPart> videos;

  const TutorialFeatureData({
    required this.getTitle,
    required this.tutorialInputKey,
    required this.videos,
  });
}

class TutorialFeatureList {
  static List<TutorialFeatureData> getTutorials(BuildContext context) {
    return [
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeUploadCameraTitle,
        tutorialInputKey: 'free_upload_camera',
        videos: [
          TutorialVideoPart(
            youtubeId: 'FtwVBMwTAZk',
            getDescription: (context) => S.of(context).tutorialFreeUploadCameraUploadClothing,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeEditCameraTitle,
        tutorialInputKey: 'free_edit_camera',
        videos: [
          TutorialVideoPart(
            youtubeId: '3X4iSxrs_Gk',
            getDescription: (context) => S.of(context).tutorialFreeEditCameraDeclutterItems,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeCreateOutfitTitle,
        tutorialInputKey: 'free_create_outfit',
        videos: [
          TutorialVideoPart(
            youtubeId: 'ceueaW0ZDtc',
            getDescription: (context) => S.of(context).tutorialFreeCreateOutfitCreateOutfitProcess,
          ),
          TutorialVideoPart(
            youtubeId: 'SeEzPZrvZJY',
            getDescription: (context) => S.of(context).tutorialFreeCreateOutfitReviewOutfit,
          ),
          TutorialVideoPart(
            youtubeId: 'UX2xjPBG5AA',
            getDescription: (context) => S.of(context).tutorialFreeCreateOutfitOutfitSuggestion,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidFilterTitle,
        tutorialInputKey: 'paid_filter',
        videos: [
          TutorialVideoPart(
            youtubeId: 'OvXRbm4hp84',
            getDescription: (context) => S.of(context).tutorialPaidFilterFindInCloset,
          ),
          TutorialVideoPart(
            youtubeId: 'D99Th66kQ2A',
            getDescription: (context) => S.of(context).tutorialPaidFilterSellUnworn,
          ),
          TutorialVideoPart(
            youtubeId: 'jLCNT--f6MA',
            getDescription: (context) => S.of(context).tutorialPaidFilterTrackFiltering,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidCustomizeTitle,
        tutorialInputKey: 'paid_customize',
        videos: [
          TutorialVideoPart(
            youtubeId: 'KmAB1FiRQpo',
            getDescription: (context) => S.of(context).tutorialPaidCustomizeViewAllItems,
          ),
          TutorialVideoPart(
            youtubeId: 'DP4-OW6WJ9k',
            getDescription: (context) => S.of(context).tutorialPaidCustomizeCustomizeOrder,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidMultiClosetTitle,
        tutorialInputKey: 'paid_multi_closet',
        videos: [
          TutorialVideoPart(
            youtubeId: 'T2KN0vBxGUY',
            getDescription: (context) => S.of(context).tutorialPaidMultiClosetCreateCapsule,
          ),
          TutorialVideoPart(
            youtubeId: '3CHu_udq3sQ',
            getDescription: (context) => S.of(context).tutorialPaidMultiClosetViewUsableItems,
          ),
          TutorialVideoPart(
            youtubeId: 'D99Th66kQ2A',
            getDescription: (context) => S.of(context).tutorialPaidMultiClosetCreatePublicClosets,
          ),
          TutorialVideoPart(
            youtubeId: '5wvQ-NBpZmU',
            getDescription: (context) => S.of(context).tutorialPaidMultiClosetDeleteClosets,
          ),
          TutorialVideoPart(
            youtubeId: 'Sj1CPF1oHI0',
            getDescription: (context) => S.of(context).tutorialPaidMultiClosetSwapClosets,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidCalendarTitle,
        tutorialInputKey: 'paid_calendar',
        videos: [
          TutorialVideoPart(
            youtubeId: 'Y4kfz7OvVhg',
            getDescription: (context) => S.of(context).tutorialPaidCalendarTrackFirstExperiences,
          ),
          TutorialVideoPart(
            youtubeId: '0a1u3EVJeZI',
            getDescription: (context) => S.of(context).tutorialPaidCalendarPlanTrips,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidUsageAnalyticsTitle,
        tutorialInputKey: 'paid_usage_analytics',
        videos: [
          TutorialVideoPart(
            youtubeId: 'nd8x5qH4AYI',
            getDescription: (context) => S.of(context).tutorialPaidUsageAnalyticsCostPerWear,
          ),
          TutorialVideoPart(
            youtubeId: 'UX2xjPBG5AA',
            getDescription: (context) => S.of(context).tutorialPaidUsageAnalyticsOutfitSuggestions,
          ),
          TutorialVideoPart(
            youtubeId: '3Bii2qw-jFA',
            getDescription: (context) => S.of(context).tutorialPaidUsageAnalyticsInspirationForTrips,
          ),
          TutorialVideoPart(
            youtubeId: 'D99Th66kQ2A',
            getDescription: (context) => S.of(context).tutorialPaidUsageAnalyticsSellUnworn,
          ),
        ],
      ),
      // Add more as needed...
    ];
  }
}
