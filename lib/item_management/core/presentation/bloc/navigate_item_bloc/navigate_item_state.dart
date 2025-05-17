part of 'navigate_item_bloc.dart';

abstract class NavigateItemState extends Equatable {
  const NavigateItemState();
}

class InitialNavigateItemState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchDisappearedClosetsInProgressState extends NavigateItemState {
  @override
  List<Object?> get props => [];
}

class FetchDisappearedClosetsSuccessState extends NavigateItemState {
  final String closetId;
  final String closetImage;
  final String closetName;

  const FetchDisappearedClosetsSuccessState({
    required this.closetId,
    required this.closetImage,
    required this.closetName,
  });

  @override
  List<Object?> get props => [closetId, closetImage, closetName];
}

// New failure state for handling errors in achievement fetch or save
class NavigateItemFailureState extends NavigateItemState {
  final String error;

  const NavigateItemFailureState({required this.error});

  @override
  List<Object?> get props => [error];
}

