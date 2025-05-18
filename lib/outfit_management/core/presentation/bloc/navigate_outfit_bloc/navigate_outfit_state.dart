part of 'navigate_outfit_bloc.dart';

abstract class NavigateOutfitState extends Equatable {
  const NavigateOutfitState();
}

class InitialNavigateOutfitState extends NavigateOutfitState {
  @override
  List<Object?> get props => [];
}

class NavigateToReviewPageState extends NavigateOutfitState {
  final String outfitId;

  const NavigateToReviewPageState({required this.outfitId});

  @override
  List<Object?> get props => [outfitId];
}

class NpsSurveyTriggeredState extends NavigateOutfitState {
  final int milestone;

  const NpsSurveyTriggeredState({required this.milestone});

  @override
  List<Object?> get props => [milestone];
}

// New failure state for handling errors in achievement fetch or save
class NavigateOutfitFailureState extends NavigateOutfitState {
  final String error;

  const NavigateOutfitFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}
class NoReviewNeededState extends NavigateOutfitState {
  const NoReviewNeededState();

  @override
  List<Object?> get props => [];
}

class NavigateOutfitIdleState extends NavigateOutfitState {
  const NavigateOutfitIdleState();

  @override
  List<Object?> get props => [];
}
