part of 'calendar_navigation_bloc.dart';

abstract class CalendarNavigationState extends Equatable {
  const CalendarNavigationState();

  @override
  List<Object?> get props => [];
}

class CalendarNavigationInitialState extends CalendarNavigationState {}

class CalendarNavigationErrorState extends CalendarNavigationState {}

class CalendarAccessState extends CalendarNavigationState {
  final AccessStatus accessStatus;

  const CalendarAccessState({this.accessStatus = AccessStatus.pending});

  CalendarAccessState copyWith({AccessStatus? accessStatus}) {
    return CalendarAccessState(
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }

  @override
  List<Object> get props => [accessStatus];
}


class MultiClosetNavigationErrorState extends CalendarNavigationState {}
