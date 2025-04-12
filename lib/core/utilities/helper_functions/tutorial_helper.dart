import '../../core_enums.dart';

extension TutorialTypeExtension on TutorialType {
  String get value {
    switch (this) {
      case TutorialType.freeUploadCamera:
        return 'free_upload_camera';
      case TutorialType.freeUploadPhotoLibrary:
        return 'free_upload_photo_library';
      case TutorialType.freeEditCamera:
        return 'free_edit_camera';
      case TutorialType.freeCreateOutfit:
        return 'free_create_outfit';
      case TutorialType.freeClosetUpload:
        return 'free_closet_upload';
      case TutorialType.freeInfoHub:
        return 'free_info_hub';
      case TutorialType.paidFilter:
        return 'paid_filter';
      case TutorialType.paidCustomize:
        return 'paid_customize';
      case TutorialType.paidMultiCloset:
        return 'paid_multi_closet';
      case TutorialType.paidCalendar:
        return 'paid_calendar';
      case TutorialType.paidUsageAnalytics:
        return 'paid_usage_analytics';
      case TutorialType.flowIntroDefault:
        return 'flow_intro_default';
      case TutorialType.flowIntroMemory:
        return 'flow_intro_memory';
      case TutorialType.flowIntroPersonalStyle:
        return 'flow_intro_personal_style';
      case TutorialType.flowIntroLifeChange:
        return 'flow_intro_life_change';
    }
  }
}

extension TutorialTypeParser on String {
  TutorialType toTutorialType() {
    return TutorialType.values.firstWhere(
          (type) => type.value == this,
      orElse: () => TutorialType.freeUploadCamera,
    );
  }
}

extension OnboardingJourneyTypeExtension on OnboardingJourneyType {
  String get value {
    switch (this) {
      case OnboardingJourneyType.defaultFlow:
        return 'default_flow';
      case OnboardingJourneyType.memoryFlow:
        return 'memory_flow';
      case OnboardingJourneyType.personalStyleFlow:
        return 'personal_style_flow';
      case OnboardingJourneyType.lifeChangeFlow:
        return 'life_change_flow';
    }
  }
}

extension OnboardingJourneyTypeParser on String {
  OnboardingJourneyType toOnboardingJourneyType() {
    return OnboardingJourneyType.values.firstWhere(
          (type) => type.value == this,
      orElse: () => OnboardingJourneyType.defaultFlow,
    );
  }
}

extension OnboardingJourneyTypeX on OnboardingJourneyType {
  TutorialType toTutorialType() {
    switch (this) {
      case OnboardingJourneyType.personalStyleFlow:
        return TutorialType.flowIntroPersonalStyle;
      case OnboardingJourneyType.lifeChangeFlow:
        return TutorialType.flowIntroLifeChange;
      case OnboardingJourneyType.memoryFlow:
        return TutorialType.flowIntroMemory;
      default:
        return TutorialType.flowIntroPersonalStyle;
    }
  }
}
