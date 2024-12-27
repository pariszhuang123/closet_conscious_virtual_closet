part of 'reappear_closet_bloc.dart';

abstract class ReappearClosetState extends Equatable {
  const ReappearClosetState();

  @override
  List<Object?> get props => [];
}

class ReappearClosetInitialState extends ReappearClosetState {}

class ReappearClosetUpdatedState extends ReappearClosetState {}

class ReappearClosetErrorState extends ReappearClosetState {
  final String error;

  const ReappearClosetErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
