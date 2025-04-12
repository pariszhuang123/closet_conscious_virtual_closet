import 'package:flutter/material.dart';

import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';

class TutorialVideoPart {
  final OnboardingJourneyType journeyType;
  final String youtubeId;
  final String Function(BuildContext) getDescription;

  const TutorialVideoPart({
    required this.journeyType,
    required this.youtubeId,
    required this.getDescription,
  });
}

class TutorialFeatureData {
  final String Function(BuildContext) getTitle;
  final TutorialType tutorialType; // Changed from String
  final List<TutorialVideoPart> videos;

  const TutorialFeatureData({
    required this.getTitle,
    required this.tutorialType,
    required this.videos,
  });
}

class TutorialFeatureList {
  static List<TutorialFeatureData> getTutorials(BuildContext context) {
    return [
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeUploadCameraTitle,
        tutorialType: TutorialType.freeUploadCamera,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'FtwVBMwTAZk',
            getDescription: (context) => S.of(context).tutorialFreeUploadCameraUploadClothing,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeEditCameraTitle,
        tutorialType: TutorialType.freeEditCamera,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: '3X4iSxrs_Gk',
            getDescription: (context) => S.of(context).tutorialFreeEditCameraDeclutterItems,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeCreateOutfitTitle,
        tutorialType: TutorialType.freeCreateOutfit,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'ceueaW0ZDtc',
            getDescription: (context) => S.of(context).tutorialFreeCreateOutfitCreateOutfitProcess,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidFilterTitle,
        tutorialType: TutorialType.paidFilter,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'OvXRbm4hp84',
            getDescription: (context) => S.of(context).tutorialPaidFilterFindInCloset,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidCustomizeTitle,
        tutorialType: TutorialType.paidCustomize,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'KmAB1FiRQpo',
            getDescription: (context) => S.of(context).tutorialPaidCustomizeViewAllItems,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidMultiClosetTitle,
        tutorialType: TutorialType.paidMultiCloset,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'T2KN0vBxGUY',
            getDescription: (context) => S.of(context).tutorialPaidMultiClosetCreateCapsule,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidCalendarTitle,
        tutorialType: TutorialType.paidCalendar,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'Y4kfz7OvVhg',
            getDescription: (context) => S.of(context).tutorialPaidCalendarTrackFirstExperiences,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidUsageAnalyticsTitle,
        tutorialType: TutorialType.paidUsageAnalytics,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'nd8x5qH4AYI',
            getDescription: (context) => S.of(context).tutorialPaidUsageAnalyticsCostPerWear,
          ),
        ],
      ),
    ];
  }
}
