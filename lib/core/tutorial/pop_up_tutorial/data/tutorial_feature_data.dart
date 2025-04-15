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
  static List<TutorialFeatureData> getTutorials() {
    return [
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeUploadCameraTitle,
        tutorialType: TutorialType.freeUploadCamera,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'KvOLPU87i74',
            getDescription: (context) => S.of(context).memoryTutorialFreeUploadCameraUploadClothing,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreePhotoLibraryTitle,
        tutorialType: TutorialType.freeUploadPhotoLibrary,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'WpNNCCElTrY',
            getDescription: (context) => S.of(context).memoryTutorialFreePhotoLibraryUploadClothing,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeEditCameraTitle,
        tutorialType: TutorialType.freeEditCamera,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'vzHv_VpJwss',
            getDescription: (context) => S.of(context).memoryTutorialFreeEditCameraDeclutterItems,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialFreeCreateOutfitTitle,
        tutorialType: TutorialType.freeCreateOutfit,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'J8PBmLyHvg8',
            getDescription: (context) => S.of(context).memoryTutorialFreeCreateOutfitCreateOutfitProcess,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidFilterTitle,
        tutorialType: TutorialType.paidFilter,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'BJt5lGJb0Ng',
            getDescription: (context) => S.of(context).memoryTutorialPaidFilterFindInCloset,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidCustomizeTitle,
        tutorialType: TutorialType.paidCustomize,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'UTNqr_VHAeI',
            getDescription: (context) => S.of(context).memoryTutorialPaidCustomizeViewAllItems,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidMultiClosetTitle,
        tutorialType: TutorialType.paidMultiCloset,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'cNJALyXLzrc',
            getDescription: (context) => S.of(context).memoryTutorialPaidMultiClosetCreateCapsule,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidCalendarTitle,
        tutorialType: TutorialType.paidCalendar,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'yoIMoX71Qkw',
            getDescription: (context) => S.of(context).memoryTutorialPaidCalendarTrackFirstExperiences,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialPaidUsageAnalyticsTitle,
        tutorialType: TutorialType.paidUsageAnalytics,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'opP4eiXY7jI',
            getDescription: (context) => S.of(context).memoryTutorialPaidUsageAnalyticsCostPerWear,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialClosetUploadedTitle,
        tutorialType: TutorialType.freeClosetUpload,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'fFPEBUtfLDg',
            getDescription: (context) => S.of(context).memoryTutorialClosetUploaded,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialScenarioTitle,
        tutorialType: TutorialType.flowIntroMemory,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'odERINOWkSA',
            getDescription: (context) => S.of(context).memoryScenarioTutorial,
          ),
        ],
      ),
    ];
  }
}
