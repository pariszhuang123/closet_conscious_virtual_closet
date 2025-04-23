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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'l0nRohnLGhU',
            getDescription: (context) => S.of(context).personalStyleTutorialFreeUploadCameraUploadClothing,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'W9sHTm4s41s',
            getDescription: (context) => S.of(context).lifeChangeTutorialFreeUploadCameraUploadClothing,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'q6T244LtHrE',
            getDescription: (context) => S.of(context).personalStyleTutorialFreePhotoLibraryUploadClothing,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'ekoaP107FGs',
            getDescription: (context) => S.of(context).lifeChangeTutorialFreePhotoLibraryUploadClothing,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'e26-1xzcZPY',
            getDescription: (context) => S.of(context).personalStyleTutorialFreeEditCameraDeclutterItems,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: '0lEA4XSc47U',
            getDescription: (context) => S.of(context).lifeChangeTutorialFreeEditCameraDeclutterItems,
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
            getDescription: (context) => S.of(context).memoryTutorialFreeCreateOutfitProcess,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'Rcsr8eTa440',
            getDescription: (context) => S.of(context).personalStyleTutorialFreeCreateOutfitProcess,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: '4ZzAxvjUDno',
            getDescription: (context) => S.of(context).lifeChangeTutorialFreeCreateOutfitProcess,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'XNfvpuDgmaI',
            getDescription: (context) => S.of(context).personalStyleTutorialPaidFilterFindInCloset,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'TPchWQpfXj0',
            getDescription: (context) => S.of(context).lifeChangeTutorialPaidFilterFindInCloset,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'xTB_wkJwdBc',
            getDescription: (context) => S.of(context).personalStyleTutorialPaidCustomizeViewAllItems,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'MeObSW2OAdA',
            getDescription: (context) => S.of(context).lifeChangeTutorialPaidCustomizeViewAllItems,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'APLQUXhN6Hg',
            getDescription: (context) => S.of(context).personalStyleTutorialPaidMultiClosetCreateCapsule,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'jYkCsyiF3s0',
            getDescription: (context) => S.of(context).lifeChangeTutorialPaidMultiClosetCreateCapsule,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'nl4rnHgzPgI',
            getDescription: (context) => S.of(context).personalStyleTutorialPaidCalendarTrackFirstExperiences,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'MDNA6ox9gRU',
            getDescription: (context) => S.of(context).lifeChangeTutorialPaidCalendarTrackFirstExperiences,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'js1Cshm0INc',
            getDescription: (context) => S.of(context).personalStyleTutorialPaidUsageAnalyticsCostPerWear,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'StfYGfkFPqA',
            getDescription: (context) => S.of(context).lifeChangeTutorialPaidUsageAnalyticsCostPerWear,
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
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'm4G3apU0XlI',
            getDescription: (context) => S.of(context).personalStyleTutorialClosetUploaded,
          ),
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'fVEHeGsuKXc',
            getDescription: (context) => S.of(context).lifeChangeTutorialClosetUploaded,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialScenarioTitle,
        tutorialType: TutorialType.flowIntroPersonalStyle,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.personalStyleFlow,
            youtubeId: 'O0COqY4ak0Y',
            getDescription: (context) => S.of(context).personalStyleScenarioTutorial,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialScenarioTitle,
        tutorialType: TutorialType.flowIntroLifeChange,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.lifeChangeFlow,
            youtubeId: 'fq7Y4iwd2Ns',
            getDescription: (context) => S.of(context).lifeChangeScenarioTutorial,
          ),
        ],
      ),
      TutorialFeatureData(
        getTitle: (context) => S.of(context).tutorialScenarioTitle,
        tutorialType: TutorialType.flowIntroMemory,
        videos: [
          TutorialVideoPart(
            journeyType: OnboardingJourneyType.memoryFlow,
            youtubeId: 'UPCh59qIflw',
            getDescription: (context) => S.of(context).memoryScenarioTutorial,
          ),
        ],
      ),
    ];
  }
}
