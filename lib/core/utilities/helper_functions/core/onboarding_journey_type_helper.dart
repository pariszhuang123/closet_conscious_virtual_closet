import '../../../core_enums.dart';

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
