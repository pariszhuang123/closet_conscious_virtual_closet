part of 'multi_selection_outfit_cubit.dart';

class MultiSelectionOutfitState extends Equatable {
  final List<String> selectedOutfitIds;
  final bool hasSelectedOutfits;

  const MultiSelectionOutfitState({
    this.selectedOutfitIds = const [],
    this.hasSelectedOutfits = false,
  });

  MultiSelectionOutfitState copyWith({
    List<String>? selectedOutfitIds,
    bool? hasSelectedOutfits,
  }) {
    return MultiSelectionOutfitState(
      selectedOutfitIds: selectedOutfitIds ?? this.selectedOutfitIds,
      hasSelectedOutfits: hasSelectedOutfits ?? this.hasSelectedOutfits,
    );
  }

  @override
  List<Object?> get props => [selectedOutfitIds, hasSelectedOutfits];
}

class MultiSelectionOutfitLoaded extends MultiSelectionOutfitState {
  const MultiSelectionOutfitLoaded({
    required super.selectedOutfitIds,
    required super.hasSelectedOutfits,
  });
}
