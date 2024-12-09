part of 'create_multi_closet_bloc.dart';

class CreateMultiClosetState extends Equatable {
  final ClosetStatus status;
  final String? error;
  final Map<String, String>? validationErrors;


  const CreateMultiClosetState({
    this.status = ClosetStatus.initial,
    this.error,
    this.validationErrors,
  });

  CreateMultiClosetState copyWith({
    ClosetStatus? status,
    String? error,
    Map<String, String>? validationErrors,
  }) {
    return CreateMultiClosetState(
      status: status ?? this.status,
      error: error ?? this.error,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  @override
  List<Object?> get props => [status, error, validationErrors];
}
