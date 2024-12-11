part of 'edit_multi_closet_bloc.dart';

class EditMultiClosetState extends Equatable {
  final ClosetStatus status;
  final String? error;
  final Map<String, String>? validationErrors;


  const EditMultiClosetState({
    this.status = ClosetStatus.initial,
    this.error,
    this.validationErrors,
  });

  EditMultiClosetState copyWith({
    ClosetStatus? status,
    String? error,
    Map<String, String>? validationErrors,
  }) {
    return EditMultiClosetState(
      status: status ?? this.status,
      error: error ?? this.error,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  @override
  List<Object?> get props => [status, error, validationErrors];
}
