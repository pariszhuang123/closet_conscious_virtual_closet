part of 'tutorial_bloc.dart';

abstract class TutorialState extends Equatable {
  const TutorialState();

  @override
  List<Object?> get props => [];
}

class TutorialInitial extends TutorialState {}

class ShowTutorial extends TutorialState {}

class SkipTutorial extends TutorialState {}

class TutorialSaveSuccess extends TutorialState {
  final bool dismissedByButton;
  const TutorialSaveSuccess(this.dismissedByButton);

  @override
  List<Object?> get props => [dismissedByButton];
}

class TutorialSaveFailure extends TutorialState {}
