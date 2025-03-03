part of 'focus_or_create_closet_bloc.dart';

abstract class FocusOrCreateClosetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFocusOrCreateCloset extends FocusOrCreateClosetEvent {}

class UpdateFocusOrCreateCloset extends FocusOrCreateClosetEvent {
  final bool isSelectable;

  UpdateFocusOrCreateCloset(this.isSelectable);

  @override
  List<Object> get props => [isSelectable];
}
