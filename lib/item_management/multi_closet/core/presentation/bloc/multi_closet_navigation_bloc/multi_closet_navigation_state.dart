part of 'multi_closet_navigation_bloc.dart';

abstract class MultiClosetNavigationState extends Equatable {
  const MultiClosetNavigationState();

  @override
  List<Object?> get props => [];
}

class ViewMultiClosetNavigationState extends MultiClosetNavigationState {}

class CreateMultiClosetNavigationState extends MultiClosetNavigationState {}

class EditSingleMultiClosetNavigationState extends MultiClosetNavigationState {
  final String closetId;

  const EditSingleMultiClosetNavigationState(this.closetId);

  @override
  List<Object> get props => [closetId];
}

class EditAllMultiClosetNavigationState extends MultiClosetNavigationState {}

class FilterProviderNavigationState extends MultiClosetNavigationState {}

class CustomizeProviderNavigationState extends MultiClosetNavigationState {}

class MultiClosetNavigationErrorState extends MultiClosetNavigationState {}

class MultiClosetAccessState extends MultiClosetNavigationState {
  final AccessStatus accessStatus;

  const MultiClosetAccessState({this.accessStatus = AccessStatus.pending});

  MultiClosetAccessState copyWith({AccessStatus? accessStatus}) {
    return MultiClosetAccessState(
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  @override
  List<Object> get props => [accessStatus];
}
