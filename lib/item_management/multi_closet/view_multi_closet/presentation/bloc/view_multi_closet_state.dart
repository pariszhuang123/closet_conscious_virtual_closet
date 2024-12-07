part of 'view_multi_closet_bloc.dart';

abstract class ViewMultiClosetState {}

class ViewMultiClosetsInitial extends ViewMultiClosetState {}

class ViewMultiClosetsLoading extends ViewMultiClosetState {}

class ViewMultiClosetsLoaded extends ViewMultiClosetState {
  final List<MultiClosetMinimal> closets;

  ViewMultiClosetsLoaded(this.closets);
}

class ViewMultiClosetsError extends ViewMultiClosetState {
  final String error;

  ViewMultiClosetsError(this.error);
}
