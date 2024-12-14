part of 'swap_closet_bloc.dart';

class SwapClosetState extends Equatable {
  final List<MultiClosetMinimal> closets;
  final String? selectedClosetId;
  final ClosetSwapStatus status;
  final String? error;

  const SwapClosetState({
    this.closets = const [],
    this.selectedClosetId,
    this.status = ClosetSwapStatus.initial,
    this.error,
  });

  SwapClosetState copyWith({
    List<MultiClosetMinimal>? closets,
    String? selectedClosetId,
    ClosetSwapStatus? status,
    String? error,
  }) {
    return SwapClosetState(
      closets: closets ?? this.closets,
      selectedClosetId: selectedClosetId ?? this.selectedClosetId,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [closets, selectedClosetId, status, error];
}

class SwapClosetInitial extends SwapClosetState {}

class SwapClosetNavigateToMyClosetState extends SwapClosetState {}
