part of 'tutorial_bloc.dart';

abstract class TutorialState extends Equatable {
  const TutorialState();

  @override
  List<Object?> get props => [];
}

class TutorialInitial extends TutorialState {}

class TutorialFeatureLoading extends TutorialState {}

class TutorialFeatureLoaded extends TutorialState {
  final TutorialFeatureData featureData;

  const TutorialFeatureLoaded(this.featureData);

  @override
  List<Object?> get props => [featureData];
}

class TutorialFeatureLoadFailure extends TutorialState {}

class ShowTutorial extends TutorialState {
  final TutorialType tutorialType;

  const ShowTutorial(this.tutorialType);

  @override
  List<Object?> get props => [tutorialType];
}

class SkipTutorial extends TutorialState {
  final TutorialType tutorialType;

  const SkipTutorial(this.tutorialType);

  @override
  List<Object?> get props => [tutorialType];
}

class TutorialSaveSuccess extends TutorialState {
  final TutorialDismissType dismissType;

  const TutorialSaveSuccess(this.dismissType);

  @override
  List<Object?> get props => [dismissType];
}

class TutorialSaveFailure extends TutorialState {}
