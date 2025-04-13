part of 'tutorial_bloc.dart';

abstract class TutorialEvent extends Equatable {
  const TutorialEvent();

  @override
  List<Object?> get props => [];
}

class CheckTutorialStatus extends TutorialEvent {
  final TutorialType tutorialType;
  const CheckTutorialStatus(this.tutorialType);

  @override
  List<Object?> get props => [tutorialType];
}

class LoadTutorialFeatureData extends TutorialEvent {
  final TutorialType tutorialType;
  final OnboardingJourneyType journeyType;

  const LoadTutorialFeatureData({
    required this.tutorialType,
    required this.journeyType,
  });

  @override
  List<Object?> get props => [tutorialType, journeyType];
}

class SaveTutorialProgress extends TutorialEvent {
  final String tutorialInput;
  final TutorialDismissType dismissType;

  const SaveTutorialProgress({
    required this.tutorialInput,
    required this.dismissType,
  });

  @override
  List<Object?> get props => [tutorialInput, dismissType];
}
