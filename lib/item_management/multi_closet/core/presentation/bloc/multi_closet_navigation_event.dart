part of 'multi_closet_navigation_bloc.dart';

abstract class MultiClosetNavigationEvent {}

class NavigateToViewMultiCloset extends MultiClosetNavigationEvent {}

class NavigateToCreateMultiCloset extends MultiClosetNavigationEvent {}

class NavigateToEditSingleMultiCloset extends MultiClosetNavigationEvent {
  final String closetId;

  NavigateToEditSingleMultiCloset(this.closetId);
}

class NavigateToEditAllMultiCloset extends MultiClosetNavigationEvent {}

class NavigateToFilterProvider extends MultiClosetNavigationEvent {}

class NavigateToCustomizeProvider extends MultiClosetNavigationEvent {}

class CheckMultiClosetAccessEvent extends MultiClosetNavigationEvent {}
