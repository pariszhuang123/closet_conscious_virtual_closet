part of 'reappear_closet_bloc.dart';

abstract class ReappearClosetEvent extends Equatable {
  const ReappearClosetEvent();

  @override
  List<Object?> get props => [];
}

class UpdateReappearClosetSharedPreferenceEvent extends ReappearClosetEvent {
  final String closetId;

  const UpdateReappearClosetSharedPreferenceEvent({required this.closetId});

  @override
  List<Object?> get props => [closetId];
}
