part of 'create_multi_closet_bloc.dart';

class CreateMultiClosetState extends Equatable {
  final ClosetStatus status;
  final String? error;

  const CreateMultiClosetState({
    this.status = ClosetStatus.initial,
    this.error,
  });

  CreateMultiClosetState copyWith({
    ClosetStatus? status,
    String? error,
  }) {
    return CreateMultiClosetState(
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
