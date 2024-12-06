part of 'multi_closet_navigation_bloc.dart';

abstract class MultiClosetNavigationState {}

class ViewMultiClosetNavigationState extends MultiClosetNavigationState {}

class CreateMultiClosetNavigationState extends MultiClosetNavigationState {}

class EditSingleMultiClosetNavigationState extends MultiClosetNavigationState {
  final String closetId;

  EditSingleMultiClosetNavigationState(this.closetId);
}

class EditAllMultiClosetNavigationState extends MultiClosetNavigationState {}

class FilterProviderNavigationState extends MultiClosetNavigationState {}

class CustomizeProviderNavigationState extends MultiClosetNavigationState {}

class MultiClosetAccessGrantedState extends MultiClosetNavigationState {}
class MultiClosetAccessDeniedState extends MultiClosetNavigationState {}

class MultiClosetNavigationErrorState extends MultiClosetNavigationState {}
