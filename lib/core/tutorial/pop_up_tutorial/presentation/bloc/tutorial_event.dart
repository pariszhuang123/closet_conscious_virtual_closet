part of 'tutorial_bloc.dart';

abstract class TutorialEvent {}

class CheckTutorialStatus extends TutorialEvent {
  final String tutorialInput;
  CheckTutorialStatus(this.tutorialInput);
}

class SaveTutorialProgress extends TutorialEvent {
  final String tutorialInput;
  final bool dismissedByButton;

  SaveTutorialProgress(this.tutorialInput, this.dismissedByButton);
}
