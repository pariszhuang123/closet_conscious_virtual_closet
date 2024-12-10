part of 'multi_selection_closet_cubit.dart';

class MultiSelectionClosetState extends Equatable {
  final List<String> selectedClosetIds;
  final bool hasSelectedClosets;

  const MultiSelectionClosetState({
    this.selectedClosetIds = const [],
    this.hasSelectedClosets = false,
  });

  MultiSelectionClosetState copyWith({
    List<String>? selectedClosetIds,
    bool? hasSelectedClosets,
  }) {
    return MultiSelectionClosetState(
      selectedClosetIds: selectedClosetIds ?? this.selectedClosetIds,
      hasSelectedClosets: hasSelectedClosets ?? this.hasSelectedClosets,
    );
  }

  @override
  List<Object?> get props => [selectedClosetIds, hasSelectedClosets];
}

class MultiSelectionClosetLoaded extends MultiSelectionClosetState {
  const MultiSelectionClosetLoaded({
    required super.selectedClosetIds,
    required super.hasSelectedClosets,
  });
}
