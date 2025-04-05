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

class SaveTutorialProgress extends TutorialEvent {
  final String tutorialInput;
  final bool dismissedByButton;

  const SaveTutorialProgress({
    required this.tutorialInput,
    required this.dismissedByButton,
  });

  @override
  List<Object?> get props => [tutorialInput, dismissedByButton];
}
