part of 'focus_or_create_closet_bloc.dart';

abstract class FocusOrCreateClosetState extends Equatable {
  @override
  List<Object> get props => [];
}

class FocusOrCreateClosetInitial extends FocusOrCreateClosetState {}

class FocusOrCreateClosetLoading extends FocusOrCreateClosetState {}

class FocusOrCreateClosetSaving extends FocusOrCreateClosetState {}

class FocusOrCreateClosetLoaded extends FocusOrCreateClosetState {
  final bool isCalendarSelectable;

  FocusOrCreateClosetLoaded({required this.isCalendarSelectable});

  @override
  List<Object> get props => [isCalendarSelectable];
}

class FocusOrCreateClosetError extends FocusOrCreateClosetState {}
