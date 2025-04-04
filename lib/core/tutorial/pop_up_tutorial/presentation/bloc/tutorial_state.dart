part of 'tutorial_bloc.dart';

abstract class TutorialState {}

class TutorialInitial extends TutorialState {}

class ShowTutorial extends TutorialState {}

class SkipTutorial extends TutorialState {}

class TutorialSaveSuccess extends TutorialState {
  final bool dismissedByButton;
  TutorialSaveSuccess(this.dismissedByButton);
}

class TutorialSaveFailure extends TutorialState {}
